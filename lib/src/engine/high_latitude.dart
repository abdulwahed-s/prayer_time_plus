import '../math/degree_math.dart';
import '../models/high_latitude_rule.dart';

/// Applies the high-latitude night-fraction fallback in place.
///
/// [times] is the adjusted 7-element array (fractional hours, local
/// clock). The night runs sunset → next sunrise. Fajr/Isha are replaced by
/// their night-fraction time when the natural value is undefined (NaN) or
/// lies further from its anchor (Sunrise for Fajr, Maghrib for Isha) than
/// the allowed portion. The per-prayer minute offsets are re-added because
/// the replacement is computed from scratch.
///
/// For interval-mode Isha the portion is derived from an 18° twilight
/// angle.
void adjustHighLatitudes(
  List<double> times, {
  required HighLatitudeRule rule,
  required double fajrAngle,
  required bool ishaIsInterval,
  required double ishaValue,
  required double fajrOffsetMinutes,
  required double ishaOffsetMinutes,
}) {
  final night = fixHour(times[1] - times[4]); // sunrise - sunset

  final fajrPortion = rule.nightPortion(fajrAngle) * night;
  if (times[0].isNaN || fixHour(times[1] - times[0]) > fajrPortion) {
    times[0] = times[1] - fajrPortion + fajrOffsetMinutes / 60.0;
  }

  final ishaAngle = ishaIsInterval ? 18.0 : ishaValue;
  final ishaPortion = rule.nightPortion(ishaAngle) * night;
  if (times[6].isNaN || fixHour(times[6] - times[5]) > ishaPortion) {
    times[6] = times[5] + ishaPortion + ishaOffsetMinutes / 60.0;
  }
}
