using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

using Utilities as Utils;

class LineSelectionView extends WatchUi.View {

  var controllers;
  var width;
  var height;
  const PIXEL_RADIUS = 130;

  function initialize(controllers_) {
    controllers = controllers_;
    View.initialize();
  }

  function onUpdate(dc) {
    View.onUpdate(dc);
	
	var vesselPos = controllers.vessel.getModel().position;
	if (vesselPos == null) {
		System.println("Vessel position not known"); 
	} else {
		vesselPos = vesselPos.toDegrees();
		System.println("Vessel position: " + vesselPos);
	}
	
	var boatPos = controllers.line.boatPosition;
	if (boatPos == null) {
		System.println("Boat position not set");
	} else {
		boatPos = boatPos.toDegrees();
		System.println("Boat position: " + boatPos);
	}
	
	var pinPos = controllers.line.pinPosition; 
	if (pinPos == null) {
		System.println("Pin position not set");
	} else {
		pinPos = pinPos.toDegrees();
		System.println("Pin position: " + pinPos);
	}
	
	
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.clear();

    width = dc.getWidth();
    height = dc.getHeight();

    if ((vesselPos != null) && (boatPos != null) && (pinPos != null)) {
    	drawValues(dc, vesselPos, boatPos, pinPos);	
	}
  }

  function drawValues(dc, vesselPos, boatPos, pinPos) {
	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
	
	var midPoint = calcMidPoint(vesselPos, boatPos, pinPos);
	var scaleFactor = calcScalingFactor(vesselPos, boatPos, pinPos, midPoint);
	
	vesselPos = transposePos(vesselPos, midPoint, scaleFactor);
	boatPos = transposePos(boatPos, midPoint, scaleFactor);
	pinPos = transposePos(pinPos, midPoint, scaleFactor);
	midPoint = transposePos(midPoint, midPoint, scaleFactor);
	
	System.println("new vessel position: " + vesselPos);
	System.println("new boat position: " + boatPos);
	System.println("new pin position: " + pinPos);
	System.println("midpoint position: " + midPoint);
	
	dc.fillRoundedRectangle(vesselPos[0], vesselPos[1], 10, 20, 4);
	dc.drawCircle(midPoint[0], midPoint[1], 4);
	
	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
	dc.fillCircle(boatPos[0], boatPos[1], 5);
	dc.drawCircle(pinPos[0], pinPos[1], 4);
	dc.drawLine(boatPos[0], boatPos[1], pinPos[0], pinPos[1]);
  }
  
  
  function calcMidPoint(vesselPos, boatPos, pinPos) {
	var midPtx = (vesselPos[0] + boatPos[0] + pinPos[0]) / 3;
	var midPty = (vesselPos[1] + boatPos[1] + pinPos[1]) / 3;
	return [midPtx, midPty];
  }

  
  function calcScalingFactor(vesselPos, boatPos, pinPos, midPoint) {
    var len_vessel_midPoint = Math.sqrt(Math.pow((vesselPos[0] - midPoint[0]), 2) + (Math.pow((vesselPos[1] - midPoint[1]), 2)));
    var len_boat_midPoint = Math.sqrt(Math.pow((boatPos[0] - midPoint[0]), 2) + (Math.pow((boatPos[1] - midPoint[1]), 2)));
    var len_pin_midPoint = Math.sqrt(Math.pow((pinPos[0] - midPoint[0]), 2) + (Math.pow((pinPos[1] - midPoint[1]), 2)));
    
    var maxLength = len_vessel_midPoint;
    if (len_boat_midPoint > maxLength) { 
    	maxLength = len_boat_midPoint;  
	} else if (len_pin_midPoint > maxLength) {
		maxLength = len_pin_midPoint;
	}
	var scaleFactor = PIXEL_RADIUS / maxLength;
	
	return scaleFactor;
  }
    
    
  // subtract midpoint, scale, and normalize to 140x140 grid (with buffer space)
  function transposePos(objectPos, midPoint, scaleFactor) {
  	var objectPosx = objectPos[0] - midPoint[0];
  	objectPosx = objectPosx * scaleFactor + 140; 
  	
  	var objectPosy = objectPos[1] - midPoint[1];
  	objectPosy = objectPosy * scaleFactor + 140;
  	
  	return [objectPosx, objectPosy];
  }
}


class LineSelectionViewDelegate extends WatchUi.BehaviorDelegate {
  var controllers;

  function initialize(controllers_) {
    controllers = controllers_;
    BehaviorDelegate.initialize();
  }
  
  function onMenu() {
  	var menu = new WatchUi.Menu();
    menu.setTitle("Line");
    menu.addItem("Mark boat", :one);
    menu.addItem("Mark pin", :two);
    var delegate = new MenuDelegate(method(:menuCallback));
    WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    return true;
  }
  
  function menuCallback(item) {
  	if (item == :one) {
        controllers.line.setBoatPosition(controllers.vessel.getModel().position);
    } else if (item == :two) {
        controllers.line.setPinPosition(controllers.vessel.getModel().position);
    }
    WatchUi.requestUpdate();
  }
  
  function onPreviousPage() {
  	WatchUi.switchToView(new VesselDataView(controllers), new VesselDataViewDelegate(controllers), WatchUi.SLIDE_DOWN);
  	return true;
  }
 
  function onNextPage() {
  	WatchUi.switchToView(new StatusView(controllers), new StatusViewDelegate(controllers), WatchUi.SLIDE_UP);
  	return true;
  }
}

class MenuDelegate extends WatchUi.MenuInputDelegate {
	var callback;

    function initialize(callback_) {
    	callback = callback_;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    	callback.invoke(item);
    }
}
