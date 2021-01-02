module GpsMath {

	function calculate(x) {
		return 2*x;
	}

	(:test)
	function myUnitTest(logger) {
		var expected = 4;
		var actual = calculate(2);
		logger.debug("expected = " + expected + ", actual = " + actual);
		return expected == actual;
	}
}