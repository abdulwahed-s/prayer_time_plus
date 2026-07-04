// The adjustTimes pipeline: localisation, per-prayer offsets, Maghrib/Isha
// reconciliation, and the Umm al-Qura Ramadan rule. High-latitude and
// rounding run afterwards, in the caller.

/// Adjusts the raw [times] in place (fractional hours).
///
/// [times] is the 7-element array in engine order. [offsetMinutes] is the
/// effective per-prayer offset (method offsets already combined with user
/// tuning) in order [Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha].
///
/// Maghrib is always rebuilt from Sunset. Isha keeps its angle-based value
/// unless [ishaIsInterval] is set, in which case it becomes Maghrib plus
/// [ishaValue] minutes; either way the Isha offset is added last. When
/// [applyRamadanIshaBump] is true, Isha is pushed 30 minutes later.
void adjustTimes(
  List<double> times, {
  required double utcOffsetHours,
  required double longitude,
  required List<double> offsetMinutes,
  required bool maghribIsInterval,
  required double maghribValue,
  required bool ishaIsInterval,
  required double ishaValue,
  required bool applyRamadanIshaBump,
}) {
  // (a) Convert the longitude-shifted frame to the local clock.
  final localShift = utcOffsetHours - longitude / 15.0;
  for (var i = 0; i < times.length; i++) {
    times[i] += localShift;
  }

  // (d) Per-prayer offsets for Fajr, Sunrise, Dhuhr, Asr (minutes -> hours).
  times[0] += offsetMinutes[0] / 60.0;
  times[1] += offsetMinutes[1] / 60.0;
  times[2] += offsetMinutes[2] / 60.0;
  times[3] += offsetMinutes[3] / 60.0;

  // (e) Maghrib is always sunset plus its offset (plus the interval).
  times[5] = times[4] + offsetMinutes[4] / 60.0;
  if (maghribIsInterval) {
    times[5] += maghribValue / 60.0;
  }

  // (f) Isha: interval from Maghrib, or the angle-based value, then offset.
  if (ishaIsInterval) {
    times[6] = times[5] + ishaValue / 60.0;
  }
  times[6] += offsetMinutes[5] / 60.0;

  // (g) Umm al-Qura Ramadan: Isha +30 minutes.
  if (applyRamadanIshaBump) {
    times[6] += 0.5;
  }
}
