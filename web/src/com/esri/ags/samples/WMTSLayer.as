package com.esri.ags.samples
{

import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.TiledMapServiceLayer;
import com.esri.ags.layers.supportClasses.LOD;
import com.esri.ags.layers.supportClasses.TileInfo;

import flash.net.URLRequest;

/**
 * WMTSLayer
 */
public class WMTSLayer extends TiledMapServiceLayer
{
    public function WMTSLayer()
    {
        super();

        buildTileInfo(); // to create hardcoded tileInfo

        setLoaded(true); // Map will only use loaded layers
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _baseURL:String = "http://v2.suite.opengeo.org/geoserver/gwc/service/wmts";

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  fullExtent
    //----------------------------------

    private var _fullExtent:Extent = new Extent(
        -20037508.342789, -20037508.342789, 20037508.342789, 20037508.342789,
        new SpatialReference(3857));

    /**
     * @private
     */
    override public function get fullExtent():Extent
    {
        return _fullExtent;
    }

    //----------------------------------
    //  initialExtent
    //----------------------------------

    private var _initialExtent:Extent = new Extent(
        -20037508.342789, -20037508.342789, 20037508.342789, 20037508.342789,
        new SpatialReference(3857));

    /**
     * @private
     */
    override public function get initialExtent():Extent
    {
        return _initialExtent;
    }

    //----------------------------------
    //  spatialReference
    //----------------------------------

    private var _spatialReference:SpatialReference = new SpatialReference(3857);

    /**
     * Returns a SpatialReference with a wkid value of 3857.
     */
    override public function get spatialReference():SpatialReference
    {
        return _spatialReference;
    }

    //----------------------------------
    //  tileInfo
    //----------------------------------

    private var _tileInfo:TileInfo = new TileInfo();

    /**
     * @private
     */
    override public function get tileInfo():TileInfo
    {
        return _tileInfo;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
    {
        var url:String = _baseURL
            + "?SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile" + "&LAYER=medford:zoning" + "&STYLE=_null" + "&FORMAT=image/png" + "&TILEMATRIXSET=EPSG:900913"
            + "&TILEMATRIX=EPSG:900913:" + level
            + "&TILEROW=" + row
            + "&TILECOL=" + col;
        return new URLRequest(url);
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    private function buildTileInfo():void
    {
        _tileInfo.dpi = 90.71428571427429;
        _tileInfo.spatialReference = new SpatialReference(3857);
        _tileInfo.height = 256;
        _tileInfo.width = 256;
        _tileInfo.format = "image/png";
        _tileInfo.origin = new MapPoint(-20037508.34, 20037508.34);
        _tileInfo.lods =
            [
            new LOD(0, 156543.033928, 591657527.591555),
            new LOD(1, 78271.5169639999, 295828763.795777),
            new LOD(2, 39135.7584820001, 147914381.897889),
            new LOD(3, 19567.8792409999, 73957190.948944),
            new LOD(4, 9783.93962049996, 36978595.474472),
            new LOD(5, 4891.96981024998, 18489297.737236),
            new LOD(6, 2445.98490512499, 9244648.868618),
            new LOD(7, 1222.99245256249, 4622324.434309),
            new LOD(8, 611.49622628138, 2311162.217155),
            new LOD(9, 305.748113140558, 1155581.108577),
            new LOD(10, 152.874056570411, 577790.554289),
            new LOD(11, 76.4370282850732, 288895.277144),
            new LOD(12, 38.2185141425366, 144447.638572),
            new LOD(13, 19.1092570712683, 72223.819286),
            new LOD(14, 9.55462853563415, 36111.909643),
            new LOD(15, 4.77731426794937, 18055.954822),
            new LOD(16, 2.38865713397468, 9027.977411),
            new LOD(17, 1.19432856685505, 4513.988705),
            new LOD(18, 0.597164283559817, 2256.994353),
            new LOD(19, 0.298582141647617, 1128.497176)
            ];
    }
}

}
