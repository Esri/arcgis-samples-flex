package com.esri.ags.samples.events
{

import com.esri.ags.portal.supportClasses.PortalQueryParameters;

import flash.events.Event;

/**
 * The PortalQueryEvent class represents event objects dispatched by the PortalQueryResultPager class.
 */
public class PortalQueryEvent extends Event
{

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     * The PortalQueryEvent.NEW_QUERY constant defines the value of the type property of the event object for an new query event.
     */
    public static const NEW_QUERY:String = "newQuery";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     *
     * @param type The event type.
     * @param queryParameters The query parameters for the new query.
     */
    public function PortalQueryEvent(type:String, queryParameters:PortalQueryParameters)
    {
        super(type, true, false);
        m_queryParameters = queryParameters;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  queryParameters
    //---------------------------------- 

    private var m_queryParameters:PortalQueryParameters;

    /**
     * The query parameters for the new query.
     */
    public function get queryParameters():PortalQueryParameters
    {
        return m_queryParameters;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override public function clone():Event
    {
        return new PortalQueryEvent(type, queryParameters);
    }

}
}
