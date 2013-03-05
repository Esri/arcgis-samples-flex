package com.esri.ags.samples.tasks.supportClasses
{

import com.esri.ags.geometry.Extent;
import com.esri.ags.geometry.Geometry;
import com.esri.ags.geometry.Polyline;

/**
 * Input parameters for the ElevationsSOETask
 *
 * <p>Note: ElevationsSOEParameters, and other elevations SOE related classes, require a custom Server Objection Extension (SOE) service.
 * <a href="http://sampleserver4.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/MapServer/exts/ElevationsSOE" target="_blank">View the service</a>.</p>
 *
 * @since Your API for Flex 1.0
 *
 */
public class ElevationsSOEParameters
{
    //--------------------------------------------------------------------------
    //
    // Input parameters for GetElevationAtLonLat
    //
    //--------------------------------------------------------------------------
    /**
     * The longitude coordinate as a double.
     */
    public var longitude:Number;
    /**
     * The latitude coordinate as a double.
     */
    public var latitude:Number;
    //--------------------------------------------------------------------------
    //
    // Input parameters for GetElevations
    //
    //--------------------------------------------------------------------------
    /**
     * The array of geometries that will be used to calculate the elevations along the path.
     */
    public var geometries:Array;
    //--------------------------------------------------------------------------
    //
    // Input parameters for GetElevationData
    //
    //--------------------------------------------------------------------------
    /**
     * The interpolation extent.
     */
    public var extent:Extent;
    /**
     * Number of rows.  (Note: Rows * Columns &lt;= 10,000)
     */
    public var rows:Number;
    /**
     * Number of columns.  (Note: Rows * Columns &lt;= 10,000)
     */
    public var columns:Number;
    //--------------------------------------------------------------------------
    //
    // Input parameters for GetElevationProfile
    //
    //--------------------------------------------------------------------------
    /**
     * Polyline over which to calculate profile.
     */
    public var inputPolyline:Polyline;
    /**
     * Width of the output image as an integer.
     */
    public var imageWidth:Number;
    /**
     * Height of the output image as an integer.
     */
    public var imageHeight:Number;
    /**
     * Background color of the image as a hex value.
     */
    public var backgroundColorHex:uint;
    /**
     * Display a vertical line for each line segment as a boolean.
     */
    public var isDisplaySegments:Boolean;


    public function ElevationsSOEParameters()
    {
    }
}
}
