using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;

class LineController {

    var boatPosition = null; //type Toybox.Position.Location
    var pinPosition = null;

    function initialize() {}
    
    function setBoatPosition(pos) {
    	System.println("Setting starting boat position: " + pos.toGeoString(Position.GEO_DMS));
        boatPosition = pos;
    }
    
    function setPinPosition(pos) {
    	System.println("Setting starting pin position: " + pos.toGeoString(Position.GEO_DMS));
        pinPosition = pos;
    }
}
