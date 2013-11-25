package components
{

import com.esri.ags.Map;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;

import spark.components.supportClasses.ButtonBase;

[IncludeInManifest]

public class Compass extends ButtonBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function Compass()
    {
        super();
        buttonMode = true;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  mapRotation
    //----------------------------------

    private var m_mapRotation:Number = 0;

    [Bindable]

    public function get mapRotation():Number
    {
        return m_mapRotation;
    }

    public function set mapRotation(value:Number):void
    {
        if (m_mapRotation != value)
        {
            m_mapRotation = value;
            if (skin)
            {
                skin.invalidateProperties();
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function getCurrentSkinState():String
    {
        return super.getCurrentSkinState();
    }

    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
    }

    override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
    }
}

}
