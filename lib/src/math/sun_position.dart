import 'degree_math.dart';

/// Sun declination and equation of time at a given Julian day instant.
class SunPosition {
  /// Creates a sun position value.
  const SunPosition(this.declination, this.equationOfTime);

  /// Sun declination in degrees (may be negative).
  final double declination;

  /// Equation of time in hours (small, roughly within +/-0.25 h).
  final double equationOfTime;
}

/// Computes the sun position for [jd] using the USNO low-precision model.
///
/// [jd] must already include the longitude-shifted base date plus the
/// time-of-day day fraction.
SunPosition sunPosition(double jd) {
  final d = jd - 2451545.0; // days since J2000.0
  final g = fixAngle(0.98560028 * d + 357.529); // mean anomaly, degrees
  final q = fixAngle(0.98564736 * d + 280.459); // mean longitude, degrees
  // Ecliptic longitude, degrees.
  final l = fixAngle(q + 1.915 * sinDeg(g) + 0.020 * sinDeg(2 * g));
  final e = 23.439 - 0.00000036 * d; // obliquity of ecliptic, degrees
  final declination = arcsinDeg(sinDeg(e) * sinDeg(l));
  final raHours = arctan2Deg(cosDeg(e) * sinDeg(l), cosDeg(l)) / 15.0;
  final equationOfTime = q / 15.0 - fixHour(raHours);
  return SunPosition(declination, equationOfTime);
}
