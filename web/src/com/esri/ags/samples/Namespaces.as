// Used by GeoRSSApp.mxml
package com.esri.ags.samples
{

public class Namespaces
{
    public static const RDF_NS:Namespace = new Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#");
    public static const DC_NS:Namespace = new Namespace("http://purl.org/dc/elements/1.1/");
    public static const SY_NS:Namespace = new Namespace("http://purl.org/rss/1.0/modules/syndication/");
    public static const CO_NS:Namespace = new Namespace("http://purl.org/rss/1.0/modules/company/");
    public static const TI_NS:Namespace = new Namespace("http://purl.org/rss/1.0/modules/textinput/");
    public static const RSS_NS:Namespace = new Namespace("http://purl.org/rss/1.0/");
    public static const ATOM_NS:Namespace = new Namespace("http://www.w3.org/2005/Atom");
    public static const ATOM_03_NS:Namespace = new Namespace("http://purl.org/atom/ns#");
    public static const XHTML_NS:Namespace = new Namespace("http://www.w3.org/1999/xhtml");
    public static const CONTENT_NS:Namespace = new Namespace("http://purl.org/rss/1.0/modules/content/");
    public static const GEORSS_NS:Namespace = new Namespace("http://www.georss.org/georss");
    public static const GEOWGS_NS:Namespace = new Namespace("http://www.w3.org/2003/01/geo/wgs84_pos#");
    public static const GEO_NS:Namespace = new Namespace("http://www.w3.org/2003/01/geo/");
    public static const GML_NS:Namespace = new Namespace("http://www.opengis.net/gml");

    public function Namespaces(singletonEnforcer:SingletonEnforcer)
    {
    }

}
}

class SingletonEnforcer
{
}
