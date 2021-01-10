using Toybox.WatchUi;
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

    dc.setColor(Colors.STD_FONT, Colors.BACKGROUND);
    dc.clear();

    width = dc.getWidth();
    height = dc.getHeight();

    drawValues(dc);
  }

  function drawValues(dc) {
	// Caity, draw some points: starting boat, pin, boat
	dc.setColor(Colors.ERROR, Colors.BACKGROUND);
	dc.fillCircle(50, 100, 75);
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
    var delegate = new LineSelectionMenuDelegate(method(:menuCallback));
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
  	WatchUi.switchToView(new StartTimerView(controllers), new StartTimerViewDelegate(controllers), WatchUi.SLIDE_DOWN);
  	return true;
  }
 
  function onNextPage() {
  	WatchUi.switchToView(new StatusView(controllers), new StatusViewDelegate(controllers), WatchUi.SLIDE_UP);
  	return true;
  }
}

class LineSelectionMenuDelegate extends WatchUi.MenuInputDelegate {
	var callback;

    function initialize(callback_) {
    	callback = callback_;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    	callback.invoke(item);
    }
}
