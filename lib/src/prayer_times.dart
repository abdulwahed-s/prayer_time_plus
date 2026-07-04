import 'engine/prayer_times_engine.dart';
import 'methods/calculation_parameters.dart';
import 'models/coordinates.dart';
import 'models/date_components.dart';
import 'models/prayer.dart';

/// The computed prayer times for a single day and location.
///
/// Each time is a [DateTime] whose calendar and clock fields (year, month,
/// day, hour, minute) are the **local wall-clock** time at [utcOffset] — so
/// `times.fajr!.hour` reads the local Fajr hour directly. The instances are
/// flagged UTC to stay independent of the host machine's timezone; do not
/// call [DateTime.toLocal] on them. For the true instant, subtract
/// [utcOffset].
///
/// A field is `null` when the sun never reaches the required angle and no
/// high-latitude rule supplies a fallback.
///
/// ```dart
/// final params = CalculationMethod.ummAlQura.getParameters();
/// final times = PrayerTimes(
///   Coordinates(21.4225, 39.8262),
///   DateComponents(2026, 6, 28),
///   params,
///   utcOffset: Duration(hours: 3),
/// );
/// print('${times.fajr!.hour}:${times.fajr!.minute}');
/// ```
class PrayerTimes {
  /// Computes the prayer times for [coordinates] on [dateComponents] using
  /// [calculationParameters].
  ///
  /// [utcOffset] is the location's offset from UTC (including any DST in
  /// effect on that date). When omitted it defaults to the host machine's
  /// offset for that date, which is only meaningful if the machine is in
  /// the target timezone — pass it explicitly for deterministic results.
  ///
  /// [countryCode] (ISO-3166 alpha-2) and [cityName] refine a few methods:
  /// the elevation-aware calculations, the Umm al-Qura Ramadan rule (which
  /// needs `SA`), and the per-city minute tweaks. Both may be omitted.
  factory PrayerTimes(
    Coordinates coordinates,
    DateComponents dateComponents,
    CalculationParameters calculationParameters, {
    Duration? utcOffset,
    String countryCode = '',
    String cityName = '',
  }) {
    final offset = utcOffset ?? _localOffset(dateComponents);
    final raw = runEngine(
      coordinates: coordinates,
      date: dateComponents,
      params: calculationParameters,
      utcOffsetHours: offset.inSeconds / 3600.0,
      countryCode: countryCode,
      cityName: cityName,
    );
    final midnight = DateTime.utc(
      dateComponents.year,
      dateComponents.month,
      dateComponents.day,
    );
    DateTime? at(int? minuteOfDay) =>
        minuteOfDay == null
            ? null
            : midnight.add(Duration(minutes: minuteOfDay));
    return PrayerTimes._(
      coordinates: coordinates,
      dateComponents: dateComponents,
      calculationParameters: calculationParameters,
      utcOffset: offset,
      fajr: at(raw[0]),
      sunrise: at(raw[1]),
      dhuhr: at(raw[2]),
      asr: at(raw[3]),
      sunset: at(raw[4]),
      maghrib: at(raw[5]),
      isha: at(raw[6]),
    );
  }

  /// Computes the prayer times for the current date.
  ///
  /// The date is taken from [DateTime.now]; see the default constructor for
  /// the [utcOffset], [countryCode], and [cityName] arguments.
  factory PrayerTimes.today(
    Coordinates coordinates,
    CalculationParameters calculationParameters, {
    Duration? utcOffset,
    String countryCode = '',
    String cityName = '',
  }) => PrayerTimes(
    coordinates,
    DateComponents.from(DateTime.now()),
    calculationParameters,
    utcOffset: utcOffset,
    countryCode: countryCode,
    cityName: cityName,
  );

  PrayerTimes._({
    required this.coordinates,
    required this.dateComponents,
    required this.calculationParameters,
    required this.utcOffset,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
  });

  /// The location the times were computed for.
  final Coordinates coordinates;

  /// The date the times were computed for.
  final DateComponents dateComponents;

  /// The parameters the times were computed with.
  final CalculationParameters calculationParameters;

  /// The UTC offset the local wall-clock fields are expressed in.
  final Duration utcOffset;

  /// Dawn prayer.
  final DateTime? fajr;

  /// Sunrise (Shuruq); end of the Fajr window.
  final DateTime? sunrise;

  /// Midday prayer.
  final DateTime? dhuhr;

  /// Afternoon prayer.
  final DateTime? asr;

  /// Sunset (Ghuroub); Maghrib is derived from it.
  final DateTime? sunset;

  /// Sunset prayer.
  final DateTime? maghrib;

  /// Night prayer.
  final DateTime? isha;

  /// The time for [prayer], or `null` for [Prayer.none] or an undefined
  /// time.
  DateTime? timeForPrayer(Prayer prayer) => switch (prayer) {
    Prayer.fajr => fajr,
    Prayer.sunrise => sunrise,
    Prayer.dhuhr => dhuhr,
    Prayer.asr => asr,
    Prayer.maghrib => maghrib,
    Prayer.isha => isha,
    Prayer.none => null,
  };

  /// The prayer currently in effect at [at] (defaults to now).
  ///
  /// Returns [Prayer.none] before Fajr. [at] is treated as an instant in
  /// time.
  Prayer currentPrayer([DateTime? at]) {
    final when = (at ?? DateTime.now()).toUtc();
    var current = Prayer.none;
    for (final entry in _schedule) {
      final instant = _instant(entry.value);
      if (instant != null && !when.isBefore(instant)) {
        current = entry.key;
      }
    }
    return current;
  }

  /// The next upcoming prayer after [at] (defaults to now).
  ///
  /// Returns [Prayer.none] once Isha has passed. [at] is treated as an
  /// instant in time.
  Prayer nextPrayer([DateTime? at]) {
    final when = (at ?? DateTime.now()).toUtc();
    for (final entry in _schedule) {
      final instant = _instant(entry.value);
      if (instant != null && when.isBefore(instant)) {
        return entry.key;
      }
    }
    return Prayer.none;
  }

  /// The six phase markers in chronological order (Sunset is excluded; it
  /// coincides with Maghrib as a marker).
  List<MapEntry<Prayer, DateTime?>> get _schedule => [
    MapEntry(Prayer.fajr, fajr),
    MapEntry(Prayer.sunrise, sunrise),
    MapEntry(Prayer.dhuhr, dhuhr),
    MapEntry(Prayer.asr, asr),
    MapEntry(Prayer.maghrib, maghrib),
    MapEntry(Prayer.isha, isha),
  ];

  /// Converts a stored local wall-clock time to its true UTC instant.
  DateTime? _instant(DateTime? wallClock) => wallClock?.subtract(utcOffset);

  static Duration _localOffset(DateComponents date) =>
      DateTime(date.year, date.month, date.day).timeZoneOffset;
}
