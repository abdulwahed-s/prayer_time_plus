/// Per-prayer minute offsets.
///
/// Positive values delay a prayer, negative values advance it. Used both for
/// the offsets baked into a calculation method and for user tuning:
///
/// ```dart
/// final params = CalculationMethod.muslimWorldLeague.getParameters()
///   ..adjustments.fajr = 2
///   ..adjustments.isha = -3;
/// ```
class PrayerAdjustments {
  /// Creates a set of per-prayer minute offsets (all default to 0).
  PrayerAdjustments({
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
  });

  /// Fajr offset in minutes.
  int fajr;

  /// Sunrise offset in minutes.
  int sunrise;

  /// Dhuhr offset in minutes.
  int dhuhr;

  /// Asr offset in minutes.
  int asr;

  /// Maghrib offset in minutes, applied relative to sunset.
  int maghrib;

  /// Isha offset in minutes.
  int isha;

  /// Returns a copy with the given fields replaced.
  PrayerAdjustments copyWith({
    int? fajr,
    int? sunrise,
    int? dhuhr,
    int? asr,
    int? maghrib,
    int? isha,
  }) => PrayerAdjustments(
    fajr: fajr ?? this.fajr,
    sunrise: sunrise ?? this.sunrise,
    dhuhr: dhuhr ?? this.dhuhr,
    asr: asr ?? this.asr,
    maghrib: maghrib ?? this.maghrib,
    isha: isha ?? this.isha,
  );

  @override
  String toString() =>
      'PrayerAdjustments(fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, '
      'asr: $asr, maghrib: $maghrib, isha: $isha)';
}
