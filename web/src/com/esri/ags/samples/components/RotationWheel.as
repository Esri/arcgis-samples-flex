package com.esri.ags.samples.components
{

import com.esri.ags.Map;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Vector3D;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;
import mx.core.UIComponent;

import spark.components.Group;
import spark.components.supportClasses.SkinnableComponent;

[Event(name="change", type="flash.events.Event")]

[SkinState("up")]
[SkinState("overNorth")]
[SkinState("downNorth")]
[SkinState("overWheel")]
[SkinState("downWheel")]
[SkinState("disabled")]

/**
 *
 * The <code>RotationWheel</code> is a sample component that can be used to provide
 * a user experience for rotating the ArcGIS API for Flex Map control.
 *
 * @since ArcGIS API 3.1 for Flex
 */
public class RotationWheel extends SkinnableComponent
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------

    public static const DEG_PER_RAD:Number = 180 / Math.PI;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function RotationWheel()
    {
        super();
        buttonMode = true;
        addEventListener(MouseEvent.MOUSE_OVER, mouseOverOutHandler);
        addEventListener(MouseEvent.MOUSE_OUT, mouseOverOutHandler);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var m_globalWheelCenter:Vector3D = new Vector3D();
    private var m_originVector:Vector3D = new Vector3D();
    private var m_wheelCenterVector:Vector3D = new Vector3D();
    private var m_originMapRotation:Number = 0;
    private var m_overWheel:Boolean;
    private var m_mouseOverNorth:Boolean;
    private var m_mouseDown:Boolean;


    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    [SkinPart(required="false")]
    public var wheel:Group;

    [SkinPart(required="false")]
    public var north:UIComponent;


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  mapRotation
    //----------------------------------

    private var m_mapRotation:Number = 0;

    [Bindable("mapRotationChanged")]

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
            dispatchEvent(new Event("mapRotationChanged"));
        }
    }

    //----------------------------------
    //  map
    //----------------------------------

    private var m_map:Map;
    private var m_mapRotationWatcher:ChangeWatcher;

    public function get map():Map
    {
        return m_map;
    }

    public function set map(value:Map):void
    {
        if (m_map !== value)
        {
            if (m_mapRotationWatcher)
            {
                m_mapRotationWatcher.unwatch();
            }
            m_map = value;
            if (m_map)
            {
                mapRotation = m_map.mapRotation;
                if (m_mapRotationWatcher)
                {
                    m_mapRotationWatcher.reset(m_map);
                }
                else
                {
                    m_mapRotationWatcher = BindingUtils.bindProperty(this, "mapRotation", m_map, "mapRotation");
                }
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
        var state:String = "up";
        if (m_overWheel)
        {
            state = m_mouseDown ? "down" : "over";
            state += "Wheel";
        }
        else if (m_mouseOverNorth)
        {
            state = m_mouseDown ? "down" : "over";
            state += "North";
        }
        return state;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function stop():void
    {
        stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        m_mouseDown = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    private function mouseOverOutHandler(event:MouseEvent):void
    {
        if (!m_mouseDown)
        {
            m_overWheel = m_mouseOverNorth = false;
            if (event.target === north)
            {
                m_mouseOverNorth = true;
            }
            else
            {
                m_overWheel = true;
            }
            invalidateSkinState();
        }
    }

    private function mouseDownHandler(event:MouseEvent):void
    {
        var globalCenter:Point = wheel.localToGlobal(new Point(wheel.transformX, wheel.transformY));
        m_globalWheelCenter.setTo(globalCenter.x, globalCenter.y, 0.0);
        m_wheelCenterVector.setTo(m_globalWheelCenter.x, m_globalWheelCenter.y, 0.0);
        m_originVector.setTo(event.stageX, event.stageY, 0.0);
        m_originVector = m_originVector.subtract(m_wheelCenterVector);
        m_originVector.normalize();
        m_originMapRotation = m_mapRotation;

        stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

        m_mouseDown = true;
        invalidateSkinState();
    }

    private function enterFrameHandler(event:Event):void
    {
        var mousePosition:Point = wheel.localToGlobal(new Point(wheel.mouseX, wheel.mouseY));
        var newVector:Vector3D = new Vector3D(mousePosition.x, mousePosition.y);
        newVector = newVector.subtract(m_wheelCenterVector);
        newVector.normalize();

        var n:Vector3D = m_originVector.crossProduct(newVector);
        var newAngle:Number = Vector3D.angleBetween(m_originVector, newVector) * DEG_PER_RAD;
        if (n.z < 0)
        {
            newAngle = -newAngle;
        }
        newAngle += m_originMapRotation;

        if (isNaN(newAngle))
        {
            newAngle = 0;
        }

        if (Math.abs(mapRotation - newAngle) > 1)
        {
            mapRotation = newAngle;
            dispatchEvent(new Event(Event.CHANGE));
        }
    }

    private function mouseUpHandler(event:MouseEvent):void
    {
        stop();
        invalidateSkinState();

        if (m_mouseOverNorth)
        {
            if (Math.abs(mapRotation - m_originMapRotation) < 3)
            {
                mapRotation = 0;
                dispatchEvent(new Event(Event.CHANGE));
            }
        }
    }
}

}
