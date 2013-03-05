// Used by GeoRSSApp.mxml
package com.esri.ags.samples
{

import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.geometry.Polygon;

import mx.utils.StringUtil;

public class GeoRSSUtil
{
    private static const GEORSS:Namespace = Namespaces.GEORSS_NS;
    private static const GEOWGS:Namespace = Namespaces.GEOWGS_NS;
    private static const GEO:Namespace = Namespaces.GEO_NS;
    private static const GML:Namespace = Namespaces.GML_NS;

    public function GeoRSSUtil(singletonEnforcer:SingletonEnforcer)
    {
    }

    public static function toGeometry(x:XML):Geometry
    {
        const geoLat:String = String(x.GEOWGS::lat);
        const geoLon:String = String(x.GEOWGS::long);
        if (geoLat && geoLon)
        {
            return new MapPoint(Number(geoLon), Number(geoLat));
        }

        const georssPoint:String = String(x.GEORSS::point);
        if (georssPoint)
        {
            return parseGeoRSSPoint(georssPoint);
        }

        const pointList:XMLList = x.GEO::point;
        if (pointList && pointList.length() > 0)
        {
            const geoPoint:XML = pointList[0];
            const geoPLat:Number = Number(geoPoint.GEO::lat);
            const geoPLon:Number = Number(geoPoint.GEO::long);
            return new MapPoint(geoPLon, geoPLat);
        }

        const georssPolygon:String = String(x.GEORSS::polygon);
        if (georssPolygon)
        {
            return parseGeoRSSPolygon(georssPolygon);
        }

        const whereList:XMLList = x.GEORSS::where;
        if (whereList && whereList.length() > 0)
        {
            const pos:String = whereList[0].GML::Point[0].GML::pos[0];
            const arr:Array = pos.split(" ");
            const gmlLat:Number = Number(arr[0]);
            const gmlLon:Number = Number(arr[1]);
            return new MapPoint(gmlLon, gmlLat);
        }
        return null;
    }

    private static function parseGeoRSSWhere(x:XML):Geometry
    {
        return null;
    }

    private static function parseGeoRSSPoint(text:String):Geometry
    {
        const tokens:Array = StringUtil.trim(text).split(" ");
        const lat:Number = Number(tokens[0]);
        const lon:Number = Number(tokens[1]);
        return new MapPoint(lon, lat);
    }

    private static function parseGeoRSSPolygon(text:String):Geometry
    {
        const path:Array = [];
        const tokens:Array = StringUtil.trim(text).split(" ");
        for (var i:int = 0, j:int = 1; j < tokens.length; i += 2, j += 2)
        {
            var lat:Number = Number(tokens[i]);
            var lon:Number = Number(tokens[j]);
            path.push(new MapPoint(lon, lat));
        }
        return new Polygon([ path ]);
    }

}
}

class SingletonEnforcer
{
}
