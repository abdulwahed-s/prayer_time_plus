/// Fallback rule for latitudes where the sun may not reach the Fajr/Isha
/// depression angle (roughly beyond 48°).
///
/// When the natural angle-based time is undefined, or further from
/// sunrise/Maghrib than the allowed fraction of the night, Fajr and Isha are
/// recomputed from that night fraction instead.
enum HighLatitudeRule {
  /// Try unadjusted angle-based times first, then retry with
  /// [seventhOfTheNight] if Fajr or Isha come out degenerate.
  automatic,

  /// No adjustment: undefined times are reported as `null`.
  none,

  /// Fajr/Isha never further than half the night from their anchor.
  middleOfTheNight,

  /// Fajr/Isha never further than one seventh of the night from their
  /// anchor.
  seventhOfTheNight,

  /// Night fraction proportional to the prayer's twilight angle
  /// (`angle / 60`).
  twilightAngle;

  /// Fraction of the night allowed for a prayer with twilight [angle]
  /// degrees.
  ///
  /// [automatic] reports the fraction used by its retry fallback; the
  /// calculation engine still handles it with an initial unadjusted pass.
  double nightPortion(double angle) => switch (this) {
    automatic => seventhOfTheNight.nightPortion(angle),
    none => 0.0,
    middleOfTheNight => 0.5,
    // The literal 0.14286 (not 1/7) is required for parity with the
    // reference algorithm.
    seventhOfTheNight => 0.14286,
    twilightAngle => angle / 60.0,
  };
}
