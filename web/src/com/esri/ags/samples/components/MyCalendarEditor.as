package com.esri.ags.samples.components
{

import com.esri.ags.components.AttributeInspector;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Button;
import mx.controls.DateField;
import mx.core.mx_internal;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.PropertyChangeEventKind;
import mx.events.ValidationResultEvent;
import mx.formatters.DateFormatter;
import mx.validators.DateValidator;

/**
 * Exemple class of a FieldInspector renderer
 *
 * Display a String date into a DateField with
 * an extra button to set the date to today
 */
public class MyCalendarEditor extends DateField
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

        yearNavigationEnabled = true;
        addEventListener(CalendarLayoutChangeEvent.CHANGE, changeHandler, false, -1);

        m_dateValidator.required = false;
        m_dateValidator.source = this;
        m_dateValidator.property = "text";
        m_dateValidator.triggerEvent = CalendarLayoutChangeEvent.CHANGE;
        m_dateValidator.addEventListener(ValidationResultEvent.VALID, dateValidator_validHandler);
        m_dateValidator.addEventListener(ValidationResultEvent.INVALID, dateValidator_invalidHandler);

        m_dateValidator.inputFormat = m_dateFormatter.formatString = formatString = "MM/DD/YYYY";
    }


    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var m_dateFormatter:DateFormatter = new DateFormatter();

    private var m_dateValidator:DateValidator = new DateValidator();

    private var m_todayButton:Button;

    private var m_isDateValid:Boolean;

    [Embed(source="/assets/TodayCalendarIcon.png")]
    private var m_todayButtonSkin:Class;

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------

    private var m_oldDataValue:Object;

    override public function get data():Object
    {
        return m_dateFormatter.format(super.selectedDate);
    }

    override public function set data(value:Object):void
    {
        m_oldDataValue = value;
        // The date is a String
        var date:Date = new Date(value);
        super.selectedDate = date;
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

        if (!this.textInput)
        {
            m_dateValidator.trigger = this.textInput;
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
        // Disable the calendar if the date isn't editable
        if (mx_internal::downArrowButton)
        {
            mx_internal::downArrowButton.visible = enabled;
        }

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

    protected function todayButtonClickHandler(event:MouseEvent):void
    {
        data = new Date();
        m_dateValidator.validate();

        var e:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
        e.newDate = selectedDate;
        dispatchEvent(e);
    }

    private function dateValidator_invalidHandler(event:ValidationResultEvent):void
    {
        m_isDateValid = false;
    }

    private function dateValidator_validHandler(event:ValidationResultEvent):void
    {
        m_isDateValid = true;
    }

    protected function changeHandler(event:CalendarLayoutChangeEvent):void
    {
        if (m_isDateValid)
        {
            // Update the Feature
            var pce:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
                                                                  true,
                                                                  false,
                                                                  PropertyChangeEventKind.UPDATE,
                                                                  "data",
                                                                  m_oldDataValue,
                                                                  data,
                                                                  this);
            dispatchEvent(pce);
        }
    }
}

}
