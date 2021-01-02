using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.System;
using Toybox.Position;

class VesselConnectApp extends Application.AppBase {
  var client;
  var controllers;

  function initialize() {
    AppBase.initialize();
    client = new SignalKClient();
    onSettingsChanged();
    controllers = new Controllers(new VesselController(client), new LineController()); 
  }

  function onSettingsChanged() {
  	System.println("Reloading app configuration");
    client.configure(
    	Properties.getValue("baseurl_prop"),
    	Properties.getValue("username_prop"),
    	Properties.getValue("password_prop")
    );
  }

  function getInitialView() {
    return [ new VesselDataView(controllers), new VesselDataViewDelegate(controllers) ];
  }
}