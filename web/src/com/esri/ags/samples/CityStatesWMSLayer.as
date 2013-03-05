package com.esri.ags.samples
{

import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Extent;
import com.esri.ags.layers.DynamicMapServiceLayer;

import flash.display.Loader;
import flash.net.URLRequest;
import flash.net.URLVariables;

/**
 * CityStatesWMSLayer
 */
public class CityStatesWMSLayer extends DynamicMapServiceLayer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Creates a new CityStatesWMSLayer object.
     */
    public function CityStatesWMSLayer()
    {
        super();

        setLoaded(true); // Map will only use loaded layers

        // init constant parameter values
        _params = new URLVariables();
        _params.request = "GetMap";
        _params.transparent = true;
        _params.format = "image/png";
        _params.version = "1.1.1";
        _params.layers = "0,2"; // Cities is 0, Rivers is 1, States is 2
        _params.styles = "default,default"; // each layer needs a matching style

        var url:String = "http://sampleserver1.arcgisonline.com/arcgis/services/Specialty/ESRI_StatesCitiesRivers_USA/MapServer/WMSServer";
        _urlRequest = new URLRequest(url);
        _urlRequest.data = _params; // set params on URLRequest object
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _params:URLVariables;
    private var _urlRequest:URLRequest;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //      initialExtent()
    //      spatialReference()
    //      units()
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  initialExtent
    //  - needed if Map doesn't have an extent
    //----------------------------------

    override public function get initialExtent():Extent
    {
        return new Extent(-165, 18, -67, 67, new SpatialReference(4326));
    }

    //----------------------------------
    //  spatialReference
    //  - needed if Map doesn't have a spatialReference
    //----------------------------------

    override public function get spatialReference():SpatialReference
    {
        return new SpatialReference(4326);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //      loadMapImage(loader:Loader):void
    //
    //--------------------------------------------------------------------------

    override protected function loadMapImage(loader:Loader):void
    {
        // update changing values
        _params.bbox = map.extent.xmin + "," + map.extent.ymin + "," + map.extent.xmax + "," + map.extent.ymax;
        _params.srs = "EPSG:" + map.spatialReference.wkid;
        _params.width = map.width;
        _params.height = map.height;

        loader.load(_urlRequest);
    }
}

}
