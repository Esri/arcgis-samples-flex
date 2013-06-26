// Used by TemporalRenderer_FeatureCollection.mxml
package com.esri.ags.samples
{

import com.esri.ags.Graphic;
import com.esri.ags.Map;
import com.esri.ags.TimeExtent;
import com.esri.ags.components.TimeSlider;
import com.esri.ags.events.ExtentEvent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.FeatureLayer;
import com.esri.ags.utils.GraphicUtil;
import com.esri.ags.utils.WebMercatorUtil;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.controls.Alert;

public class GPXFeed
{
    // constants
    private static const GPX_NS:Namespace = new Namespace("http://www.topografix.com/GPX/1/1");

    // constructor
    public function GPXFeed()
    {
        _loader = new URLLoader();
        _loader.addEventListener(Event.COMPLETE, loader_completeHandler);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
        _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, loader_httpStatusHandler);
    }

    // variables
    private var _loader:URLLoader;

    // properties
    public var featureLayer:FeatureLayer;
    public var map:Map;
    public var timeSlider:TimeSlider; // optional
    public var url:String;

    // methods
    public function fetch():void
    {
        var request:URLRequest = new URLRequest();
        request.url = url;

        _loader.load(request);
    }

    private function parseDate(value:String):Date
    {
        // assume value is in the form 2009-07-15T14:13:35.000Z
        value = value.replace("T", " ");
        value = value.replace(/-/g, "/");
        value = value.replace(".000Z", " UTC");
        // value should now be in the form 2009/07/15 14:13:35 UTC
        return new Date(value);
    }

    // event handlers
    private function loader_completeHandler(event:Event):void
    {
        //trace(event);
        var gpxXML:XML = new XML(_loader.data);
        default xml namespace = GPX_NS;
        var trkpts:XMLList = gpxXML..trkpt;

        var timeExtent:TimeExtent = new TimeExtent();
        var features:Array = [];
        for each (var trkpt:XML in trkpts)
        {
            //trace(trkpt.@lon, trkpt.@lat, parseDate(trkpt.time).toUTCString());
            var point:MapPoint = new MapPoint(trkpt.@lon, trkpt.@lat);
            point = WebMercatorUtil.geographicToWebMercator(point) as MapPoint;
            var time:Date = parseDate(trkpt.time);
            var feature:Graphic = new Graphic(point, null, { "time": time });
            features.push(feature);
            // find startTime and endTime
            if (!timeExtent.startTime || timeExtent.startTime.time > time.time)
            {
                timeExtent.startTime = time;
            }
            if (!timeExtent.endTime || timeExtent.endTime.time < time.time)
            {
                timeExtent.endTime = time;
            }
        }

        if (features.length > 0)
        {
            featureLayer.applyEdits(features, null, null);

            map.addEventListener(ExtentEvent.EXTENT_CHANGE, map_extentChangeHandler);
            map.extent = GraphicUtil.getGraphicsExtent(features);

            function map_extentChangeHandler(event:ExtentEvent):void
            {
                map.removeEventListener(ExtentEvent.EXTENT_CHANGE, map_extentChangeHandler);
                if (timeExtent.startTime !== timeExtent.endTime)
                {
                    if (timeSlider)
                    {
                        timeSlider.createTimeStopsByCount(timeExtent, 15);
                    }
                    else
                    {
                        map.timeExtent = timeExtent;
                    }
                }
            }
        }
    }

    private function loader_ioErrorHandler(event:IOErrorEvent):void
    {
        Alert.show(event.text, "Application IOError");
    }

    private function loader_securityErrorHandler(event:SecurityErrorEvent):void
    {
        Alert.show(event.text, "Application Security Error");
    }

    protected function loader_httpStatusHandler(event:HTTPStatusEvent):void
    {
        if (event.status == 404)
        {
            Alert.show("Unable to load the following resource \n" + url, "http error");
        }
    }
}

}
