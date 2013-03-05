// Used by GeoRSSApp.mxml
package com.esri.ags.samples
{

import com.esri.ags.Graphic;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.rpc.http.mxml.HTTPService;

[Event(name="complete", type="flash.events.Event")]

[Event(name="error", type="flash.events.ErrorEvent")]

[Event(name="fault", type="mx.rpc.events.FaultEvent")]

public class GeoRSSProvider extends EventDispatcher
{
    private static const ATOM:Namespace = Namespaces.ATOM_NS;

    private var m_httpService:mx.rpc.http.mxml.HTTPService = new mx.rpc.http.mxml.HTTPService();

    [Bindable]
    public var result:ArrayCollection = new ArrayCollection();

    public var georssFunction:Function;

    public function GeoRSSProvider()
    {
        m_httpService.useProxy = false;
        m_httpService.requestTimeout = 30;
        m_httpService.showBusyCursor = true;
        m_httpService.resultFormat = mx.rpc.http.HTTPService.RESULT_FORMAT_E4X;
        m_httpService.addEventListener(ResultEvent.RESULT, resultHandler);
        m_httpService.addEventListener(FaultEvent.FAULT, faultHandler);
    }

    private function internalFunction(
        arrcol:ArrayCollection,
        x:XML):void
    {
        arrcol.addItem(new Graphic(GeoRSSUtil.toGeometry(x)));
    }

    private function resultHandler(event:ResultEvent):void
    {
        result.removeAll();
        if (event.result is XML)
        {
            var x:XML = XML(event.result);
            if (x.name() == "rss" && Number(x.@version) <= 2)
            {
                parseRSS(x, georssFunction == null ? internalFunction : georssFunction);
            }
            else if (x.namespace().uri.toLowerCase() == "http://www.w3.org/2005/atom")
            {
                parseAtom(x, georssFunction == null ? internalFunction : georssFunction);
            }
            else
            {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Unable to determine feed type"));
            }
        }
        else
        {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "HTTP response is not XML"));
        }
    }

    private function parseAtom(
        x:XML,
        f:Function):void
    {
        for each (var entryXML:XML in x.ATOM::entry)
        {
            f(result, entryXML);
        }
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function parseRSS(
        x:XML,
        f:Function):void
    {
        for each (var itemXML:XML in x.channel.item)
        {
            f(result, itemXML);
        }
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function faultHandler(event:FaultEvent):void
    {
        dispatchEvent(event);
    }

    private var m_urlChanged:Boolean = false;

    public function get requestTimeout():Number
    {
        return m_httpService.requestTimeout;
    }

    public function set requestTimeout(value:Number):void
    {
        m_httpService.requestTimeout = value;
    }

    public function get url():String
    {
        return m_httpService.url;
    }

    public function set url(value:String):void
    {
        if (value != m_httpService.url)
        {
            m_urlChanged = true;
            if (value.indexOf("feed://") == 0)
            {
                m_httpService.url = "http://" + value.substr(7);
            }
            else
            {
                m_httpService.url = value;
            }
            invalidateProperties();
        }
    }

    private var m_invalidateProperties:Boolean = false;

    private function invalidateProperties():void
    {
        if (m_invalidateProperties == false)
        {
            m_invalidateProperties = true;
            FlexGlobals.topLevelApplication.callLater(preCommitProperties);
        }
    }

    private function preCommitProperties():void
    {
        m_invalidateProperties = false;
        commitProperties();
    }

    private function commitProperties():void
    {
        if (m_urlChanged)
        {
            m_urlChanged = false;
            m_httpService.send();
        }
    }
}

}
