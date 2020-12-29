using Toybox.Application;
using Toybox.System;

class VesselConnectApp extends Application.AppBase {

	var vessel;

    function initialize() {
        AppBase.initialize();
        vessel = new VesselModel();
    }
    
    function onStart(state) {
    	vessel.startUpdatingData();
    }
    
    function onStop(state) {
		vessel.stopUpdatingData();
    }
	
	function onSettingsChanged() {
		vessel.stopUpdatingData();
		vessel.configureSignalK();	
		vessel.startUpdatingData();
	}

    function getInitialView() {
    	return [ new VesselDataView(vessel), new VesselDataViewDelegate(vessel) ];
    }
}