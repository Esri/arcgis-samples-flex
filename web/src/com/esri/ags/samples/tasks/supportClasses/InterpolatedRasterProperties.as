package com.esri.ags.samples.tasks.supportClasses
{

/**
 * Properties of the interpolated raster as an object.
 *
 * <p>Note: InterpolatedRasterProperties, and other elevations SOE related classes, require a custom Server Objection Extension (SOE) service.
 * <a href="http://sampleserver4.arcgisonline.com/ArcGIS/rest/services/Elevation/ESRI_Elevation_World/MapServer/exts/ElevationsSOE" target="_blank">View the service</a>.</p>
 *
 * @since Your API for Flex 1.0
 *
 * @see com.esri.ags.samples.tasks.supportClasses.ElevationsSOEResult
 */
public class InterpolatedRasterProperties
{

    /**
     * A flag reporting if the values are of type integer.
     */
    public var isInteger:Boolean;
    /**
     * The minimum value in the entire elevation dataset.
     */
    public var datasetMinimum:Number;
    /**
     * The maximum value in the entire elevation dataset.
     */
    public var datasetMaximum:Number;

    public function InterpolatedRasterProperties()
    {
    }
}
}
