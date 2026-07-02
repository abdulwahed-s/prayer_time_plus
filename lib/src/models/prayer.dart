/// The six daily prayer/time markers exposed by [PrayerTimes], plus [none].
///
/// [sunrise] is not a prayer but marks the end of the Fajr window.
enum Prayer {
  /// The dawn prayer.
  fajr,

  /// Sunrise (Shuruq) — the end of the Fajr window.
  sunrise,

  /// The midday prayer.
  dhuhr,

  /// The afternoon prayer.
  asr,

  /// The sunset prayer.
  maghrib,

  /// The night prayer.
  isha,

  /// No prayer (e.g. before Fajr when asking for the current prayer).
  none,
}
