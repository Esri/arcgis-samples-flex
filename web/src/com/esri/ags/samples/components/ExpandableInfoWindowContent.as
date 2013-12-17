package com.esri.ags.samples.components
{

import com.esri.ags.components.supportClasses.IInfoWindowContent;
import com.esri.ags.components.supportClasses.IInfoWindowDraggableContent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

import spark.components.Group;
import spark.components.SkinnableContainer;
import spark.core.IDisplayText;

//----------------------------------
//  Skin States
//----------------------------------

[SkinState("disabled")]

[SkinState("normal")]

[SkinState("expanded")]

//----------------------------------
//  Events
//----------------------------------

[Event(name="change", type="flash.events.Event")]

[Event(name="valueCommit", type="mx.events.FlexEvent")]

/**
 * An expandable container for the infowindow.
 */
public class ExpandableInfoWindowContent extends SkinnableContainer implements IInfoWindowContent, IInfoWindowDraggableContent
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     */
    public function ExpandableInfoWindowContent()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  draggableGroup
    //----------------------------------

    [SkinPart(required="false")]

    public var draggableGroup:Group;

    //----------------------------------
    //  expandButton
    //----------------------------------

    [SkinPart(required="false")]

    public var expandButton:Sprite;

    //----------------------------------
    //  titleLabel
    //----------------------------------

    [SkinPart(required="false")]

    public var titleLabel:IDisplayText;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  title
    //----------------------------------

    private var m_title:String = null;

    [Bindable("titleChange")]

    /**
     * Title text of the container.
     */
    public function get title():String
    {
        return m_title;
    }

    /**
     * @private
     */
    public function set title(value:String):void
    {
        if (m_title !== value)
        {
            m_title = value;
            if (titleLabel)
            {
                titleLabel.text = m_title;
            }
            dispatchEvent(new Event("titleChange"));
        }
    }

    //----------------------------------
    //  title
    //----------------------------------

    private var m_expanded:Boolean = false;

    [Bindable(event="change")]
    [Bindable(event="valueCommit")]

    /**
     * The expandable state of the container
     *
     * @default false
     */
    public function get expanded():Boolean
    {
        return m_expanded;
    }

    /**
     * @private
     */
    public function set expanded(value:Boolean):void
    {
        if (m_expanded !== value)
        {
            m_expanded = value;
            if (!dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT, false, true)))
            {
                m_expanded = !value;
            }
            invalidateSkinState();
        }
    }

    //----------------------------------
    //  showInfoWindowHeader
    //----------------------------------

    /**
     * @private
     */
    public function get showInfoWindowHeader():Boolean
    {
        return false;
    }

    //----------------------------------
    //  draggableContent
    //----------------------------------

    /**
     * @private
     */
    public function get draggableContent():IEventDispatcher
    {
        return draggableGroup;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
        if (!enabled)
        {
            return "disabled";
        }
        else if (expanded)
        {
            return "expanded";
        }
        else
        {
            return "normal";
        }
    }

    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        if (instance == expandButton)
        {
            expandButton.addEventListener(MouseEvent.CLICK, expandButtonChangeHandler);
        }
        if (instance == titleLabel)
        {
            titleLabel.text = m_title;
        }
    }

    /**
     * @private
     */
    override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        if (instance == expandButton)
        {
            expandButton.removeEventListener(MouseEvent.CLICK, expandButtonChangeHandler);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handler
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    protected function expandButtonChangeHandler(event:Event):void
    {
        var oldValue:Boolean = m_expanded;
        m_expanded = !oldValue;
        if (dispatchEvent(new Event(Event.CHANGE, false, true)))
        {
            m_expanded = oldValue;
            this.expanded = !m_expanded;
        }
        else
        {
            m_expanded = oldValue;
        }
    }

}
}
