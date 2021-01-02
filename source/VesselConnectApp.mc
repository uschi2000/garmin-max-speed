using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.System;

class VesselConnectApp extends Application.AppBase {
  var client;
  var controller;

  function initialize() {
    AppBase.initialize();
    client = new SignalKClient();
    controller = new VesselController(client);
  }

  function onStart(state) {
    onSettingsChanged();
  	controller.startUpdatingData();
  }

  function onStop(state) {
  	controller.stopUpdatingData();
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
    return [ new VesselDataView(controller), new VesselDataViewDelegate(controller) ];
  }
}