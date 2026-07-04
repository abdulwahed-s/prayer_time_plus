import '../math/degree_math.dart';

/// Rounds [hours] to the nearest minute and returns it as minutes of day
/// in `[0, 1440)`, or `null` when the time is undefined (NaN).
///
/// The rounding is "add half a minute, then floor", using the engine's
/// exact literal `0.0083333333` hours. Values that cross 24:00 wrap to the
/// start of the same day.
int? roundToMinuteOfDay(double hours) {
  if (hours.isNaN) {
    return null;
  }
  final value = fixHour(hours + 0.0083333333);
  final wholeHours = value.floorToDouble();
  final minutes = ((value - wholeHours) * 60).floorToDouble();
  return (wholeHours * 60 + minutes).toInt();
}
