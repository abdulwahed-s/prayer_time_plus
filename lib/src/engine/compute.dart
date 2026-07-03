import 'dart:math' as math;

import '../math/degree_math.dart';
import '../math/sun_position.dart';

// Raw astronomical times, computed in the longitude-shifted frame as
// fractional hours. Order throughout the engine:
//   [0] Fajr, [1] Sunrise, [2] Dhuhr, [3] Asr, [4] Sunset,
//   [5] Maghrib (provisional), [6] Isha (provisional).

/// Methods whose sunrise/sunset depression includes the elevation term.
const Set<String> elevationMethods = {
  'iraq',
  'morocco',
  'tunisia',
  'jordan',
  'orleans',
  'sudan',
  'belgium',
  'kazakhstan',
};

/// Country codes whose sunrise/sunset depression includes the elevation
/// term regardless of method.
const Set<String> elevationCountries = {'PS', 'IL', 'CZ', 'CH'};

/// Fixed time-of-day guesses in hours, one per prayer.
///
/// There is no iteration: each prayer's sun position is evaluated once at
/// its seed, which fixes the instant of day the sun is sampled at.
const List<double> timeSeeds = [5, 6, 12, 13, 18, 18, 18];

/// Sunrise/sunset depression in degrees: 0.833° (atmospheric refraction +
/// solar semidiameter), plus the horizon dip `0.0347 * sqrt(altitude)` for
/// the elevation-aware methods/countries only.
double horizonDip({
  required double altitude,
  String? method,
  String? countryCode,
}) {
  final elevationAware =
      (method != null && elevationMethods.contains(method)) ||
      (countryCode != null &&
          elevationCountries.contains(countryCode.toUpperCase()));
  return elevationAware ? 0.833 + 0.0347 * math.sqrt(altitude) : 0.833;
}

/// Solar transit (Dhuhr) at day-fraction guess [t]: `12 - equationOfTime`.
double midDay(double baseJd, double t) =>
    fixHour(12 - sunPosition(baseJd + t).equationOfTime);

/// Time at which the sun reaches depression [angle] degrees below the
/// horizon, at day-fraction guess [t].
///
/// Morning callers request `180 - angle` (> 90°), which flips the hour
/// angle sign and yields a before-noon time. Returns NaN when the sun
/// never reaches the angle (high latitudes).
double sunAngleTime(double baseJd, double latitude, double angle, double t) {
  final declination = sunPosition(baseJd + t).declination;
  final noon = midDay(baseJd, t);
  final hourAngle =
      arccosDeg(
        (-sinDeg(angle) - sinDeg(declination) * sinDeg(latitude)) /
            (cosDeg(declination) * cosDeg(latitude)),
      ) /
      15.0;
  return noon + (angle > 90.0 ? -hourAngle : hourAngle);
}

/// Asr time for shadow [factor] (1 = standard, 2 = Hanafi) at day-fraction
/// guess [t].
///
/// The sun altitude at Asr is `arccot(factor + tan(|latitude - decl|))`,
/// passed negated to [sunAngleTime] so it resolves to an afternoon time.
double asrTime(double baseJd, double latitude, int factor, double t) {
  final declination = sunPosition(baseJd + t).declination;
  final altitude = arccotDeg(factor + tanDeg((latitude - declination).abs()));
  return sunAngleTime(baseJd, latitude, -altitude, t);
}

/// Computes the seven raw times (fractional hours, longitude-shifted
/// frame) in a single pass over [timeSeeds].
///
/// [maghribValue] and [ishaValue] are evaluated as depression angles here
/// even for interval-mode methods; the adjust step overwrites those slots,
/// so a provisional NaN (e.g. an interval value of 90 "degrees") is
/// harmless.
List<double> computeRawTimes({
  required double baseJd,
  required double latitude,
  required double dip,
  required double fajrAngle,
  required double maghribValue,
  required double ishaValue,
  required int asrFactor,
}) {
  final t = [for (final seed in timeSeeds) seed / 24.0];
  return [
    sunAngleTime(baseJd, latitude, 180 - fajrAngle, t[0]),
    sunAngleTime(baseJd, latitude, 180 - dip, t[1]),
    midDay(baseJd, t[2]),
    asrTime(baseJd, latitude, asrFactor, t[3]),
    sunAngleTime(baseJd, latitude, dip, t[4]),
    sunAngleTime(baseJd, latitude, maghribValue, t[5]),
    sunAngleTime(baseJd, latitude, ishaValue, t[6]),
  ];
}
