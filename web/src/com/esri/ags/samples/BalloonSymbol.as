package com.esri.ags.samples
{

import com.esri.ags.symbols.SimpleLineSymbol;
import com.esri.ags.symbols.SimpleMarkerSymbol;
import com.esri.ags.symbols.Symbol;

public class BalloonSymbol extends SimpleMarkerSymbol
{
    public var htmlText:String;

    public function BalloonSymbol(style:String = "circle", size:Number = 15, color:Number = 0, alpha:Number = 1, xoffset:Number = 0, yoffset:Number = 0, angle:Number = 0, outline:SimpleLineSymbol = null)
    {
        super(style, size, color, alpha, xoffset, yoffset, angle, outline);
    }

    override public function clone():Symbol
    {
        var bs:BalloonSymbol = new BalloonSymbol(style, size, color, alpha, xoffset, yoffset, angle, outline ? outline.clone() as SimpleLineSymbol : null);
        bs.htmlText = htmlText;
        return bs;
    }
}

}
