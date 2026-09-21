// The adjustTimes pipeline: localisation, per-prayer offsets, Maghrib/Isha
// reconciliation, and the Umm al-Qura Ramadan rule. High-latitude and
// rounding run afterwards, in the caller.

/// Adjusts the raw [times] in place (fractional hours).
///
/// [times] is the 7-element array in engine order. [offsetMinutes] is the
/// effective per-prayer offset (method offsets already combined with user
/// tuning) in order [Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha].
///
/// Interval Maghrib is rebuilt from Sunset. A positive non-interval
/// [maghribValue] keeps the provisional angle-based time when it is finite,
/// after Sunset, and before an available angle-based Isha; otherwise Maghrib
/// falls back to Sunset. The Maghrib offset is applied to either base exactly
/// once.
///
/// Isha keeps its angle-based value unless [ishaIsInterval] is set, in which
/// case it becomes the final Maghrib plus [ishaValue] minutes; either way the
/// Isha offset is added last. When [applyRamadanIshaBump] is true, Isha is
/// pushed 30 minutes later.
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

  // (e) Resolve the final Maghrib base, then apply its offset exactly once.
  final maghribOffset = offsetMinutes[4] / 60.0;
  final sunsetBasedMaghrib = times[4] + maghribOffset;
  final angleBasedIsha = times[6] + offsetMinutes[5] / 60.0;
  if (maghribIsInterval) {
    times[5] = sunsetBasedMaghrib + maghribValue / 60.0;
  } else if (maghribValue > 0) {
    final candidate = times[5] + maghribOffset;
    final isChronological =
        candidate.isFinite &&
        candidate > times[4] &&
        (ishaIsInterval ||
            !angleBasedIsha.isFinite ||
            candidate < angleBasedIsha);
    times[5] = isChronological ? candidate : sunsetBasedMaghrib;
  } else {
    times[5] = sunsetBasedMaghrib;
  }

  // (f) Interval Isha is based on the final Maghrib. Angle Isha already has
  // its own offset folded in above for chronological validation.
  times[6] =
      ishaIsInterval
          ? times[5] + ishaValue / 60.0 + offsetMinutes[5] / 60.0
          : angleBasedIsha;

  // (g) Umm al-Qura Ramadan: Isha +30 minutes.
  if (applyRamadanIshaBump) {
    times[6] += 0.5;
  }
}
