using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;
using Toybox.Math;
using Toybox.Position;

class VesselModel {
	// Note: use getters to access these variables with
	// consistent units and formatting.
	var position; // Toybox.Position.Location
	var speedThroughWater; // meter/second
    var speedOverGround;  // meter/second
    var courseOverGround;  // radians
    var magneticVariation; // radians
    var waterTemperature;  // kelvin
    var windSpeedApparent;  // meter/second
    var windAngleApparent;  // radians
    var windSpeedTrue;  // meter/second
    var windAngleTrue;  // radians   
    var tripTotal;  // meter
    var depthBelowKeel; // meter

	function initialize() {
	 	reset();
	}

	function reset() {
		position = new Position.Location(
		    {
		        :latitude => 0,
		        :longitude => 0,
		        :format => :degrees
		    });
		speedThroughWater = 0;
	    speedOverGround = 0;
	   	courseOverGround = 0;
	   	magneticVariation = 0;
	    waterTemperature = 0;
	    windSpeedApparent = 0;
	    windAngleApparent = 0;
	    windSpeedTrue = 0;
	    windAngleTrue = 0;
	    tripTotal = 0;
	    depthBelowKeel = 0;
	}
	
	function getPosition() {
		return position.toGeoString(Position.GEO_DMS);
	}

	function getSpeedThroughWater() {
        return Conversions.meterPerSecondToKnots(speedThroughWater).format("%.1f");
    }

    function getSpeedOverGround() {
        return Conversions.meterPerSecondToKnots(speedOverGround).format("%.1f");
    }
    
    function getCourseOverGround() {
        var degrees = Conversions.radiansToDegrees(courseOverGround).abs();
        return degrees.format("%.0f") + "°";
    }
    
    function getMagneticVariation() {
        var degrees = Conversions.radiansToDegrees(magneticVariation).abs();
        return degrees.format("%.0f") + "°";
    }
    
    function getWaterTemperature() {
        return Conversions.kelvinToCelsius(waterTemperature).format("%.1f") + "°C";
    }

    function getWindSpeedApparent() {
        return Conversions.meterPerSecondToKnots(windSpeedApparent).format("%.1f");
    }
    
    function getWindAngleApparent() {
        var degrees = Conversions.radiansToDegrees(windAngleApparent).abs();
        return degrees.format("%.0f") + "°";
    }

    function getWindSpeedTrue() {
        return Conversions.meterPerSecondToKnots(windSpeedTrue).format("%.1f");
    }
    
    function getWindAngleTrue() {
        var degrees = Conversions.radiansToDegrees(windAngleTrue).abs();
        return degrees.format("%.0f") + "°";
    }

    function getTripTotal() {
        return Conversions.metersToNauticalMiles(tripTotal).format("%.1f") + "nm";
    }
    
    function getDepthBelowKeel() {
        return depthBelowKeel.format("%.1f") + "m";
    }
}