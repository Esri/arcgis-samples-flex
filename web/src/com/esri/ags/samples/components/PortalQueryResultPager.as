package com.esri.ags.samples.components
{

import com.esri.ags.portal.supportClasses.PortalQueryParameters;
import com.esri.ags.portal.supportClasses.PortalQueryResult;
import com.esri.ags.samples.events.PortalQueryEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayList;
import mx.collections.IList;

import spark.components.Button;
import spark.components.DataGroup;
import spark.components.supportClasses.ListBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.IndexChangeEvent;
import spark.events.RendererExistenceEvent;

//--------------------------------------
//  Events
//--------------------------------------

[Event(name="newQuery", type="com.esri.ags.samples.events.PortalQueryEvent")]

/**
 * Simple component to help paging results from a query against the portal
 */
public class PortalQueryResultPager extends SkinnableComponent
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor
     */
    public function PortalQueryResultPager()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  queryResult
    //---------------------------------- 

    private var m_queryResult:PortalQueryResult;

    [Bindable("queryResultChange")]

    /**
     * The result from the query.
     */
    public function get queryResult():PortalQueryResult
    {
        return m_queryResult;
    }

    /**
     * @private
     */
    public function set queryResult(value:PortalQueryResult):void
    {
        if (m_queryResult != value)
        {
            m_queryResult = value;

            m_pages.removeAll();

            var pageSize:int = m_queryResult.queryParameters.limit;
            var selectedPage:int = Math.ceil(m_queryResult.queryParameters.startIndex / pageSize);
            var numPages:int = Math.ceil(m_queryResult.totalResults / pageSize);

            if (numPages > 0)
            {
                var i:int = selectedPage - 1;
                while (i > 0 && i > selectedPage - 4)
                {
                    m_pages.addItemAt(createPageItem(i), 0);
                    i--;
                }

                m_pages.addItem(createPageItem(selectedPage));
                m_selectedIndex = m_pages.length - 1;

                i = selectedPage + 1;
                while (i <= numPages && i < selectedPage + 4)
                {
                    m_pages.addItem(createPageItem(i));
                    i++;
                }

                if (m_pages.getItemAt(0).label != "1")
                {
                    m_pages.addItemAt({ label: "...", enabled: false }, 0);
                    m_pages.addItemAt(createPageItem(1), 0);
                    m_selectedIndex += 2;
                }

                if (m_pages.getItemAt(m_pages.length - 1).label != numPages.toString())
                {
                    m_pages.addItem({ label: "...", enabled: false });
                    m_pages.addItem(createPageItem(numPages));
                }

                enabled = true;
            }
            else
            {
                enabled = false;
                m_selectedIndex = -1;
            }

            if (pageList)
            {
                pageList.invalidateSize();
                invalidateSize();
                skin.invalidateSize();
            }

            dispatchEvent(new Event("queryResultChange"));
        }
    }

    private function createPageItem(pageNumber:uint):Object
    {
        return { uid: pageNumber.toString(), label: pageNumber.toString(), enabled: true };
    }

    //----------------------------------
    //  selectedIndex
    //---------------------------------- 

    private var m_selectedIndex:int;

    [Bindable("queryResultChange")]

    /**
     * @private
     * The selected item of the page list.
     */
    public function get selectedIndex():int
    {
        return m_selectedIndex;
    }

    //----------------------------------
    //  pages
    //---------------------------------- 

    private var m_pages:IList = new ArrayList;

    [Bindable("queryResultChange")]

    /**
     * @private
     * The list of items to display in the list.
     */
    public function get pages():IList
    {
        return m_pages;
    }

    //----------------------------------
    //  hasPrevious
    //---------------------------------- 

    [Bindable("queryResultChange")]

    /**
     * @private
     * Flag that is <code>true</code> if previous results can be queried.
     */
    public function get hasPrevious():Boolean
    {
        return m_queryResult && m_queryResult.hasPrevious;
    }

    //----------------------------------
    //  hasNext
    //---------------------------------- 

    [Bindable("queryResultChange")]

    /**
     * @private
     * Flag that is <code>true</code> if next results can be queried.
     */
    public function get hasNext():Boolean
    {
        return m_queryResult && m_queryResult.hasNext;
    }

    //--------------------------------------------------------------------------
    //
    //  Skin parts 
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  previousButton
    //---------------------------------- 

    [SkinPart(required="false")]

    /**
     * The button used to ask for the previous page.
     */
    public var previousButton:Button;

    //----------------------------------
    //  nextButton
    //---------------------------------- 

    [SkinPart(required="false")]

    /**
     * The button used to ask for the next page.
     */
    public var nextButton:Button;

    //----------------------------------
    //  pageList
    //---------------------------------- 

    [SkinPart(required="false")]

    /**
     * The list of pages.
     */
    public var pageList:ListBase;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods : Skin management
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override protected function getCurrentSkinState():String
    {
        return super.getCurrentSkinState();
    }

    /**
     * @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        if (instance === pageList)
        {
            pageList.addEventListener(IndexChangeEvent.CHANGE, indexChangeHandler);
        }
        else if (instance === previousButton)
        {
            previousButton.addEventListener(MouseEvent.CLICK, previousHandler);
        }
        else if (instance === nextButton)
        {
            nextButton.addEventListener(MouseEvent.CLICK, nextHandler);
        }
    }

    /**
     * @private
     */
    override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        if (instance === pageList)
        {
            pageList.removeEventListener(IndexChangeEvent.CHANGE, indexChangeHandler);
        }
        else if (instance === previousButton)
        {
            previousButton.removeEventListener(MouseEvent.CLICK, previousHandler);
        }
        else if (instance === nextButton)
        {
            previousButton.removeEventListener(MouseEvent.CLICK, nextHandler);
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Event handler
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     * dispatch an event with the PortalQueryParameters for the selected page.
     */
    private function indexChangeHandler(event:IndexChangeEvent):void
    {
        event.preventDefault();
        var queryParameters:PortalQueryParameters = queryResult.queryParameters.clone();
        queryParameters.startIndex = ((uint(m_pages.getItemAt(event.newIndex).label) - 1) * queryParameters.limit) + 1;
        dispatchEvent(new PortalQueryEvent(PortalQueryEvent.NEW_QUERY, queryParameters));
        enabled = false;
    }

    /**
     * @private
     * dispatch an event with the PortalQueryParameters for the next page.
     */
    private function nextHandler(event:MouseEvent):void
    {
        dispatchEvent(new PortalQueryEvent(PortalQueryEvent.NEW_QUERY, queryResult.nextQueryParameters));
        enabled = false;
    }

    /**
     * @private
     * dispatch an event with the PortalQueryParameters for the previous page.
     */
    private function previousHandler(event:MouseEvent):void
    {
        dispatchEvent(new PortalQueryEvent(PortalQueryEvent.NEW_QUERY, queryResult.previousQueryParameters));
        enabled = false;
    }

}
}
