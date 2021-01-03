using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

using Utilities as Utils;

class StatusView extends WatchUi.View {
  var controllers;
  
  var width;
  var center;
  var height;
  var blockHeight;

  function initialize(controllers_) {
    controllers = controllers_;
    View.initialize();
  }

  function onUpdate(dc) {
    View.onUpdate(dc);
    
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.clear();

    width = dc.getWidth();
    center = width / 2;
    height = dc.getHeight();
    blockHeight = height / 4;
    
    drawError(dc);
  }
  
  function drawError(dc) {
    // Grid
    dc.setPenWidth(2);
    dc.setColor(Colors.GRID, Graphics.COLOR_WHITE);
    dc.drawLine(0, blockHeight, width, blockHeight);
    dc.drawLine(0, blockHeight * 2, width, blockHeight * 2);
    dc.drawLine(0, blockHeight * 3, width, blockHeight * 3);

	// Vessel data connection
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.drawText(center, 0.4 * blockHeight, Graphics.FONT_XTINY, "Vessel data connection",
    		(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
    var status;
	if (controllers.vessel.error) {
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
		status = controllers.vessel.error;
	} else {
		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_WHITE);
		status = "OK";
	}
    dc.drawText(center, 0.7 * blockHeight, Graphics.FONT_XTINY, status,
                (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
                
                    
    // Vessel position
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.drawText(center, 1.3 * blockHeight, Graphics.FONT_XTINY, "Vessel position",
    		(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
	dc.drawText(center, 1.6 * blockHeight, Graphics.FONT_XTINY, controllers.vessel.getModel().getPosition(),
        (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
                
  }
}

class StatusViewDelegate extends WatchUi.BehaviorDelegate {
  var controllers;

  function initialize(controllers_) {
    controllers = controllers_;
    BehaviorDelegate.initialize();
  }

  function onPreviousPage() {
    WatchUi.switchToView(new LineSelectionView(controllers), new LineSelectionViewDelegate(controllers), WatchUi.SLIDE_DOWN);
    return true;
  }

  function onNextPage() {
    WatchUi.switchToView(new VesselDataView(controllers), new VesselDataViewDelegate(controllers), WatchUi.SLIDE_UP);
    return true;
  }
}