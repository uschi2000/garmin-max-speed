using Toybox.Time;

class StartTimerController {

    var timer;

    function initialize() {
    	reset();
    }
    
    function reset() {
    	timer = new StartTimer(new SystemClock());
    }
    
    function start() {
    	timer.start();
    }
    
    function sync() {
    	timer.sync();
    }
    
    function increase() {
    	if (timer.getDuration().value() < 0) {
    		timer.backward();
    	} else {
    		timer.forward();
    	}
    }
    
    function decrease() {
    	if (timer.getDuration().value() < 0) {
    		timer.forward();
    	} else {
    		backward();
    	}
    }
    
    function getDuration() {
    	return timer.getDuration();
    }
}