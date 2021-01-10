using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

using Utilities as Utils;

class StartTimerView extends WatchUi.View {
  var controllers;
  var timer;
  
  var width;
  var center;
  var height;
  var blockHeight;

  function initialize(controllers_) {
    controllers = controllers_;
    View.initialize();
  }
  
  function onShow() {
  	// TODO: consolidate UI updates
  	timer = new Timer.Timer();
    timer.start(method(:timerCallback), 500, true);
  }
  
  function onHide() {
  	timer.stop();
  }	
  
  function timerCallback() {
    WatchUi.requestUpdate();
  }
  
  function onUpdate(dc) {
    View.onUpdate(dc);
    dc.setColor(Colors.STD_FONT, Colors.BACKGROUND);
    dc.clear();

    width = dc.getWidth();
    center = width / 2;
    height = dc.getHeight();
    blockHeight = height / 3;
    
    drawTimer(dc);
  }
  
  function drawTimer(dc) {
    // Grid
    dc.setPenWidth(2);
    dc.setColor(Colors.GRID, Colors.BACKGROUND);
    dc.drawLine(0, blockHeight, width, blockHeight);
    dc.drawLine(0, blockHeight * 2, width, blockHeight * 2);
    dc.drawLine(0, blockHeight * 3, width, blockHeight * 3);

    // Timer
    var totalSecs = controllers.timer.getDuration().value();
    var mins = totalSecs / 60;
    var secs = totalSecs % 60;
    if (secs < 0 && mins != 0) {
    	secs = -secs;
    }
    dc.setColor(Colors.STD_FONT, Colors.BACKGROUND);
    var padding = "";
    if (secs < 10) {
    	padding = "0";
    }
    var display = Lang.format("$1$ : $2$$3$", [mins, padding, secs]);
    if (mins == 0) {
    	display = Lang.format("$1$$2$", [padding, secs]);
    }
    dc.drawText(center, 1.5 * blockHeight, Graphics.FONT_NUMBER_THAI_HOT, display,
    		(Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER));            
  }
}

class StartTimerViewDelegate extends WatchUi.BehaviorDelegate {
  var controllers;

  function initialize(controllers_) {
    controllers = controllers_;
    BehaviorDelegate.initialize();
  }
  
  function onSelect() {
  	controllers.timer.start();
  }
  
  function onMenu() {
  	var menu = new WatchUi.Menu();
    menu.setTitle("Timer");
    menu.addItem("Sync", :sync);
    menu.addItem("-1", :decrease);
    menu.addItem("+1", :increase);
    var delegate = new StartTimerMenuDelegate(method(:menuCallback));
    WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    return true;
  }
  
  function menuCallback(item) {
  	if (item == :sync) {
        controllers.timer.sync();
    } else if (item == :increase) {
        controllers.timer.increase();
    } else if (item == :decrease) {
        controllers.timer.decrease();
    }
  }

  function onPreviousPage() {
    WatchUi.switchToView(new VesselDataView(controllers), new VesselDataViewDelegate(controllers), WatchUi.SLIDE_DOWN);
    return true;
  }
  
  function onNextPage() {
    WatchUi.switchToView(new LineSelectionView(controllers), new LineSelectionViewDelegate(controllers), WatchUi.SLIDE_UP);
    return true;
  }
}

class StartTimerMenuDelegate extends WatchUi.MenuInputDelegate {
	var callback;

    function initialize(callback_) {
    	callback = callback_;
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
    	callback.invoke(item);
    }
}
