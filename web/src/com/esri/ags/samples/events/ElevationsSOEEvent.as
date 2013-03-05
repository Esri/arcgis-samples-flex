package com.esri.ags.samples.events
{

import com.esri.ags.SpatialReference;
import com.esri.ags.samples.tasks.supportClasses.ElevationsSOEResult;
import com.esri.ags.samples.tasks.supportClasses.InterpolatedRasterProperties;

import flash.events.Event;

/**
 * Represents event objects that are specific to ElevationsSOETask.
 *
 * <p>Note: ElevationsSOEEvent, and other elevations SOE related classes, require a custom Server Objection Extension (SOE) service.
 * <a href="http://sampleserver4.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/MapServer/exts/ElevationsSOE" target="_blank">View the service</a>.</p>
 *
 * @since Your API for Flex 1.0
 *
 * @see com.esri.ags.samples.tasks.ElevationsSOETask
 */
public class ElevationsSOEEvent extends Event
{
    /**
     * Defines the value of the <code>type</code> property of an executeComplete event object.
     *
     * @eventType executeComplete
     */
    public static const EXECUTE_COMPLETE:String = "executeComplete";

    /**
     * The result of the elevations SOE execution.
     *
     * @see com.esri.ags.samples.tasks.ElevationsSOETask#executeGetElevationAtLatLon()
     * @see com.esri.ags.samples.tasks.ElevationsSOETask#executeGetElevations()
     * @see com.esri.ags.samples.tasks.ElevationsSOETask#executeGetElevationData()
     * @see com.esri.ags.samples.tasks.ElevationsSOETask#executeGetElevationProfile()
     */
    public var elevationsSOEResult:ElevationsSOEResult;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Creates a new ElevationsSOEEvent.
     *
     * @param type The event type; indicates the action that triggered the event.
     *
     * @param elevationsSOEResult The elevations SOE result associated with this event, or <code>null</code>.
     */
    public function ElevationsSOEEvent(type:String, elevationsSOEResult:ElevationsSOEResult = null)
    {
        super(type);
        this.elevationsSOEResult = elevationsSOEResult;
    }

    /**
     * @private
     */
    override public function clone():Event
    {
        return new ElevationsSOEEvent(type, elevationsSOEResult);
    }

    /**
     * @private
     */
    override public function toString():String
    {
        return formatToString("ElevationsSOEEvent", "type", "elevationsSOEResult");
    }
}
}
