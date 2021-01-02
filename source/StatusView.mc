using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

using Utilities as Utils;

class StatusView extends WatchUi.View {
  var controller;
  
  var width;
  var center;
  var height;
  var blockHeight;

  function initialize(controller_) {
    controller = controller_;
    View.initialize();
  }

  function onUpdate(dc) {
    View.onUpdate(dc);
    
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.clear();

    width = dc.getWidth();
    center = width / 2;
    height = dc.getHeight();
    blockHeight = height / 3;
    
    drawError(dc);
  }
  
  function drawError(dc) {
    // Grid
    dc.setPenWidth(2);
    dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_WHITE);
    dc.drawLine(0, blockHeight, width, blockHeight);
    dc.drawLine(0, blockHeight * 2, width, blockHeight * 2);

	// Vessel data connection
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.drawText(center, blockHeight + 0.3 * blockHeight, Graphics.FONT_XTINY, "Vessel data connection",
    		(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
    var status;
	if (controller.error) {
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
		status = controller.error;
	} else {
		dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_WHITE);
		status = "OK";
	}
    dc.drawText(center, blockHeight + 0.6 * blockHeight, Graphics.FONT_XTINY, status,
                (Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));
  }
}

class StatusViewDelegate extends WatchUi.BehaviorDelegate {
  var controller;

  function initialize(controller_) {
    controller = controller_;
    BehaviorDelegate.initialize();
  }

  function onNextPage() {
    WatchUi.switchToView(new VesselDataView(controller), new VesselDataViewDelegate(controller), WatchUi.SLIDE_UP);
    return true;
  }
}