using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;

using Utilities as Utils;

class VesselController {
    const updateInterval = 1000;
    const retryInterval = 3000;
    var timer;
    var error = null;
    
    var client;
    var model;

    function initialize(client_) {
    	client = client_;
    	model = new VesselModel();
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }
    
    function onPosition(info) {
	    model.position = info.position;
	}
    
    function getModel() {
    	return model;
    }

    function startUpdatingData() {
        System.println("Start updating data");
		getVesselData();
    }

    function stopUpdatingData() {
        System.println("Stop updating data");

        Communications.cancelAllRequests();
        invalidateTimer();
    }

    function invalidateTimer() {
        if (timer == null) {
            return;
        }

        timer.stop();
        timer = null;
    }

    function getVesselData() {
    	System.println("Updating vessel data");
        invalidateTimer();
        client.getVesselData(method(:getVesselDataOnSuccess), method(:getVesselDataOnError));
    }
    
    function getVesselDataOnSuccess(data) {
		model.speedThroughWater = valueOrZero(data["speedThroughWater"]);
		model.speedOverGround = valueOrZero(data["speedOverGround"]);
		model.courseOverGround = valueOrZero(data["courseOverGroundTrue"]);
		model.magneticVariation = valueOrZero(data["magneticVariation"]);
		model.waterTemperature = valueOrZero(data["waterTemperature"]);
		model.windSpeedApparent = valueOrZero(data["windSpeedApparent"]);
		model.windAngleApparent = valueOrZero(data["windAngleApparent"]);
		model.windSpeedTrue = valueOrZero(data["windSpeedTrue"]);
		model.windAngleTrue = valueOrZero(data["windAngleTrue"]);
		model.tripTotal = valueOrZero(data["tripTotal"]);
		model.depthBelowKeel = valueOrZero(data["depthBelowKeel"]);
        
        WatchUi.requestUpdate();
        timer = new Timer.Timer();
        timer.start(method(:getVesselData), updateInterval, false);
        error = null;
    }
    
    function getVesselDataOnError(errorCode) {
		model.reset();
		WatchUi.requestUpdate();
		timer = new Timer.Timer();
		timer.start(method(:getVesselData), retryInterval, false);
		error = "Failure: " + client.baseUrl + errorCode;
    }

    function valueOrZero(value) {
        if (value != null) {
            return value;
        } else {
            return 0.0;
        }
    }
}
