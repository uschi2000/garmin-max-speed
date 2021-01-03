using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

using Utilities as Utils;

class VesselDataView extends WatchUi.View {
  var vesselController;

  var width;
  var height;
  var blockHeight;

  function initialize(controllers_) {
    vesselController = controllers_.vessel;
    View.initialize();
  }
  
  function onShow() {
  	vesselController.startUpdatingData();
  }

  function onHide() {
  	vesselController.stopUpdatingData();
  }

  function onUpdate(dc) {
    View.onUpdate(dc);
    dc.setColor(Colors.STD_FONT, Colors.BACKGROUND);
    dc.clear();

    width = dc.getWidth();
    height = dc.getHeight();
    blockHeight = height / 3;

    drawValues(dc);
  }

  function drawValues(dc) {
    // Grid
    dc.setPenWidth(2);
    dc.setColor(Colors.GRID, Colors.BACKGROUND);
    dc.drawLine(0, blockHeight, width, blockHeight);
    dc.drawLine(0, blockHeight * 2, width, blockHeight * 2);
    dc.drawLine(width / 2, blockHeight, width / 2, blockHeight * 2);

    // Arcs
    var arcLineWidth = 15;
    dc.setPenWidth(arcLineWidth);
    dc.setColor(Colors.STARBOARD, Colors.BACKGROUND);
    dc.drawArc(width / 2, height / 2, (width / 2), Graphics.ARC_CLOCKWISE, 90,
               45);
    dc.setColor(Colors.PORT, Colors.BACKGROUND);
    dc.drawArc(width / 2, height / 2, (width / 2),
               Graphics.ARC_COUNTER_CLOCKWISE, 90, 135);

    // Ship data
    dc.setColor(Colors.STD_FONT, Colors.BACKGROUND);
    var vessel = vesselController.model;
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
  var controllers;

  function initialize(controllers_) {
    controllers = controllers_;
    BehaviorDelegate.initialize();
  }
  
  function onPreviousPage() {
  	WatchUi.switchToView(new StatusView(controllers), new StatusViewDelegate(controllers), WatchUi.SLIDE_DOWN);
  	return true;
  }
 
  function onNextPage() {
  	WatchUi.switchToView(new LineSelectionView(controllers), new LineSelectionViewDelegate(controllers), WatchUi.SLIDE_UP);
  	return true;
  }
}
