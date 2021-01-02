using Toybox.System;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;

class LineController {

    var boatX;
    var boatY;
    var pinX;
    var pinY;

    function initialize() {}
    
    function setBoatPosition(x, y) {
    	System.println("Setting starting boat position: x=" + x + " , y=" + y);
        boatX = x;
        boatY = y;
    }
    
    function setPinPosition(x, y) {
    	System.println("Setting starting pin position: x=" + x + " , y=" + y);
        pinX = x;
        pinY = y;
    }
}
