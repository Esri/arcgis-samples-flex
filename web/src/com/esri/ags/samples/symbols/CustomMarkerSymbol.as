package com.esri.ags.samples.symbols
{

import com.esri.ags.Map;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.MapPoint;
import com.esri.ags.geometry.Multipoint;
import com.esri.ags.symbols.Symbol;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

public class CustomMarkerSymbol extends Symbol
{
    override public function clear(sprite:Sprite):void
    {
        // clear and position the sprite
        sprite.graphics.clear();
        sprite.x = 0;
        sprite.y = 0;
    }

    override public function draw(sprite:Sprite, geometry:Geometry, attributes:Object, map:Map):void
    {
        // duplicate the geometry on the visible worlds
        var geometries:Vector.<Geometry> = getWrapAroundGeometries(map, geometry);

        if (geometries)
        {
            for each (var geom:Geometry in geometries)
            {
                // handle the geometry type
                if (geom.type == Geometry.MAPPOINT)
                {
                    drawPoint(sprite.graphics, geom as MapPoint, map);
                }
                else if (geom.type == Geometry.MULTIPOINT)
                {
                    for each (var point:MapPoint in(geom as Multipoint).points)
                    {
                        drawPoint(sprite.graphics, point, map);
                    }
                }
            }
        }
    }

    override public function destroy(sprite:Sprite):void
    {
        sprite.graphics.clear();
    }

    private function drawPoint(g:Graphics, mapPoint:MapPoint, map:Map):void
    {
        // project the point on screen
        var sx:Number = toScreenX(map, mapPoint.x);
        var sy:Number = toScreenY(map, mapPoint.y);

        // Draw a star
        g.beginFill(0xFF0000);
        g.lineStyle(2, 0x000000);
        g.moveTo(sx - 20, sy);
        g.lineTo(sx - 5, sy - 5);
        g.lineTo(sx, sy - 20);
        g.lineTo(sx + 5, sy - 5);
        g.lineTo(sx + 20, sy);
        g.lineTo(sx + 5, sy + 5);
        g.lineTo(sx, sy + 20);
        g.lineTo(sx - 5, sy + 5);
        g.moveTo(sx - 20, sy);
        g.endFill();
    }
}
}
