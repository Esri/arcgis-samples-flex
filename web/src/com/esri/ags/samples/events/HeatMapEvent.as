package com.esri.ags.samples.events
{

import com.esri.ags.FeatureSet;

import flash.events.Event;

/**
 * Represents event objects that are specific to the ArcGISHeatMapLayer.
 *
 * @see com.esri.ags.samples.layers.ArcGISHeatMapLayer
 */
public class HeatMapEvent extends Event
{
    /**
     * The number of features used in generating the heatmap layer.
     */
    public var count:Number;
    /**
     * The featureset returned by the query issued by the ArcGISHeatMapLayer.
     */
    public var featureSet:FeatureSet;

    /**
     * Defines the value of the <code>type</code> property of an refreshStart event object.
     *
     * @eventType refreshStart
     */
    public static const REFRESH_START:String = "refreshStart";
    /**
     * Defines the value of the <code>type</code> property of an refreshEnd event object.
     *
     * @eventType refreshEnd
     */
    public static const REFRESH_END:String = "refreshEnd";

    /**
     * Creates a new HeatMapEvent.
     *
     * @param type The event type; indicates the action that triggered the event.
     */
    public function HeatMapEvent(type:String, count:Number = NaN, featureSet:FeatureSet = null)
    {
        super(type);
        this.count = count;
        this.featureSet = featureSet;
    }

    /**
     * @private
     */
    override public function clone():Event
    {
        return new HeatMapEvent(type, count, featureSet);
    }

    /**
     * @private
     */
    override public function toString():String
    {
        return formatToString("HeatMapEvent", "type", "count", "featureSet");
    }

}
}
