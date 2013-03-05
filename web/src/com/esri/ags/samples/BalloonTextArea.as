package com.esri.ags.samples
{

import com.esri.ags.Graphic;
import com.esri.ags.components.supportClasses.IGraphicRenderer;

import mx.controls.TextArea;
import mx.core.ScrollPolicy;

public class BalloonTextArea extends TextArea implements IGraphicRenderer
{
    public function BalloonTextArea()
    {
        width = 210;
        height = 210;
        editable = false;
        selectable = false;
        condenseWhite = true;
        verticalScrollPolicy = ScrollPolicy.OFF;
        horizontalScrollPolicy = ScrollPolicy.OFF;
    }

    public function set graphic(value:Graphic):void
    {
        if (value.symbol is BalloonSymbol)
        {
            setHtmlText(value.symbol as BalloonSymbol);
        }
    }

    private function setHtmlText(balloonSymbol:BalloonSymbol):void
    {
        var oldText:String = balloonSymbol.htmlText;
        var newText:String = "";
        var pos:int = 0;
        var len0:int = oldText.length;
        var len1:int = len0 - 1;
        while (pos < len0)
        {
            var charAt:String = oldText.charAt(pos);
            if (charAt === "$")
            {
                if (pos + 3 <= len1)
                {
                    var next:int = pos + 1;
                    if (oldText.charAt(next) === "[")
                    {
                        var end:int = oldText.indexOf("]", next);
                        if (end > 0)
                        {
                            var key:String = oldText.substring(pos + 2, end);
                            var val:String = data[key];
                            newText += val ? val : key;
                            pos = end + 1;
                        }
                    }
                    else
                    {
                        newText += charAt;
                        pos++;
                    }
                }
                else
                {
                    newText += charAt;
                    pos++;
                }
            }
            else
            {
                newText += charAt;
                pos++;
            }
        }
        htmlText = newText;
        validateNow();
    }

    override protected function commitProperties():void
    {
        super.commitProperties();
        if (textWidth > 0 && textHeight > 0)
        {
            width = textWidth + 15;
            height = textHeight + 10;
        }
    }
}

}
