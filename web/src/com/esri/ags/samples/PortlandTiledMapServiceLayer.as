package com.esri.ags.samples
{

import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.layers.supportClasses.LOD;
import com.esri.ags.layers.supportClasses.TileInfo;
import com.esri.ags.layers.TiledMapServiceLayer;

import flash.net.URLRequest;

/**
 * PortlandTiledMapServiceLayer
 */
public class PortlandTiledMapServiceLayer extends TiledMapServiceLayer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Creates a new PortlandTiledMapServiceLayer object.
     */
    public function PortlandTiledMapServiceLayer()
    {
        super();

        buildTileInfo(); // to create our hardcoded tileInfo

        setLoaded(true); // Map will only use loaded layers
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var _tileInfo:TileInfo = new TileInfo(); // see buildTileInfo()
    private var _baseURL:String = "http://sampleserver1.arcgisonline.com/arcgiscache/Portland_Portland_ESRI_LandBase_AGO/Portland/_alllayers";

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //      fullExtent()
    //      initialExtent()
    //      spatialReference()
    //      tileInfo()
    //      units()
    //
    //--------------------------------------------------------------------------


    //----------------------------------
    //  fullExtent
    //  - required to calculate the tiles to use
    //----------------------------------

    override public function get fullExtent():Extent
    {
        return new Extent(-123.596895130725, 44.297575737946, -121.553757125519, 46.3683237161949, new SpatialReference(4326));
    }

    //----------------------------------
    //  initialExtent
    //  - needed if Map doesn't have an extent
    //----------------------------------

    override public function get initialExtent():Extent
    {
        return new Extent(-122.539, 45.500, -122.540, 45.501, new SpatialReference(4326));
    }

    //----------------------------------
    //  spatialReference
    //  - needed if Map doesn't have a spatialReference
    //----------------------------------

    override public function get spatialReference():SpatialReference
    {
        return new SpatialReference(4326);
    }

    //----------------------------------
    //  tileInfo
    //----------------------------------

    override public function get tileInfo():TileInfo
    {
        return _tileInfo;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //      getTileURL(level:Number, row:Number, col:Number):URLRequest
    //
    //--------------------------------------------------------------------------

    override protected function getTileURL(level:Number, row:Number, col:Number):URLRequest
    {
        // Use virtual cache directory
        // This assumes the cache's virtual directory is exposed, which allows you access
        // to tile from the Web server via the public cache directory.
        // Example of a URL for a tile retrieved from the virtual cache directory:
        // http://serverx.esri.com/arcgiscache/dgaerials/Layers/_alllayers/L01/R0000051f/C000004e4.jpg
        var url:String = _baseURL
            + "/L" + padString(String(level), 2, "0")
            + "/R" + padString(row.toString(16), 8, "0")
            + "/C" + padString(col.toString(16), 8, "0") + ".png";
        return new URLRequest(url);
    }

    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------

    private function buildTileInfo():void
    {
        _tileInfo.height = 512;
        _tileInfo.width = 512;
        _tileInfo.origin = new MapPoint(-180, 90);
        _tileInfo.spatialReference = new SpatialReference(4326);
        _tileInfo.lods =
            [
            new LOD(0, 0.351562499999999, 147748799.285417),
            new LOD(1, 0.17578125, 73874399.6427087),
            new LOD(2, 0.0878906250000001, 36937199.8213544),
            new LOD(3, 0.0439453125, 18468599.9106772),
            new LOD(4, 0.02197265625, 9234299.95533859),
            new LOD(5, 0.010986328125, 4617149.97766929),
            new LOD(6, 0.0054931640625, 2308574.98883465),
            new LOD(7, 0.00274658203124999, 1154287.49441732),
            new LOD(8, 0.001373291015625, 577143.747208662),
            new LOD(9, 0.0006866455078125, 288571.873604331),
            new LOD(10, 0.000343322753906249, 144285.936802165),
            new LOD(11, 0.000171661376953125, 72142.9684010827),
            new LOD(12, 0.0000858306884765626, 36071.4842005414),
            new LOD(13, 0.0000429153442382813, 18035.7421002707),
            new LOD(14, 0.0000214576721191406, 9017.87105013534),
            new LOD(15, 0.0000107288360595703, 4508.93552506767)
            ];
    }

    private function padString(text:String, size:int, ch:String):String
    {
        while (text.length < size)
        {
            text = ch + text;
        }
        return text;
    }
}

}
