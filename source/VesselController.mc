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

    var updateTimer;
    var retryTimer;

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
		updateVesselDataFromServer();
    }

    function stopUpdatingData() {
        System.println("Stop updating data");

        Communications.cancelAllRequests();
        invalidateTimer(updateTimer);
        invalidateTimer(retryTimer);
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

    function invalidateTimer(timer) {
        if (timer == null) {
            return;
        }

        timer.stop();
        timer = null;
    }

    function updateVesselDataFromServer() {
        invalidateTimer(updateTimer);
        client.updateVesselDataFromServer(method(:onReceive));
    }

    function onReceive(responseCode, data) {
        if (responseCode == -1003) {
            return;
        }

        if (responseCode == 200) {
            try {
                // FLOAT VALUES
//                depthBelowTranscuder =
//                    setValueIfPresent(data["depthBelowTransducer"]);
//                // trueWindSpeed =
//                // setValueIfPresent(data["windSpeedTrue"]);
//                apparentWindSpeed =
//                    setValueIfPresent(data["windSpeedApparent"]);
//                waterTemperature = setValueIfPresent(data["waterTemperature"]);
                model.speedOverGround = setValueIfPresent(data["speedOverGround"]);
//                courseOverGround =
//                    setValueIfPresent(data["courseOverGroundTrue"]);
//                apparentWindAngle =
//                    setValueIfPresent(data["windAngleApparent"]);
//                rudderAngle = setValueIfPresent(data["rudderAngle"]);
//                headingMagnetic = setValueIfPresent(data["headingMagnetic"]);
//                targetHeadingMagnetic =
//                    setValueIfPresent(data["autopilotTargetHeadingMagnetic"]);
//                targetHeadingTrue =
//                    setValueIfPresent(data["autopilotTargetHeadingTrue"]);
//                targetHeadingWindAppearant =
//                    setValueIfPresent(data["autopilotTargetWindAngleApparent"]);
//                tripTotal = setValueIfPresent(data["tripTotal"]);

                // STRING VALUES
                if (data["autopilotState"] != null) {
                    autopilotState = data["autopilotState"];
                } else {
                    autopilotState = "---";
                }
            } catch (ex) {
                ex.printStackTrace();
                model.reset();
            }

            WatchUi.requestUpdate();
            updateTimer = new Timer.Timer();
            updateTimer.start(method(
                                  : updateVesselDataFromServer),
                              updateInterval, false);
        } else {
            System.println("Response Code: " + responseCode);
            if (responseCode == 401 || responseCode == -400) {
            	// TODO: move this into client
                client.loginToSignalKServer();
            } else {
                resetVesselData();
                showNetworkError(responseCode);
                startRetryTimer();
            }
        }

        data = null;
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
                var vibeData = [
                    new Attention.VibeProfile(50,
                                              100),  // On for 200 ms
                ];
                Attention.vibrate(vibeData);
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

    function showNetworkError(responseCode) {
        errorCode = responseCode;
        WatchUi.requestUpdate();
    }

    function startRetryTimer() {
        System.println("Receivend Networking error. Retry in " +
                       retryInterval / 1000 + " seconds");
        retryTimer = new Timer.Timer();
        retryTimer.start(method( : startUpdatingData), retryInterval, false);
    }
}