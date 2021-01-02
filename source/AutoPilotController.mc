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

class AutoPilotController {
    var autopilotState = "---";
    var isAutopilotRequestPending = false;
    
    var client;

    function initialize(client_) {
    	client = client_;
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
        timer = new Timer.Timer();
        timer.start(method( : startUpdatingData), retryInterval, false);
    }
}