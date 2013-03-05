package com.esri.ags.samples.components
{

import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IListItemRenderer;
import mx.events.FlexEvent;

import spark.components.HGroup;
import spark.components.Image;

public class StarRatingComponent extends HGroup
{
    [Embed(source="/assets/yellow_star.gif")]
    private static var yellow_star:Class;

    [Embed(source="/assets/white_star.gif")]
    private static var white_star:Class;

    private var images:Array = [];
    public var myStarRating:int = 0;

    public function StarRatingComponent()
    {
        super();
        this.gap = 0;
    }

    override protected function createChildren():void
    {
        for (var i:int = 0; i < 5; i++)
        {
            images[i] = new Image();
            images[i].source = white_star;
            this.addElement(images[i]);
        }
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        for (var i:int = 0; i < 5; i++)
        {
            if (myStarRating > i)
            {
                images[i].source = yellow_star;
            }
            else
            {
                images[i].source = white_star;
            }
        }
    }

    // Internal variable for the property value.
    private var _data:Object;

    // Make the data property bindable.
    [Bindable("dataChange")]

    // Define the getter method.
    public function get data():Object
    {
        return _data;
    }

    // Define the setter method, and dispatch an event when the property
    // changes to support data binding.
    public function set data(value:Object):void
    {
        _data = value;
        myStarRating = Math.floor(Number(value));
        invalidateDisplayList();
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }



}
}
