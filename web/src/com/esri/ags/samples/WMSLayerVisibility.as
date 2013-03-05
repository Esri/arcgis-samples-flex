// Used by WMSLayerTOC.mxml and WMSLayerVizRenderer.mxml
package com.esri.ags.samples
{

import flash.events.EventDispatcher;

public class WMSLayerVisibility extends EventDispatcher
{
    public var name:String;

    public var title:String;

    [Bindable]
    public var visible:Boolean;
}

}
