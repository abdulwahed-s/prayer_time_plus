import 'dart:math' as math;

// Degree-based trigonometry. All prayer-time math works in degrees (and
// hours for the wrap helpers); dart:math is radian-based, so every helper
// converts explicitly.

/// Converts [degrees] to radians.
double degreesToRadians(double degrees) => degrees * math.pi / 180.0;

/// Converts [radians] to degrees.
double radiansToDegrees(double radians) => radians * 180.0 / math.pi;

/// Sine of an angle given in degrees.
double sinDeg(double degrees) => math.sin(degreesToRadians(degrees));

/// Cosine of an angle given in degrees.
double cosDeg(double degrees) => math.cos(degreesToRadians(degrees));

/// Tangent of an angle given in degrees.
double tanDeg(double degrees) => math.tan(degreesToRadians(degrees));

/// Arcsine in degrees.
double arcsinDeg(double x) => radiansToDegrees(math.asin(x));

/// Arccosine in degrees.
double arccosDeg(double x) => radiansToDegrees(math.acos(x));

/// Arccotangent in degrees, computed as `atan2(1, x)`.
///
/// Not `1/tan(x)`: the two differ in sign/branch for negative arguments,
/// and the `atan2` form is what the Asr shadow formula requires.
double arccotDeg(double x) => radiansToDegrees(math.atan2(1, x));

/// Two-argument arctangent in degrees.
double arctan2Deg(double y, double x) => radiansToDegrees(math.atan2(y, x));

/// Wraps an angle in degrees to the range `[0, 360)`.
double fixAngle(double angle) {
  // floorToDouble floors toward negative infinity and passes NaN through,
  // so negative angles wrap correctly and undefined times stay undefined.
  final wrapped = angle - 360.0 * (angle / 360.0).floorToDouble();
  return wrapped < 0 ? wrapped + 360.0 : wrapped;
}

/// Wraps an hour value to the range `[0, 24)`.
double fixHour(double hour) {
  final wrapped = hour - 24.0 * (hour / 24.0).floorToDouble();
  return wrapped < 0 ? wrapped + 24.0 : wrapped;
}

/// Wrapped time difference in hours from [from] to [to], in `[0, 24)`.
double timeDiff(double from, double to) => fixHour(to - from);
