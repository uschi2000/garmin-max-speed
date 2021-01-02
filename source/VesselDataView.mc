using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

using Utilities as Utils;

class VesselDataView extends WatchUi.View {
  var vessel;

  var width;
  var height;
  var blockHeight;

  function initialize(controller) {
    vessel = controller.model;
    View.initialize();
  }

  function onUpdate(dc) {
    View.onUpdate(dc);

    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    dc.clear();

    width = dc.getWidth();
    height = dc.getHeight();
    blockHeight = height / 3;

    drawValues(dc);
  }

  function drawValues(dc) {
    // Grid
    dc.setPenWidth(2);
    dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_WHITE);
    dc.drawLine(0, blockHeight, width, blockHeight);
    dc.drawLine(0, blockHeight * 2, width, blockHeight * 2);
    dc.drawLine(width / 2, blockHeight, width / 2, blockHeight * 2);

    // Arcs
    var arcLineWidth = 15;
    dc.setPenWidth(arcLineWidth);
    dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_WHITE);
    dc.drawArc(width / 2, height / 2, (width / 2), Graphics.ARC_CLOCKWISE, 90,
               45);
    dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_WHITE);
    dc.drawArc(width / 2, height / 2, (width / 2),
               Graphics.ARC_COUNTER_CLOCKWISE, 90, 135);

    // Ship data
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
    drawDataText(dc, width / 2, 10, "SOG",
                 vessel.getSpeedOverGround());
    drawDataText(dc, width / 2, height - blockHeight, "DBT",
                 vessel.getDepthBelowKeel());
    drawDataText(dc, (width / 4), blockHeight + 5, "AWA",
                 vessel.getWindAngleApparent());
    drawDataText(dc, (width * 0.75), blockHeight + 5, "AWS",
                 vessel.getWindSpeedApparent());
    Utils.drawWindAngle(dc, vessel.windAngleApparent, width);
 }

  function drawDataText(dc, x, y, labelText, valueText) {
    dc.drawText(x, y + 4, Graphics.FONT_SYSTEM_XTINY, labelText,
                Graphics.TEXT_JUSTIFY_CENTER);

    dc.drawText(x, y + 26, Graphics.FONT_SYSTEM_LARGE, valueText,
                Graphics.TEXT_JUSTIFY_CENTER);
  }
}

class VesselDataViewDelegate extends WatchUi.BehaviorDelegate {
  var controller;

  function initialize(controller_) {
    controller = controller_;
    BehaviorDelegate.initialize();
  }

  function onSelect() {
    WatchUi.pushView(new AutopilotView(controller), new AutopilotDelegate(controller),
                     WatchUi.SLIDE_RIGHT);
    return true;
  }
  
  function onNextPage() {
  	WatchUi.switchToView(new StatusView(controller), new StatusViewDelegate(controller), WatchUi.SLIDE_UP);
  	return true;
  }
}
