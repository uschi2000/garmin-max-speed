using Toybox.Math;
using Toybox.Graphics;
  
module Conversions {
  const FACTOR_MS_TO_KNOTS = 1.943844d;

  function meterPerSecondToKnots(metersPerSecond) {
    var knots = metersPerSecond * FACTOR_MS_TO_KNOTS;
    return knots;
  }

  function degreestToRadians(degrees) {
    var radians = degrees * Math.PI / 180.0d;
    return radians;
  }

  function metersToNauticalMiles(meters) {
    var nm = meters * 0.00053995680d;
    return nm;
  }

  function radiansToDegrees(radians) {
    var degrees = radians * 180.0d / Math.PI;
    return degrees;
  }

  function kelvinToCelsius(kelvin) {
    var celsius = kelvin - 273.15d;
    return celsius;
  }
}
