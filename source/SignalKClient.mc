using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;
using Toybox.Application.Storage;

class SignalKClient {
    const tokenKey = "signalk-token";
   
    var baseUrl;
    var username;
    var password;
    var token;

    function configure(baseUrl_, username_, password_) {
    	baseUrl = baseUrl_;
        username = username_;
        password = password_;
        token = Storage.getValue(tokenKey);

        if (baseUrl == null || username == null || password == null) {
            System.println("Missing credentails");
//            credentialsAvailable = false;
        } else {
//            credentialsAvailable = true;
        }
    }

    function loginToSignalKServer() {
        token = null;
        Storage.setValue(tokenKey, null);

        Communications.makeWebRequest(
            baseUrl + "/signalk/v1/auth/login",
            {
            	"username" => username,
              	"password" => password
            },
            {
              	:method => Communications.HTTP_REQUEST_METHOD_POST,
                :headers => {                                          
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                },
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON 
            },
            method(:onLoginReceive)
        );
    }

    function onLoginReceive(responseCode, data) {
        if (responseCode == 200) {
            token = "JWT " + data["token"];
            Storage.setValue(tokenKey, token);
            updateVesselDataFromServer();
            errorCode = null;
        } else {
            System.println("Login failed: " + responseCode);
            showNetworkError(responseCode);
            startRetryTimer();
        }
    }

    function updateVesselDataFromServer(callback) {
        // TODO(rfink): Use https
        Communications.makeWebRequest(
            baseUrl + "/plugins/minimumvesseldatarest/vesseldata",
            {},
            {
            	:method => Communications.HTTP_REQUEST_METHOD_GET,
              	:headers => {                                         
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
                    // "Authorization" => token
                },
             	:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            callback
        );
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

    function showNetworkError(responseCode) {
        errorCode = responseCode;
        WatchUi.requestUpdate();
    }
}