using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;
using Toybox.Math;

class VesselModel {
	public var speedThroughWater; // meter/second
    public var speedOverGround;  // meter/second
   	public
    var courseOverGround;  // radians
   public
    var waterTemperature;  // kelvin
   public
    var windSpeedApparent;  // meter/second
   public
    var windAngleApparent;  // radians
   public
    var windSpeedTrue;  // meter/second
   public
    var windAngleTrue;  // radians   
   public
    var tripTotal;  // meter
   public var depthBelowKeel; // meter

	function initialize() {
	 	reset();
	}

	function reset() {
		speedThroughWater = 0;
	    speedOverGround = 0;
	   	courseOverGround = 0;
	    waterTemperature = 0;
	    windSpeedApparent = 0;
	    windAngleApparent = 0;
	    windSpeedTrue = 0;
	    windAngleTrue = 0;
	    tripTotal = 0;
	    depthBelowKeel = 0;
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