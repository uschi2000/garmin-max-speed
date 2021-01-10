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
    }

    function login() {
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
        } else {
            System.println("Login failed: " + responseCode);
        }
    }

    function getVesselData(onSuccess, onError) {
    	if (token == null) {
    		login();
    	}

		var callback = new GetVesselDataCallback(onSuccess, onError, method(:login));
		Communications.makeWebRequest(
            baseUrl + "/plugins/minimumvesseldatarest/vesseldata",
            {},
            {
            	:method => Communications.HTTP_REQUEST_METHOD_GET,
              	:headers => {                                         
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED,
                    "Authorization" => token
                },
             	:responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            },
            callback.method(:apply)
        );
    }
}

class GetVesselDataCallback {
  var onSuccess;
  var onError;
  var onAuthFailed;
  
  function initialize(onSuccess_, onError_, onAuthFailed_) {
    onSuccess = onSuccess_;
    onError = onError_;
    onAuthFailed = onAuthFailed_;
  }
  
  function apply(responseCode, data) {
  	if (responseCode == 200) {
        onSuccess.invoke(data);
    } else if (responseCode == 401 || responseCode == -400) {
    	System.println("Not authorized, trying to login again");
    	onError.invoke(responseCode);
        onAuthFailed.invoke(); 
    } else {
    	System.println("Unknown networking error: " + responseCode);
    	onError.invoke(responseCode);
    }
  }
}
  