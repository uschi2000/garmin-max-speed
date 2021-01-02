using Toybox.Application;
using Toybox.System;

class VesselConnectApp extends Application.AppBase {
  var client;
  var controller;

  function initialize() {
    AppBase.initialize();
    client = new SignalKClient();
    onSettingsChanged();
    controller = new VesselController(client);
  }

  function onStart(state) {
  	controller.startUpdatingData();
  }

  function onStop(state) {
  	controller.stopUpdatingData();
  }

  function onSettingsChanged() {
    client.configure(
    	Application.Properties.getValue("baseurl_prop"),
    	Application.Properties.getValue("username_prop"),
    	Application.Properties.getValue("password_prop")
    );
  }

  function getInitialView() {
    return [ new VesselDataView(controller.getModel()), new VesselDataViewDelegate(controller) ];
  }
}