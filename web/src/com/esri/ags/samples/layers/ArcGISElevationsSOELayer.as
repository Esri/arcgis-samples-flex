package com.esri.ags.samples.layers
{

import com.esri.ags.geometry.Extent;
import com.esri.ags.layers.MapImageLayer;
import com.esri.ags.layers.supportClasses.MapImage;
import com.esri.ags.samples.tasks.supportClasses.ElevationsSOEResult;

import flash.display.Bitmap;
import flash.display.BitmapData;

import mx.events.FlexEvent;

/**
 * Allows you to visualize the ElevationsSOE - GetElevationData response as a layer in the ArcGIS API for Flex.
 *
 * <p>Note that ArcGISElevationsSOELayer, like all layers, extend <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html">UIComponent</a> and thus include basic mouse events, such as:
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:click">click</a>,
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseOut">mouseOut</a>,
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseOver">mouseOver</a>, and
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseDown">mouseDown</a>,
 * as well as other events like
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html#event:show">show</a> and
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html#event:hide">hide</a>,
 * and general properties, such as
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#alpha">alpha</a> and
 * <a target="_blank" href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#visible">visible</a>.</p>
 *
 * <p>Note: ElevationsSOEResult, and other elevations SOE related classes, require a custom Server Objection Extension (SOE) service.
 * <a href="http://sampleserver4.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/MapServer/exts/ElevationsSOE" target="_blank">View the service</a>.</p>
 *
 * @since Your API for Flex 1.0
 *
 * @see com.esri.ags.samples.tasks.ElevationsSOETask
 */
public class ArcGISElevationsSOELayer extends MapImageLayer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Creates a new ArcGISElevationsSOELayer object.
     */
    public function ArcGISElevationsSOELayer()
    {
        super();
        addEventListener(FlexEvent.INITIALIZE, initializeHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _bitmapData:BitmapData;
    private var _mapImage:MapImage = new MapImage();

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  elevationResult
    //----------------------------------

    private var _elevationResult:ElevationsSOEResult;
    private var _elevationResultChanged:Boolean = false;

    /**
     * Result of a GetElevationData request from the ElevationsSOE, this contains properties used to render the elevation surface.
     */
    public function get elevationResult():ElevationsSOEResult
    {
        return _elevationResult;
    }

    /**
     * @private
     */
    public function set elevationResult(value:ElevationsSOEResult):void
    {
        if (_elevationResult !== value)
        {
            _elevationResult = value;
            _elevationResultChanged = true;
            invalidateProperties();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function commitProperties():void
    {
        super.commitProperties();

        if (_elevationResultChanged)
        {
            _elevationResultChanged = false;

            if (!_elevationResult)
            {
                mapImageProvider = null;
                if (_bitmapData)
                {
                    _bitmapData.dispose();
                    _bitmapData = null;
                    _mapImage.source = null;
                    _mapImage.extent = null;
                }
            }
            else
            {
                var cellColors:Vector.<uint> = calculateCellColors(elevationResult.elevationData);
                const cols:int = elevationResult.numberOfColumns;
                const rows:int = elevationResult.numberOfRows;
                if (_bitmapData === null || _bitmapData.width != cols || _bitmapData.height != rows)
                {
                    if (_bitmapData)
                    {
                        _bitmapData.dispose();
                        _bitmapData = null;
                    }
                    _bitmapData = new BitmapData(cols, rows, true, 0x00000000);
                }

                _bitmapData.lock();
                try
                {
                    var cell:int = 0;
                    for (var r:int = 0; r < rows; r++)
                    {
                        for (var c:int = 0; c < cols; c++)
                        {
                            _bitmapData.setPixel32(c, r, cellColors[cell]);
                            cell++;
                        }
                    }
                }
                finally
                {
                    _bitmapData.unlock();
                }

                var mapImageExtent:Extent = new Extent(elevationResult.xCoordLLCenter,
                                                       elevationResult.yCoordLLCenter,
                                                       elevationResult.xCoordLLCenter + cols * elevationResult.cellSizeH,
                                                       elevationResult.yCoordLLCenter + rows * elevationResult.cellSizeV,
                                                       elevationResult.spatialReference);

                _mapImage.source = new Bitmap(_bitmapData);
                _mapImage.extent = mapImageExtent;

                mapImageProvider = _mapImage;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Clears the layer and sets the elevationResult to null.
     */
    public function clear():void
    {
        graphics.clear();
        elevationResult = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function calculateCellColors(elevationData:Array):Vector.<uint>
    {
        var cellColors:Vector.<uint> = new Vector.<uint>(elevationData.length, true);

        var thematicMin:int = elevationData[0];
        var thematicMax:int = elevationData[0];

        var i:int;
        var elevationValue:int;
        for (i = elevationData.length - 1; i >= 0; i--)
        {
            elevationValue = elevationData[i];
            if (elevationValue < thematicMin)
            {
                thematicMin = elevationValue;
            }
            if (elevationValue > thematicMax)
            {
                thematicMax = elevationValue;
            }
        }

        //Blue, Green, Yellow, Orange, Red, White - ARGB (Alpha Red Green Blue)
        var colorRanges:Array = [ 0xFF298D3D, 0xFF3759FA, 0xFFE1FF00, 0xFFE87300, 0xFFE20000, 0xFFF6C5C5 ];
        var lastColorRangeIndex:int = colorRanges.length - 1;
        var totalRange:int = thematicMax - thematicMin;
        var portion:int = totalRange / colorRanges.length;

        var thematicRangeValues:Array;
        var minValue:int = thematicMin;
        var maxValue:int = thematicMin + portion;

        var startValue:int;
        var elevValue:int;

        for (i = elevationData.length - 1; i >= 0; i--)
        {
            elevValue = elevationData[i];
            startValue = thematicMin;
            for (var j:int = 0; j < colorRanges.length; j++)
            {
                thematicRangeValues = getEnumerableRange(startValue, portion);
                if (thematicRangeValues.indexOf(elevValue) != -1)
                {
                    cellColors[i] = colorRanges[j];
                    break;
                }
                else if (j == lastColorRangeIndex)
                {
                    cellColors[i] = colorRanges[lastColorRangeIndex];
                    break;
                }
                startValue = startValue + portion;
            }
        }

        return cellColors;
    }

    /**
     * @private
     */
    private function getEnumerableRange(start:int, count:int):Array
    {
        var range:Array = [];
        var beginNum:int = start;
        for (var i:int = 0; i < count; i++)
        {
            range.push(beginNum);
            beginNum++;
        }
        return range;
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    private function initializeHandler(event:FlexEvent):void
    {
        removeEventListener(FlexEvent.INITIALIZE, initializeHandler);
        setLoaded(true);
    }
}

}
