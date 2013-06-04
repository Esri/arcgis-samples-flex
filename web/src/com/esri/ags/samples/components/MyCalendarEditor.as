package com.esri.ags.samples.components
{

import com.esri.ags.components.supportClasses.IFieldRenderer;
import com.esri.ags.skins.fieldClasses.CalendarField;

import flash.events.MouseEvent;

import mx.controls.Button;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.PropertyChangeEventKind;
import mx.events.ValidationResultEvent;

/**
 * Exemple class of a FieldInspector renderer
 *
 * Display a String date into a DateField with
 * an extra button to set the date to today
 */
public class MyCalendarEditor extends CalendarField implements IFieldRenderer
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor
     *
     */
    public function MyCalendarEditor()
    {
        super();
        this.dateFormat = "MM/DD/YYYY";
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var m_todayButton:Button;

    [Embed(source="/assets/TodayCalendarIcon.png")]
    private var m_todayButtonSkin:Class;

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------

    private var m_oldDataValue:Object;

    override public function get data():Object
    {
        // CalendarField handles dates as time,
        // so return the formatted date.
        return formatToString(super.data);
    }

    override public function set data(value:Object):void
    {
        if (m_oldDataValue != value)
        {
            m_oldDataValue = value;
            var date:Date = new Date(value);
            super.data = date.time;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    override protected function createChildren():void
    {
        super.createChildren();

        if (!m_todayButton)
        {
            m_todayButton = new Button();
            m_todayButton.toolTip = "Set to today's date";
            m_todayButton.setStyle("disabledSkin", m_todayButtonSkin);
            m_todayButton.setStyle("downSkin", m_todayButtonSkin);
            m_todayButton.setStyle("overSkin", m_todayButtonSkin);
            m_todayButton.setStyle("upSkin", m_todayButtonSkin);

            m_todayButton.addEventListener(MouseEvent.CLICK, todayButtonClickHandler);

            addChild(m_todayButton);
        }
    }

    override protected function measure():void
    {
        super.measure();

        // Add the todayButton width to the measured width

        var buttonWidth:Number = m_todayButton.getExplicitOrMeasuredWidth();
        var buttonHeight:Number = m_todayButton.getExplicitOrMeasuredHeight();

        measuredMinWidth = measuredWidth += buttonWidth;
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        var buttonWidth:Number = m_todayButton.getExplicitOrMeasuredWidth();
        var buttonHeight:Number = m_todayButton.getExplicitOrMeasuredHeight();

        // layout the textInput and the calendar icon, but keep space for the today button
        super.updateDisplayList(unscaledWidth - buttonWidth, unscaledHeight);

        // Disable the calendar if the date isn't editable
        m_todayButton.move(unscaledWidth - buttonWidth, 0);
        m_todayButton.setActualSize(buttonWidth, buttonHeight);
        m_todayButton.visible = enabled;
    }

    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @inheritDoc
     */
    override public function validate():void
    {
        var event:ValidationResultEvent = requiredValidator.validate();
        var currentData:Object = this.data;
        if ((!event || !event.results || event.results.length == 0) && m_oldDataValue != currentData)
        {
            var pce:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
                                                                  true,
                                                                  false,
                                                                  PropertyChangeEventKind.UPDATE,
                                                                  "data",
                                                                  m_oldDataValue,
                                                                  currentData,
                                                                  this);
            dispatchEvent(pce);
            m_oldDataValue = currentData;
        }
        dispatchEvent(new FlexEvent(event.type, true));
    }


    protected function todayButtonClickHandler(event:MouseEvent):void
    {
        data = formatToString(new Date());
    }

}

}
