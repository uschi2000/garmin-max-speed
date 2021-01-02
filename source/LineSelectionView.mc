using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

using Utilities as Utils;

class LineSelectionView extends WatchUi.View {

  var width;
  var height;

  function initialize(controller) {
    View.initialize();
  }

  function onUpdate(dc) {
    View.onUpdate(dc);

    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.clear();

    width = dc.getWidth();
    height = dc.getHeight();

    drawValues(dc);
  }

  function drawValues(dc) {
	// Caity, draw some points: starting boat, pin, boat
	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
	dc.fillCircle(50, 100, 75);
  }
}

class LineSelectionViewDelegate extends WatchUi.BehaviorDelegate {
  var controllers;
  var currentX;
  var currentY;

  function initialize(controllers_) {
    controllers = controllers_;
    BehaviorDelegate.initialize();
    Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
  }
  
  function onPosition(info) {
    var loc = info.position.toDegrees();
    currentX = loc[0];
    currentY = loc[1];
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
        controllers.line.setBoatPosition(currentX, currentY);
    } else if (item == :two) {
        controllers.line.setPinPosition(currentX, currentY);
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
