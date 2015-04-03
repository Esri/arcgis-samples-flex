package com.esri.ags.samples.layers
{

import com.esri.ags.Graphic;
import com.esri.ags.TimeExtent;
import com.esri.ags.clusterers.supportClasses.Cluster;
import com.esri.ags.events.DetailsEvent;
import com.esri.ags.events.ExtentEvent;
import com.esri.ags.events.LayerEvent;
import com.esri.ags.events.QueryEvent;
import com.esri.ags.events.TimeExtentEvent;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.Layer;
import com.esri.ags.layers.supportClasses.LayerDetails;
import com.esri.ags.samples.events.HeatMapEvent;
import com.esri.ags.samples.layers.supportClasses.HeatMapGradientDict;
import com.esri.ags.tasks.DetailsTask;
import com.esri.ags.tasks.QueryTask;
import com.esri.ags.tasks.supportClasses.Query;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.Shape;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.utils.Dictionary;

import mx.collections.ArrayList;
import mx.collections.IList;
import mx.events.FlexEvent;
import mx.rpc.events.FaultEvent;

//--------------------------------------
//  Events
//--------------------------------------
/**
 * Dispatched when the ArcGISHeatMapLayer is in scale range.
 *
 * @eventType LayerEvent.IS_IN_SCALE_RANGE_CHANGE
 */
[Event(name="isInScaleRangeChange", type="com.esri.ags.events.LayerEvent")]
/**
 * Dispatched when the ArcGISHeatMapLayer successfully loads.
 *
 * @eventType LayerEvent.LOAD
 */
[Event(name="load", type="com.esri.ags.events.LayerEvent")]
/**
 * Dispatched when the ArcGISHeatMapLayer unsuccessfully loads.
 *
 * @eventType LayerEvent.LOAD_ERROR
 */
[Event(name="loadError", type="com.esri.ags.events.LayerEvent")]
/**
 * Dispatched when the ArcGISHeatMapLayer successfully updates.
 *
 * @eventType LayerEvent.UPDATE_END
 */
[Event(name="updateEnd", type="com.esri.ags.events.LayerEvent")]
/**
 * Dispatched when the ArcGISHeatMapLayer starts the update process.
 *
 * @eventType LayerEvent.UPDATE_START
 */
[Event(name="updateStart", type="com.esri.ags.events.LayerEvent")]
/**
 * Dispatched when the ArcGISHeatMapLayer ends the getDetails process.
 *
 * @eventType DetailsEvent.GET_DETAILS_COMPLETE
 */
[Event(name="getDetailsComplete", type="com.esri.ags.events.DetailsEvent")]
/**
 * Dispatched when the ArcGISHeatMapLayer starts the refresh process.
 *
 * @eventType HeatMapEvent.REFRESH_START
 */
[Event(name="refreshStart", type="com.esri.ags.samples.events.HeatMapEvent")]
/**
 * Dispatched when the ArcGISHeatMapLayer ends the refresh process.
 *
 * @eventType HeatMapEvent.REFRESH_END
 */
[Event(name="refreshEnd", type="com.esri.ags.samples.events.HeatMapEvent")]

/**
 * Allows you to generate a client-side dynamic heatmap on the fly through querying a layer resource (points only) exposed by the ArcGIS Server REST API (available in ArcGIS Server 9.3 and above).
 * This layer also supports time through setting the time extent directly on the layer, or through the map the layer is contained within.
 * It is also aware of extent changes and time extent events triggered by its parent containing map, these events will cause the layer to be re-queried and the heatmap generated again.
 *
 * <p>Note that ArcGISHeatMapLayer, like all layers, extend <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html" target="external">UIComponent</a> and thus include basic mouse events, for example:
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:click" target="external">click</a>,
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseOut" target="external">mouseOut</a>,
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseOver" target="external">mouseOver</a>, and
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/InteractiveObject.html#event:mouseDown" target="external">mouseDown</a>,
 * as well as other events like
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html#event:show" target="external">show</a> and
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/core/UIComponent.html#event:hide" target="external">hide</a>,
 * and general properties, such as
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#alpha" target="external">alpha</a> and
 * <a href="http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/DisplayObject.html#visible" target="external">visible</a>.</p>
 *
 * MXML usage of ArcGISHeatMapLayer:
 * <listing version="3.0">
 * &lt;esri:Map&gt;
 *      &lt;layers:ArcGISHeatMapLayer id="heatMapLayer"
 *                                    outFields="*"
 *                                    url="http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/Earthquakes/Since_1970/MapServer/0"/&gt;
 * &lt;/esri:Map&gt;</listing>
 *
 * @see com.esri.ags.events.DetailsEvent
 * @see com.esri.ags.events.ExtentEvent
 * @see com.esri.ags.events.LayerEvent
 * @see com.esri.ags.events.QueryEvent
 * @see com.esri.ags.events.TimeExtentEvent
 * @see com.esri.ags.samples.events.HeatMapEvent
 */
public class ArcGISHeatMapLayer extends Layer
{
    private var _url:String;
    private var _where:String = "1=1";
    private var _useAMF:Boolean = false;
    private var _proxyURL:String;
    private var _token:String;
    private var _outFields:Array;
    private var _timeExtent:TimeExtent;
    private var _urlPartsArray:Array;
    private var _detailsTask:DetailsTask;
    private var _layerDetails:LayerDetails;

    private var _heatMapQueryTask:QueryTask;
    private var _heatMapQuery:Query = new Query();

    private var _heatMapTheme:String = HeatMapGradientDict.RAINBOW_TYPE;
    private var _dataProvider:IList;
    private var _gradientDict:Array;
    private var _bitmapData:BitmapData;

    private static const POINT:Point = new Point();
    private const BLURFILTER:BlurFilter = new BlurFilter(4, 4);
    private var _densityRadius:int = 25;

    //--------------------------------------------------------------------------
    //
    //  New Properties at 3.1
    //
    //--------------------------------------------------------------------------
    private var _shape:Shape = new Shape();
    private var _center:MapPoint;
    private var _world:Number;
    private var _wrapAround:Function;

    private const _matrix1:Matrix = new Matrix();
    private const _matrix2:Matrix = new Matrix();
    private const COLORS:Array = [ 0, 0 ];
    private const ALPHAS:Array = [ 1, 1 ];
    private const RATIOS:Array = [ 0, 255 ];

    private var _clusterCount:int = 0;
    private var _clusterSize:int = 0;
    private var _clusterMaxWeight:Number = 0.0;
    private var _featureRadiusCalculator:Function = internalFeatureRadiusCalculator;
    private var _clusterRadiusCalculator:Function = internalClusterRadiusCalculator;
    private var _featureIndexCalculator:Function = internalFeatureCalculator;
    private var _clusterIndexCalculator:Function = internalClusterCalculator;
    private var _clusterWeightCalculator:Function = internalWeightCalculator;
    
    private var flagupdate:Boolean=false;

    /**
     * Creates a new ArcGISHeatMapLayer object.
     *
     * @param url URL to the ArcGIS Server REST resource that represents a point layer in map service or feature service.
     * @param proxyURL The URL to proxy the request through.
     * @param token Token for accessing a secure dynamic ArcGIS service.
     */
    public function ArcGISHeatMapLayer(url:String = null, proxyURL:String = null, token:String = null)
    {
        mouseEnabled = false;
        mouseChildren = false;
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, true);
        addEventListener(LayerEvent.UPDATE_START, updateStartCompleteHandler, false, 0, true);
        addEventListener(Event.REMOVED, removeCompleteHandler, false, 0, true);
        _url = url;
        _proxyURL = proxyURL;
        _token = token;
        _gradientDict = HeatMapGradientDict.gradientArray(_heatMapTheme);
    }

    /**
     * @private
     */
    protected function getDetailsCompleteHandler(event:DetailsEvent):void
    {
        _detailsTask.removeEventListener(DetailsEvent.GET_DETAILS_COMPLETE, getDetailsCompleteHandler);
        if (event)
        {
            _layerDetails = event.layerDetails;
        }
        invalidateHeatMap();
        dispatchEvent(event);
    }

    /**
     * @private
     */
    protected function getDetailsFaultHandler(event:FaultEvent):void
    {
        _detailsTask.removeEventListener(FaultEvent.FAULT, getDetailsFaultHandler);
        dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, this, event.fault));
    }

    /**
     * @private
     */
    protected function updateStartCompleteHandler(event:LayerEvent):void
    {
        removeEventListener(LayerEvent.UPDATE_START, updateStartCompleteHandler);
        if (map)
        {
            map.addEventListener(ExtentEvent.EXTENT_CHANGE, heatMapExtentChangeHandler);
            map.addEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, timeExtentChangeHandler);
        }
        _heatMapQueryTask = new QueryTask(_url);
        _heatMapQueryTask.addEventListener(QueryEvent.EXECUTE_COMPLETE, heatMapQueryCompleteHandler, false, 0, true);
        _heatMapQueryTask.addEventListener(FaultEvent.FAULT, heatMapQueryFaultHandler, false, 0, true);
        parseURL(_url);
        if (_urlPartsArray.length == 2)
        {
            _detailsTask = new DetailsTask(_urlPartsArray[0]);
            var layerID:Number = Number(_urlPartsArray[1]);
            _detailsTask.addEventListener(DetailsEvent.GET_DETAILS_COMPLETE, getDetailsCompleteHandler, false, 0, true);
            _detailsTask.addEventListener(FaultEvent.FAULT, getDetailsFaultHandler, false, 0, true);
            _detailsTask.getDetails(layerID);
        }
        flagupdate=true;
    }

    /**
     * @private
     */
    protected function removeCompleteHandler(event:Event):void
    {
        if (this.map)
        {
            map.removeEventListener(ExtentEvent.EXTENT_CHANGE, heatMapExtentChangeHandler);
            map.removeEventListener(TimeExtentEvent.TIME_EXTENT_CHANGE, timeExtentChangeHandler);
        }
        removeEventListener(Event.REMOVED, removeCompleteHandler);
        _heatMapQueryTask.removeEventListener(QueryEvent.EXECUTE_COMPLETE, heatMapQueryCompleteHandler);
        _heatMapQueryTask.removeEventListener(FaultEvent.FAULT, heatMapQueryFaultHandler);
    }

    /**
     * @private
     */
    protected function creationCompleteHandler(event:FlexEvent):void
    {
        removeEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        setLoaded(true);
    }

    /**
     * @private
     */
    protected function invalidateHeatMap():void
    {
        if (map && map.extent)
        {
        if(flagupdate==false)
			{
				var tagEvent:LayerEvent=new LayerEvent(LayerEvent.UPDATE_START,this);
				updateStartCompleteHandler(tagEvent);
			}
            generateHeatMap(map.extent);
        }
    }

    /**
     * @private
     */
    protected function generateHeatMap(extent:Extent):void
    {
        if (_proxyURL)
        {
            _heatMapQueryTask.proxyURL = _proxyURL;
        }
        if (_token)
        {
            _heatMapQueryTask.token = _token;
        }
        _heatMapQueryTask.useAMF = _useAMF;
        if (_where)
        {
            _heatMapQuery.where = _where;
        }
        _heatMapQuery.geometry = extent;
        _heatMapQuery.returnGeometry = true;
        _heatMapQuery.outSpatialReference = map.spatialReference;
        if (_outFields)
        {
            _heatMapQuery.outFields = _outFields;
        }
        else
        {
            _heatMapQuery.outFields = [ '*' ];
        }

        if (_timeExtent)
        {
            _heatMapQuery.timeExtent = _timeExtent;
        }

        dispatchEvent(new HeatMapEvent(HeatMapEvent.REFRESH_START));
        if (visible)
        {
            _heatMapQueryTask.execute(_heatMapQuery);
        }
    }

    /**
     * @private
     */
    protected function timeExtentChangeHandler(event:TimeExtentEvent):void
    {
        _timeExtent = event.timeExtent;
        invalidateHeatMap();
    }

    /**
     * @private
     */
    protected function heatMapExtentChangeHandler(event:ExtentEvent):void
    {
        // Perform the query, when queryComplete occurs call invalidateLayer()
        generateHeatMap(event.extent);
    }

    /**
     * @private
     */
    protected function heatMapQueryFaultHandler(event:FaultEvent):void
    {
        dispatchEvent(new LayerEvent(LayerEvent.LOAD_ERROR, this, event.fault));
    }

    /**
     * @private
     */
    protected function heatMapQueryCompleteHandler(event:QueryEvent):void
    {
        if (event)
        {
            dispatchEvent(new HeatMapEvent(HeatMapEvent.REFRESH_END, event.featureSet.features.length, event.featureSet));

            _dataProvider = new ArrayList(event.featureSet.features);

            setLoaded(true);
            invalidateLayer();
        }
    }


    /**
     * @private
     */
    private function parseURL(value:String):void
    {
        _urlPartsArray = [];
        var parseString:String = value;
        var lastPos:int = parseString.lastIndexOf("/");
        _urlPartsArray[0] = parseString.substr(0, lastPos);
        _urlPartsArray[1] = parseString.substr(lastPos + 1);
    }

    //--------------------------------------
    // overridden methods
    //--------------------------------------

    /**
     * @private
     */
    override protected function updateLayer():void
    {
        const mapW:Number = map.width;
        const mapH:Number = map.height;
        const extW:Number = map.extent.width;
        const extH:Number = map.extent.height;
        const facX:Number = mapW / extW;
        const facY:Number = mapH / extH;

        if (!_dataProvider)
        {
            return;
        }
        const len:int = _dataProvider.length;

        var i:int, feature:Graphic, mapPoint:MapPoint, cluster:Cluster, radius:Number;

        if (_bitmapData && (_bitmapData.width !== map.width || _bitmapData.height !== map.height))
        {
            _bitmapData.dispose();
            _bitmapData = null;
        }
        if (_bitmapData === null)
        {
            _bitmapData = new BitmapData(map.width, map.height, true, 0x00000000);
        }

        _bitmapData.lock();

        _bitmapData.fillRect(_bitmapData.rect, 0x00000000);

        if (map.wrapAround180)
        {
            switch (map.spatialReference.wkid)
            {
                case 102113:
                case 102100:
                case 3857:
                {
                    _world = 2.0 * 20037508.342788905;
                    break;
                }
                case 4326:
                {
                    _world = 2.0 * 180.0;
                    break;
                }
                default:
                {
                    _world = 0.0;
                }
            }
            _wrapAround = doWrapAround;
        }
        else
        {
            _world = 0.0;
            _wrapAround = noWrapAround;
        }

        if (_clusterSize)
        {
            if (_center === null)
            {
                _center = map.extent.center;
            }
            var maxWeight:Number = Number.NEGATIVE_INFINITY;
            const cellW:Number = _clusterSize * extW / mapW;
            const cellH:Number = _clusterSize * extH / mapH;
            const clusterDict:Dictionary = new Dictionary();
            for (i = 0; i < len; i++)
            {
                feature = _dataProvider.getItemAt(i) as Graphic;
                mapPoint = feature.geometry as MapPoint;
                if (map.extent.containsXY(mapPoint.x, mapPoint.y))
                {
                    const gx:int = Math.floor((mapPoint.x - _center.x) / cellW);
                    const gy:int = Math.floor((mapPoint.y - _center.y) / cellH);
                    const gk:String = gx + ":" + gy;
                    cluster = clusterDict[gk];
                    if (cluster === null)
                    {
                        const cx:Number = gx * cellW + _center.x;
                        const cy:Number = gy * cellH + _center.y;
                        clusterDict[gk] = cluster = new Cluster(new MapPoint(cx, cy), _clusterWeightCalculator(feature), [ feature ]);
                    }
                    else
                    {
                        cluster.graphics.push(feature);
                        cluster.weight += _clusterWeightCalculator(feature);
                    }
                    maxWeight = Math.max(maxWeight, cluster.weight);
                }
            }
            var count:int = 0;
            for each (cluster in clusterDict)
            {
                COLORS[0] = Math.max(0, Math.min(255, _clusterIndexCalculator(cluster, maxWeight)));
                radius = _clusterRadiusCalculator(cluster, _densityRadius, maxWeight);
                _wrapAround(cluster.center);
                count++;
            }

            _clusterCount = count;
            dispatchEvent(new Event("clusterCountChanged"));

            _clusterMaxWeight = maxWeight;
            dispatchEvent(new Event("clusterMaxWeightChanged"));
        }
        else
        {
            for (i = 0; i < len; i++)
            {
                feature = _dataProvider.getItemAt(i) as Graphic;
                mapPoint = feature.geometry as MapPoint;
                COLORS[0] = Math.max(0, Math.min(255, _featureIndexCalculator(feature)));
                radius = _featureRadiusCalculator(feature, _densityRadius);
                _wrapAround(mapPoint);
            }
        }
        // paletteMap leaves some artifacts unless we get rid of the blackest colors
        _bitmapData.threshold(_bitmapData, _bitmapData.rect, POINT, "<", 0x00000001, 0x00000000, 0x000000FF, true);
        // Replace the black and blue with the gradient. Blacker pixels will get their new colors from
        // the beginning of the gradientArray and bluer pixels will get their new colors from the end.
        //comment out the line below if you would like to see the heatmap without the palette applied, will be only blue and black
        _bitmapData.paletteMap(_bitmapData, _bitmapData.rect, POINT, null, null, _gradientDict, null);
        // This blur filter makes the heat map looks quite smooth.
        _bitmapData.applyFilter(_bitmapData, _bitmapData.rect, POINT, BLURFILTER);

        _bitmapData.unlock();

        _matrix2.tx = parent.scrollRect.x;
        _matrix2.ty = parent.scrollRect.y;

        graphics.clear();
        graphics.beginBitmapFill(_bitmapData, _matrix2, false, false);
        graphics.drawRect(parent.scrollRect.x, parent.scrollRect.y, map.width, map.height);
        graphics.endFill();

        function noWrapAround(mapPoint:MapPoint):void
        {
            if (map.extent.containsXY(mapPoint.x, mapPoint.y))
            {
                drawXY(mapPoint.x, mapPoint.y);
            }
        }

        function doWrapAround(mapPoint:MapPoint):void
        {
            var x:Number = mapPoint.x;
            while (x > map.extent.xmin)
            {
                drawXY(x, mapPoint.y);
                x -= _world;
            }
            x = mapPoint.x + _world;
            while (x < map.extent.xmax)
            {
                drawXY(x, mapPoint.y);
                x += _world;
            }
        }

        function drawXY(x:Number, y:Number):void
        {
            const diameter:int = radius + radius;

            _matrix1.createGradientBox(diameter, diameter, 0, -radius, -radius);

            _shape.graphics.clear();
            _shape.graphics.beginGradientFill(GradientType.RADIAL, COLORS, ALPHAS, RATIOS, _matrix1);
            _shape.graphics.drawCircle(0, 0, radius);
            _shape.graphics.endFill();

            _matrix2.tx = Math.floor((x - map.extent.xmin) * facX);
            _matrix2.ty = Math.floor(mapH - (y - map.extent.ymin) * facY);
            _bitmapData.draw(_shape, _matrix2, null, BlendMode.SCREEN, null, true);
        }
        dispatchEvent(new LayerEvent(LayerEvent.UPDATE_END, this, null, true));

    } //end updateLayer

    //--------------------------------------
    // Getters and setters
    //--------------------------------------

    //--------------------------------------
    //  url
    //--------------------------------------

    [Bindable(event="urlChanged")]
    /**
     * URL of the point layer in feature or map service that will be used to generate the heatmap.
     */
    public function get url():String
    {
        return _url;
    }

    /**
     * @private
     */
    public function set url(value:String):void
    {
        if (_url != value && value)
        {
            _url = value;
            invalidateHeatMap();
            setLoaded(false);
            dispatchEvent(new Event("urlChanged"));
        }
    }

    //--------------------------------------
    //  proxyURL
    //--------------------------------------

    /**
     * The URL to proxy the request through.
     */
    public function get proxyURL():String
    {
        return _proxyURL;
    }

    /**
     * @private
     */
    public function set proxyURL(value:String):void
    {
        _proxyURL = value;
    }

    //--------------------------------------
    //  token
    //--------------------------------------

    [Bindable(event="tokenChanged")]
    /**
     * Token for accessing a secure ArcGIS service.
     *
     */
    public function get token():String
    {
        return _token;
    }

    /**
     * @private
     */
    public function set token(value:String):void
    {
        if (_token !== value)
        {
            _token = value;
            dispatchEvent(new Event("tokenChanged"));
        }
    }

    //--------------------------------------
    //  useAMF
    //--------------------------------------

    [Bindable(event="useAMFChanged")]
    /**
     * Use AMF for executing the query. This is the preferred method, but the server must support it.
     */
    public function get useAMF():Boolean
    {
        return _useAMF;
    }

    /**
     * @private
     */
    public function set useAMF(value:Boolean):void
    {
        if (_useAMF !== value)
        {
            _useAMF = value;
            dispatchEvent(new Event("useAMFChanged"));
        }
    }

    //--------------------------------------
    //  where
    //--------------------------------------

    [Bindable(event="whereChanged")]
    /**
     * A where clause for the query, refer to the Query class in the ArcGIS API for Flex documentation.
     * @default 1=1
     */
    public function get where():String
    {
        return _where;
    }

    /**
     * @private
     */
    public function set where(value:String):void
    {
        if (_where !== value)
        {
            _where = value;
            invalidateHeatMap();
            dispatchEvent(new Event("whereChanged"));
        }
    }

    //--------------------------------------
    //  outFields
    //--------------------------------------

    [Bindable(event="outFieldsChanged")]
    /**
     * Attribute fields to include in the FeatureSet returned in the HeatMapEvent.
     */
    public function get outFields():Array
    {
        return _outFields;
    }

    /**
     * @private
     */
    public function set outFields(value:Array):void
    {
        if (_outFields !== value)
        {
            _outFields = value;
            dispatchEvent(new Event("outFieldsChanged"));
        }
    }

    //--------------------------------------
    //  timeExtent
    //--------------------------------------

    [Bindable(event="timeExtentChanged")]
    /**
     * The time instant or the time extent to query, this is usually set internally
     * through a time extent change event when the map time changes and not set directly.
     */
    public function get timeExtent():TimeExtent
    {
        return _timeExtent;
    }

    /**
     * @private
     */
    public function set timeExtent(value:TimeExtent):void
    {
        if (_timeExtent !== value)
        {
            _timeExtent = value;
            invalidateHeatMap();
            dispatchEvent(new Event("timeExtentChanged"));
        }
    }

    //--------------------------------------
    //  theme
    //--------------------------------------

    [Bindable(event="heatMapThemeChanged")]
    /**
     * The "named" color scheme used to generate the client-side heatmap layer.
     * @default RAINBOW
     */
    public function get theme():String
    {
        return _heatMapTheme;
    }

    /**
     * @private
     */
    public function set theme(value:String):void
    {
        if (_heatMapTheme !== value)
        {
            _heatMapTheme = value;
            _gradientDict = HeatMapGradientDict.gradientArray(_heatMapTheme);
            refresh();
            dispatchEvent(new Event("heatMapThemeChanged"));
        }
    }

    /**
     * Gets the detailed information for the ArcGIS layer used to generate the heatmap.
     *
     * @return The <code>LayerDetails</code> of the point layer being queried in the map or feature service.
     */
    public function get layerDetails():LayerDetails
    {
        return _layerDetails;
    }

    //--------------------------------------------------------------------------
    //
    //  New methods at 3.1
    //
    //--------------------------------------------------------------------------

    //--------------------------------------
    //  cluster max weight
    //--------------------------------------

    [Bindable("clusterMaxWeightChanged")]
    /**
     * The maximum weight of the cluster.
     */
    public function get clusterMaxWeight():Number
    {
        return _clusterMaxWeight;
    }

    //--------------------------------------
    //  cluster count
    //--------------------------------------

    [Bindable("clusterCountChanged")]
    /**
     * The cluster count.
     */
    public function get clusterCount():int
    {
        return _clusterCount;
    }

    //--------------------------------------
    //  cluster size
    //--------------------------------------

    [Bindable]
    /**
     * The cluster size.
     */
    public function get clusterSize():int
    {
        return _clusterSize;
    }

    /**
     * @private
     */
    public function set clusterSize(value:int):void
    {
        if (_clusterSize !== value)
        {
            _clusterSize = value;
            invalidateLayer();
        }
    }

    //--------------------------------------
    //  density radius
    //--------------------------------------

    [Bindable]
    /**
     * The density radius.  This controls the size of the heat
     * radius for a given point.
     */
    public function get densityRadius():int
    {
        return _densityRadius;
    }

    /**
     * @private
     */
    public function set densityRadius(value:int):void
    {
        if (_densityRadius !== value)
        {
            _densityRadius = value;
            invalidateLayer();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  functions used to manipulate heatmap generation
    //
    //--------------------------------------------------------------------------

    [Bindable(event="featureRadiusCalculatorChanged")]
    /**
     * The function to use to calculate the density radius.
     * If not set the heatmap layer will default to the internal function.
     */
    public function set featureRadiusCalculator(value:Function):void
    {
        _featureRadiusCalculator = value === null ? internalFeatureRadiusCalculator : value;
        invalidateLayer();
    }

    [Bindable(event="featureIndexCalculatorChanged")]
    /**
     * The function to use to calculate the index used to retrieve colors from
     * the gradient dictionary.
     * If not set the heatmap layer will default to the internal function.
     */
    public function set featureIndexCalculator(value:Function):void
    {
        _featureIndexCalculator = value === null ? internalFeatureCalculator : value;
        invalidateLayer();
    }

    [Bindable(event="clusterRadiusCalculatorChanged")]
    /**
     * The function to use to calculate the cluster radius.
     * If not set the heatmap layer will default to the internal function.
     */
    public function set clusterRadiusCalculator(value:Function):void
    {
        _clusterRadiusCalculator = value === null ? internalClusterRadiusCalculator : value;
        invalidateLayer();
    }

    [Bindable(event="clusterIndexCalculatorChanged")]
    /**
     * The function to use to calculate the cluster index.
     * If not set the heatmap layer will default to the internal function.
     */
    public function set clusterIndexCalculator(value:Function):void
    {
        _clusterIndexCalculator = value === null ? internalClusterCalculator : value;
        invalidateLayer();
    }

    [Bindable(event="clusterWeightCalculatorChanged")]
    /**
     * The function to use to calculate the cluster weight.
     * If not set the heatmap layer will default to the internal function.
     */
    public function set clusterWeightCalculator(value:Function):void
    {
        _clusterWeightCalculator = value === null ? internalWeightCalculator : value;
        invalidateLayer();
    }

    private function internalWeightCalculator(feature:Graphic):Number
    {
        return 1.0;
    }

    private function internalFeatureCalculator(feature:Graphic):int
    {
        return 255;
    }

    private function internalClusterCalculator(cluster:Cluster, weightMax:Number):int
    {
        return 255 * cluster.weight / weightMax;
    }

    private function internalFeatureRadiusCalculator(feature:Graphic, radius:Number):Number
    {
        return radius;
    }

    private function internalClusterRadiusCalculator(cluster:Cluster, radius:Number, weightMax:Number):Number
    {
        return radius;
    }
} //end class

}
