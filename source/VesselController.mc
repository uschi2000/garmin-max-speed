using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;

using Utilities as Utils;

enum {
    AP_STATE_STANDBY = 0,
    AP_STATE_AUTO = 1,
    AP_STATE_WIND = 2,
    AP_STATE_TRACK = 3,
    AP_STATE_NOT_SUPPORTED = 4,
}

class VesselController {
    const updateInterval = 1000;
    const retryInterval = 3000;
    var timer;
    var error = null;

    var autopilotState = "---";
    var isAutopilotRequestPending = false;
    
    var client;
    var model;

    function initialize(client_) {
    	client = client_;
    	model = new VesselModel();
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

    function resetVesselData() {
		model.reset();
        autopilotState = "---";
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
		model.speedThroughWater = setValueIfPresent(data["speedThroughWater"]);
		model.speedOverGround = setValueIfPresent(data["speedOverGround"]);
		model.courseOverGround = setValueIfPresent(data["courseOverGroundTrue"]);
		model.magneticVariation = setValueIfPresent(data["magneticVariation"]);
		model.waterTemperature = setValueIfPresent(data["waterTemperature"]);
		model.windSpeedApparent = setValueIfPresent(data["windSpeedApparent"]);
		model.windAngleApparent = setValueIfPresent(data["windAngleApparent"]);
		model.windSpeedTrue = setValueIfPresent(data["windSpeedTrue"]);
		model.windAngleTrue = setValueIfPresent(data["windAngleTrue"]);
		model.tripTotal = setValueIfPresent(data["tripTotal"]);
		model.depthBelowKeel = setValueIfPresent(data["depthBelowKeel"]);

        // STRING VALUES
        if (data["autopilotState"] != null) {
            autopilotState = data["autopilotState"];
        } else {
            autopilotState = "---";
        }
        
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
		error = "Failed to update vessel data: " + errorCode;
    }

    function sendAutopilotCommand(command) {
        if (isAutopilotRequestPending == true) {
            return;
        }

        isAutopilotRequestPending = true;
        Communications.makeWebRequest(
            baseUrl + "/plugins/raymarineautopilotfork/command",
            command,
            {
              	:method => Communications.HTTP_REQUEST_METHOD_POST,
                :headers => {    
                	"Accept" => "application/json",                                      
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                    "Authorization" => token
                },
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            method(:onAutopilotReceive)
        );
    }

    function onAutopilotReceive(responseCode, data) {
        if (responseCode == 200) {
            Attention.playTone(Attention.TONE_KEY);
        } else {
            if (Attention has : vibrate) {
                Attention.vibrate([ new Attention.VibeProfile(50, 100) ]); // On for 200 ms
            }
        }
        isAutopilotRequestPending = false;
    }
    
    function setValueIfPresent(value) {
        if (value != null) {
            return value;
        } else {
            return 0.0;
        }
    }
}
