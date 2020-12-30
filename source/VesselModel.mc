using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;

using Utilities as Utils;

class VesselModel {
    public var speedOverGround;  // meter/second
   public
    var apparentWindSpeed;  // meter/second
   public
    var trueWindSpeed;  // meter/second
   public
    var depthBelowTranscuder;  // meter
   public
    var tripTotal;  // meter
   public
    var apparentWindAngle;  // radians
   public
    var courseOverGround;  // radians
   public
    var headingMagnetic;  // radians
   public
    var rudderAngle;  // radians
   public
    var waterTemperature;  // kelvin

   public
    var targetHeadingTrue;  // radians
   public
    var targetHeadingMagnetic;  // radians
   public
    var targetHeadingWindAppearant;  // radians

	function initialize() {
	 	reset();
	}

	function reset() {
		speedOverGround = 0.0;
		// TODO
	}

    function getSpeedOverGroundKnotsString() {
        return Utils.meterPerSecondToKnots(speedOverGround).format("%.1f");
    }

    function getApparentWindSpeedKnotsString() {
        return Utils.meterPerSecondToKnots(apparentWindSpeed).format("%.1f");
    }

    function getTrueWindSpeedKnotsString() {
        return Utils.meterPerSecondToKnots(trueWindSpeed).format("%.1f");
    }

    function getDepthBelowTranscuderMeterString() {
        if (depthBelowTranscuder > 500.0d) {
            return "---";
        }
        return depthBelowTranscuder.format("%.1f") + "m";
    }

    function getTripTotalString() {
        return Utils.metersToNauticalMiles(tripTotal).format("%.1f") + "nm";
    }

    function getWaterTemperatureString() {
        return Utils.kelvinToCelsius(waterTemperature).format("%.1f") + "°C";
    }

    function getAppearantWindAngleDegreeString() {
        var degrees = Utils.radiansToDegrees(apparentWindAngle).abs();
        return degrees.format("%.0f") + "°";
    }

    function getCourseOverGroundDegreeString() {
        var degrees = Utils.radiansToDegrees(courseOverGround).abs();
        return degrees.format("%.0f") + "°";
    }

    function getHeadingMagneticDegreeString() {
        var degrees = Utils.radiansToDegrees(headingMagnetic).abs();
        return degrees.format("%.0f") + "°";
    }

    function getTargetHeadingTrueDegreeString() {
        var degrees = Utils.radiansToDegrees(targetHeadingTrue).abs();
        return degrees.format("%.0f") + "°";
    }

    function getTargetHeadingMagneticDegreeString() {
        var degrees = Utils.radiansToDegrees(targetHeadingMagnetic).abs();
        return degrees.format("%.0f") + "°";
    }

    function getTargetHeadingWindAppearantDegreeString() {
        var degrees = Utils.radiansToDegrees(targetHeadingWindAppearant).abs();
        return degrees.format("%.0f") + "°";
    }

    function getNameForActiveState() {
        var stateName = autopilotState.toUpper();
        if (stateName.equals("ROUTE")) {
            stateName = "TRACK";
        }
        return stateName;
    }

    function setAutopilotState(state) {
        var command = {"action" => "setState", "value" => state};
        sendAutopilotCommand(command);
    }

    function changeHeading(change) {
        var command = {"action" => "changeHeading", "value" => change};
        sendAutopilotCommand(command);
    }

    function logState() {
        System.println(
            "SOG: " + speedOverGround + "\n");
//            + "\nAWS: " + apparentWindSpeed +
//            "\nDBT: " + depthBelowTranscuder + "\nAWA: " + apparentWindAngle +
//            "\nCOG: " + courseOverGround + "\nHDG(m): " + headingMagnetic +
//            "\nWaterTemp: " + getWaterTemperatureString() +
//            "\nTripTotal: " + getTripTotalString() + "\nTARGET_HDG_MAG: " +
//            targetHeadingMagnetic + "\nTARGET_HDG_TRUE: " + targetHeadingTrue +
//            "\nTARGET_AWA: " + targetHeadingWindAppearant +
//            "\nRudder: " + rudderAngle + "\nAUTOPILOT: " + autopilotState +
//            "\n---------------\n");
    }
}