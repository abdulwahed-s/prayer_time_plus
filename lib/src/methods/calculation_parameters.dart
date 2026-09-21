import '../models/high_latitude_rule.dart';
import '../models/madhab.dart';
import '../models/prayer_adjustments.dart';

/// The full set of knobs that drive a prayer-times calculation.
///
/// Usually obtained from a [CalculationMethod] preset and then customised
/// with cascades:
///
/// ```dart
/// final params = CalculationMethod.oman.getParameters()
///   ..madhab = Madhab.hanafi
///   ..highLatitudeRule = HighLatitudeRule.seventhOfTheNight
///   ..adjustments.fajr = 2;
/// ```
///
/// A fully custom configuration can also be built directly:
///
/// ```dart
/// final params = CalculationParameters(fajrAngle: 18, ishaValue: 17);
/// ```
class CalculationParameters {
  /// Creates a set of calculation parameters.
  ///
  /// [ishaValue] is a depression angle in degrees by default; set
  /// [ishaIsInterval] to treat it as minutes after Maghrib. Likewise
  /// [maghribValue] is minutes after sunset when [maghribIsInterval] is true.
  /// When false, a positive value is Maghrib's evening solar-depression angle;
  /// zero or a negative value keeps Maghrib at sunset.
  CalculationParameters({
    required this.fajrAngle,
    required this.ishaValue,
    this.method,
    this.maghribIsInterval = false,
    this.maghribValue = 0,
    this.ishaIsInterval = false,
    PrayerAdjustments? methodAdjustments,
    PrayerAdjustments? adjustments,
    this.madhab = Madhab.shafi,
    this.highLatitudeRule = HighLatitudeRule.automatic,
    this.isRamadan = false,
  }) : methodAdjustments = methodAdjustments ?? PrayerAdjustments(),
       adjustments = adjustments ?? PrayerAdjustments();

  /// The preset key this configuration came from (e.g. `oman`), or `null`
  /// for a hand-built configuration.
  ///
  /// A few behaviours are keyed on it: the elevation-aware methods, the
  /// Umm al-Qura Ramadan rule, and the per-city minute tweaks.
  final String? method;

  /// Fajr depression angle in degrees below the horizon.
  double fajrAngle;

  /// Whether [maghribValue] is an interval in minutes after sunset.
  ///
  /// When false, a positive [maghribValue] selects angle mode and a
  /// non-positive value selects sunset mode.
  bool maghribIsInterval;

  /// Minutes after sunset in interval mode, or the evening solar-depression
  /// angle in degrees in non-interval mode. A non-positive angle means sunset.
  double maghribValue;

  /// Whether [ishaValue] is an interval in minutes after Maghrib.
  bool ishaIsInterval;

  /// Isha depression angle in degrees, or minutes after Maghrib when
  /// [ishaIsInterval] is true.
  double ishaValue;

  /// Per-prayer minute offsets baked into the calculation method.
  PrayerAdjustments methodAdjustments;

  /// Per-prayer minute offsets for user tuning, applied on top of
  /// [methodAdjustments].
  PrayerAdjustments adjustments;

  /// Juristic school for the Asr shadow factor.
  Madhab madhab;

  /// High-latitude fallback rule.
  ///
  /// [HighLatitudeRule.automatic] means no adjustment is applied first, but
  /// if Fajr or Isha degenerate (undefined, or landing on a midnight/noon
  /// artefact) the whole day is recomputed with
  /// [HighLatitudeRule.seventhOfTheNight]. Use [HighLatitudeRule.none] to
  /// never apply a fallback.
  HighLatitudeRule highLatitudeRule;

  /// Whether the date being computed falls in Ramadan.
  ///
  /// Only consulted by the Umm al-Qura method (`makkah`) for locations in
  /// Saudi Arabia, where it extends Isha by 30 minutes (90 → 120 minutes
  /// after Maghrib).
  bool isRamadan;

  /// Returns a copy with the given fields replaced.
  ///
  /// The adjustment objects are deep-copied, so mutating the copy never
  /// affects the original.
  CalculationParameters copyWith({
    String? method,
    double? fajrAngle,
    bool? maghribIsInterval,
    double? maghribValue,
    bool? ishaIsInterval,
    double? ishaValue,
    PrayerAdjustments? methodAdjustments,
    PrayerAdjustments? adjustments,
    Madhab? madhab,
    HighLatitudeRule? highLatitudeRule,
    bool? isRamadan,
  }) => CalculationParameters(
    method: method ?? this.method,
    fajrAngle: fajrAngle ?? this.fajrAngle,
    maghribIsInterval: maghribIsInterval ?? this.maghribIsInterval,
    maghribValue: maghribValue ?? this.maghribValue,
    ishaIsInterval: ishaIsInterval ?? this.ishaIsInterval,
    ishaValue: ishaValue ?? this.ishaValue,
    methodAdjustments: methodAdjustments ?? this.methodAdjustments.copyWith(),
    adjustments: adjustments ?? this.adjustments.copyWith(),
    madhab: madhab ?? this.madhab,
    highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
    isRamadan: isRamadan ?? this.isRamadan,
  );

  /// Returns a copy with [methodAdjustments] replaced by [adjustments].
  CalculationParameters withMethodAdjustments(PrayerAdjustments adjustments) =>
      copyWith(methodAdjustments: adjustments);

  @override
  String toString() =>
      'CalculationParameters(method: $method, fajrAngle: $fajrAngle, '
      'maghrib: ${maghribIsInterval
          ? 'sunset +$maghribValue min'
          : maghribValue > 0
          ? '$maghribValue deg'
          : 'sunset'}, '
      'isha: ${ishaIsInterval ? 'maghrib +$ishaValue min' : '$ishaValue deg'}, '
      'madhab: $madhab)';
}
