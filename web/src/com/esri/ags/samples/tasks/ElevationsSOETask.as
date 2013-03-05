package com.esri.ags.samples.tasks
{

import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Polyline;
import com.esri.ags.samples.events.ElevationsSOEEvent;
import com.esri.ags.samples.tasks.supportClasses.ElevationsSOEParameters;
import com.esri.ags.samples.tasks.supportClasses.ElevationsSOEResult;
import com.esri.ags.samples.tasks.supportClasses.InterpolatedRasterProperties;
import com.esri.ags.tasks.BaseTask;
import com.esri.ags.utils.JSONUtil;

import flash.net.URLVariables;

import mx.logging.Log;
import mx.rpc.AsyncToken;
import mx.rpc.IResponder;

//--------------------------------------
//  Events
//--------------------------------------

/**
 * Dispatched when a ElevationsSOETask fails.
 * @eventType mx.rpc.events.FaultEvent.FAULT
 */
[Event(name="fault", type="mx.rpc.events.FaultEvent")]

/**
 * Dispatched on success.
 * @eventType com.esri.ags.samples.events.ElevationsSOEEvent.EXECUTE_COMPLETE
 */
[Event(name="executeComplete", type="com.esri.ags.samples.events.ElevationsSOEEvent")]

/**
 * Performs various elevation based operations on a supported ArcGIS Server REST service resource.
 *
 * <p>Note: ElevationsSOETask, and other elevations SOE related classes, require a custom Server Objection Extension (SOE) service.
 *  <a href="http://sampleserver4.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/MapServer/exts/ElevationsSOE" target="_blank">View the service</a>.
 * </p>
 *
 * <p>
 *  In this example we have a map service which has a "Supported Extensions" resource named "ElevationsSOE".
 *  The purpose of this task is to show you how you can leverage the extensibility of ArcGIS Server, expose that as a REST resource
 *  and build your own custom Flex API resources that will consume the SOE.
 *  You can read more about the how the Server Object Extension (SOE) is configured by following the links listed below.
 *  Be sure to read the "ElevationsSOE_ReadMe.docx" contained in the source code download for the SOE from the ArcObjects code gallery.
 * </p>
 *
 * @since Your API for Flex 1.0
 *
 * @see com.esri.ags.samples.tasks.supportClasses.ElevationsSOEParameters
 * @see com.esri.ags.samples.tasks.supportClasses.ElevationsSOEEvent
 * @see com.esri.ags.samples.tasks.supportClasses.ElevationsSOEResult
 *
 * @see http://blogs.esri.com/Dev/blogs/apl/archive/2010/10/07/Elevation-Server-Object-Extension.aspx Read more about the Applications Prototype Lab's Elevation Server Object Extension
 * @see http://resources.arcgis.com/gallery/file/arcobjects-net-api/details?entryID=87BEC705-1422-2418-34B5-308930DE323A Get the source code from the ArcObjects code gallery
 * @see http://www.arcgis.com/home/item.html?id=b9d247c297f144459854751740f59f68 Get the Elevation Profiles widget for the FlexViewer
 *
 * @see http://en.wikipedia.org/wiki/Esri_grid Wiki Page (Esri grid format)
 */
public class ElevationsSOETask extends BaseTask
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Creates a new ElevationsSOETask object.
     * @param url [optional] URL to the ArcGIS Server REST resource that represents the ElevationsSOE service.
     */
    override public function ElevationsSOETask(url:String = null)
    {
        super(url);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    [Bindable]
    /**
     * The result returned from last call to the execute function.
     */
    public var executeLastResult:ElevationsSOEResult;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Get the elevation at a location.
     *
     * @param elevationsSOEParameters The criteria used to get the elevation at a location.
     * @param responder The responder to call on result or fault.
     *
     */
    public function executeGetElevationAtLatLon(elevationsSOEParameters:ElevationsSOEParameters, responder:IResponder = null):AsyncToken
    {
        if (Log.isDebug())
        {
            logger.debug("{0}::executeGetElevationAtLatLon:{1}", id, elevationsSOEParameters);
        }
        const urlVariables:URLVariables = new URLVariables();
        urlVariables.f = "json";
        urlVariables.lon = elevationsSOEParameters.longitude;
        urlVariables.lat = elevationsSOEParameters.latitude;

        return sendURLVariables("/GetElevationAtLonLat", urlVariables, responder, handleGetElevationAtLatLon);
    }

    /**
     * @private
     */
    private function handleGetElevationAtLatLon(decodedObject:Object, asyncToken:AsyncToken):void
    {
        if (Log.isDebug())
        {
            logger.debug("{0}::handleGetElevationAtLatLon:{1}", id, decodedObject);
        }
        const elevationsSOEResult:ElevationsSOEResult = new ElevationsSOEResult();
        elevationsSOEResult.elevation = Number(decodedObject.elevation);
        executeLastResult = elevationsSOEResult;

        for each (var responder:IResponder in asyncToken.responders)
        {
            responder.result(executeLastResult);
        }

        dispatchEvent(new ElevationsSOEEvent(ElevationsSOEEvent.EXECUTE_COMPLETE, executeLastResult));
    }

    /**
     * Get the elevations along a polyline.
     *
     * @param elevationsSOEParameters The criteria used to get the elevation along a polyline.
     * @param responder The responder to call on result or fault.
     *
     */
    public function executeGetElevations(elevationsSOEParameters:ElevationsSOEParameters, responder:IResponder = null):AsyncToken
    {
        if (Log.isDebug())
        {
            logger.debug("{0}::executeGetElevations:{1}", id, elevationsSOEParameters);
        }
        const urlVariables:URLVariables = new URLVariables();
        urlVariables.f = "json";
        urlVariables.geometries = JSONUtil.encode(elevationsSOEParameters.geometries);

        return sendURLVariables("/GetElevations", urlVariables, responder, handleGetElevations);
    }

    /**
     * @private
     */
    private function handleGetElevations(decodedObject:Object, asyncToken:AsyncToken):void
    {
        if (Log.isDebug())
        {
            logger.debug("{0}::handleGetElevations:{1}", id, decodedObject);
        }
        const elevationsSOEResult:ElevationsSOEResult = new ElevationsSOEResult();

        var polyline:Polyline = Polyline.fromJSON(decodedObject.geometries[0]);
        elevationsSOEResult.geometries = [ polyline ];
        elevationsSOEResult.elevations = decodedObject.elevations[0];
        elevationsSOEResult.sampleDistance = Number(decodedObject.sampleDistance);
        elevationsSOEResult.chartDistances = decodedObject.geometries[0].paths[0];
        elevationsSOEResult.chartResultData = decodedObject;

        executeLastResult = elevationsSOEResult;

        for each (var responder:IResponder in asyncToken.responders)
        {
            responder.result(executeLastResult);
        }

        dispatchEvent(new ElevationsSOEEvent(ElevationsSOEEvent.EXECUTE_COMPLETE, executeLastResult));
    }

    /**
     * Get all the elevation values within an extent.
     *
     * @param elevationsSOEParameters The criteria used to get the elevation get all the elevation values within an extent.
     * @param responder The responder to call on result or fault.
     *
     */
    public function executeGetElevationData(elevationsSOEParameters:ElevationsSOEParameters, responder:IResponder = null):AsyncToken
    {
        if (Log.isDebug())
        {
            logger.debug("{0}::executeGetElevationData:{1}", id, elevationsSOEParameters);
        }

        const urlVariables:URLVariables = new URLVariables();
        urlVariables.f = "json";
        urlVariables.Extent = JSONUtil.encode(elevationsSOEParameters.extent);
        urlVariables.Rows = elevationsSOEParameters.rows;
        urlVariables.Columns = elevationsSOEParameters.columns;

        var handleGetElevationData:Function = function(decodedObject:Object, asyncToken:AsyncToken):void
        {
            if (Log.isDebug())
            {
                logger.debug("{0}::handleGetElevationData:{1}", id, decodedObject);
            }

            const elevationsSOEResult:ElevationsSOEResult = new ElevationsSOEResult();
            elevationsSOEResult.numberOfColumns = parseInt(decodedObject.nCols);
            elevationsSOEResult.numberOfRows = parseInt(decodedObject.nRows);
            elevationsSOEResult.xCoordLLCenter = parseFloat(decodedObject.xLLCenter);
            elevationsSOEResult.yCoordLLCenter = parseFloat(decodedObject.yLLCenter);
            elevationsSOEResult.cellSizeH = elevationsSOEParameters.extent.width / elevationsSOEResult.numberOfColumns;
            elevationsSOEResult.cellSizeV = elevationsSOEParameters.extent.height / elevationsSOEResult.numberOfRows;
            elevationsSOEResult.noDataValue = decodedObject.noDataValue;
            elevationsSOEResult.spatialReference = SpatialReference.fromJSON(decodedObject.spatialReference);
            elevationsSOEResult.elevationData = decodedObject.data;
            var rasterProperties:InterpolatedRasterProperties = new InterpolatedRasterProperties();
            rasterProperties.isInteger = decodedObject.rasterProperties.IsInteger ? true : false;
            rasterProperties.datasetMinimum = parseInt(decodedObject.rasterProperties.datasetMin);
            rasterProperties.datasetMaximum = parseInt(decodedObject.rasterProperties.datasetMax);
            elevationsSOEResult.rasterProperties = rasterProperties;
            executeLastResult = elevationsSOEResult;

            for each (var resp:IResponder in asyncToken.responders)
            {
                resp.result(executeLastResult);
            }

            dispatchEvent(new ElevationsSOEEvent(ElevationsSOEEvent.EXECUTE_COMPLETE, executeLastResult));
        }

        return sendURLVariables("/GetElevationData", urlVariables, responder, handleGetElevationData);
    }

    /**
     * Calculate the elevation profile over a polyline and create an image of the profile chart.
     *
     * @param elevationsSOEParameters The criteria used to get the elevation profile over a polyline and create an image of the profile chart.
     * @param responder The responder to call on result or fault.
     *
     */
    public function executeGetElevationProfile(elevationsSOEParameters:ElevationsSOEParameters, responder:IResponder = null):AsyncToken
    {
        if (Log.isDebug())
        {
            logger.debug("{0}::executeGetElevationProfile:{1}", id, elevationsSOEParameters);
        }

        const urlVariables:URLVariables = new URLVariables();
        urlVariables.f = "json";
        urlVariables.InputPolyline = JSONUtil.encode(elevationsSOEParameters.inputPolyline);
        urlVariables.ImageWidth = elevationsSOEParameters.imageWidth;
        urlVariables.ImageHeight = elevationsSOEParameters.imageHeight;
        urlVariables.BackgroundColorHex = "0x" + elevationsSOEParameters.backgroundColorHex.toString(16);
        urlVariables.DisplaySegments = elevationsSOEParameters.isDisplaySegments;

        return sendURLVariables("/GetElevationProfile", urlVariables, responder, handleGetElevationProfile);
    }

    /**
     * @private
     */
    private function handleGetElevationProfile(decodedObject:Object, asyncToken:AsyncToken):void
    {
        if (Log.isDebug())
        {
            logger.debug("{0}::handleGetElevationProfile:{1}", id, decodedObject);
        }

        const elevationsSOEResult:ElevationsSOEResult = new ElevationsSOEResult();
        elevationsSOEResult.profileImageURL = decodedObject.profileImageUrl;
        elevationsSOEResult.length2D = decodedObject.length2D;
        elevationsSOEResult.length3D = decodedObject.length3D;
        elevationsSOEResult.processTime = decodedObject.processTime;

        executeLastResult = elevationsSOEResult;

        for each (var responder:IResponder in asyncToken.responders)
        {
            responder.result(executeLastResult);
        }

        dispatchEvent(new ElevationsSOEEvent(ElevationsSOEEvent.EXECUTE_COMPLETE, executeLastResult));
    }
}

}
