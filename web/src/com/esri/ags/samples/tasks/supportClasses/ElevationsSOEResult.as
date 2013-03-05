package com.esri.ags.samples.tasks.supportClasses
{

import com.esri.ags.SpatialReference;
import com.esri.ags.geometry.Polyline;

import flash.events.EventDispatcher;

/**
 * The result from an ElevationsSOETask operation.
 *
 * <p>Note: ElevationsSOEResult, and other elevations SOE related classes, require a custom Server Objection Extension (SOE) service.
 * <a href="http://sampleserver4.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/MapServer/exts/ElevationsSOE" target="_blank">View the service</a>.</p>
 *
 * @since Your API for Flex 1.0
 *
 * @see com.esri.ags.samples.tasks.ElevationsSOETask
 */
public class ElevationsSOEResult extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    // Output parameters from GetElevationAtLonLat
    //
    //--------------------------------------------------------------------------

    [Bindable]
    /**
     * The elevation value at the input location as a double.
     */
    public var elevation:Number;

    //--------------------------------------------------------------------------
    //
    //  Output parameters from GetElevations
    //
    //--------------------------------------------------------------------------

    [Bindable]
    /**
     * Interpolated geometries as array of geometries.
     */
    public var geometries:Array;
    [Bindable]
    /**
     * Elevations as an array of doubles.
     */
    public var elevations:Array;
    [Bindable]
    /**
     * Sample distance used during interpolation.
     */
    public var sampleDistance:Number;
    [Bindable]
    /**
     * Elevations as an array, used for the chart data component.
     */
    public var chartDistances:Array;
    [Bindable]
    /**
     * Result data from GetElevations, used for the chart data component.
     */
    public var chartResultData:Object;

    //--------------------------------------------------------------------------
    //
    //  Output parameters from GetElevationData
    //
    //--------------------------------------------------------------------------

    [Bindable]
    /**
     * Number of columns as an integer.
     */
    public var numberOfColumns:int;
    [Bindable]
    /**
     * Number of rows as an integer.
     */
    public var numberOfRows:int;
    [Bindable]
    /**
     * X coordinate of the center of the lower left cell as a double.
     */
    public var xCoordLLCenter:Number;
    [Bindable]
    /**
     * Y coordinate of the center of the lower left cell as a double.
     */
    public var yCoordLLCenter:Number;
    [Bindable]
    /**
     * Horizontal cell size of the interpolated raster as a double.
     */
    public var cellSizeH:Number;
    [Bindable]
    /**
     * Vertical cell size of the interpolated raster as a double.
     */
    public var cellSizeV:Number;
    [Bindable]
    /**
     * ‘no data’ value as an array with a value for each band.
     */
    public var noDataValue:Array;
    [Bindable]
    /**
     * Spatial Reference of the interpolated raster as an object.
     */
    public var spatialReference:SpatialReference;
    [Bindable]
    /**
     * Elevation values as an array of values.
     */
    public var elevationData:Array;
    [Bindable]
    /**
     * Properties of the interpolated raster as an object.
     */
    public var rasterProperties:InterpolatedRasterProperties;

    //--------------------------------------------------------------------------
    //
    //  Output parameters from GetElevationProfile
    //
    //--------------------------------------------------------------------------

    [Bindable]
    /**
     * Full URL to the image on the servers.
     */
    public var profileImageURL:String;
    [Bindable]
    /**
     * 2D length of the line in meters as a double.
     */
    public var length2D:Number;
    [Bindable]
    /**
     * 3D length of the line in meters as a double.
     */
    public var length3D:Number;
    [Bindable]
    /**
     * How long it took to create the profile image as a double.
     */
    public var processTime:Number;
}

}
