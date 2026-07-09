import '../math/julian_day.dart';
import '../methods/calculation_parameters.dart';
import '../models/coordinates.dart';
import '../models/date_components.dart';
import '../models/high_latitude_rule.dart';
import 'adjust.dart';
import 'city_tweaks.dart';
import 'compute.dart';
import 'high_latitude.dart';
import 'rounding.dart';

/// The seven computed times as minutes of day, in engine order
/// [Fajr, Sunrise, Dhuhr, Asr, Sunset, Maghrib, Isha].
///
/// Any element is `null` when the time is undefined (the sun never reaches
/// the required angle and no high-latitude rule filled it in).
typedef RawMinuteTimes = List<int?>;

/// Runs the full pipeline for one day and returns minutes-of-day times.
///
/// [countryCode] and [cityName] drive the elevation term, the Ramadan
/// rule, and the per-city tweaks; both may be empty. When
/// [CalculationParameters.highLatitudeRule] is
/// [HighLatitudeRule.automatic], the day is computed with no high-latitude
/// adjustment and recomputed once with [HighLatitudeRule.seventhOfTheNight]
/// if Fajr or Isha come out degenerate.
RawMinuteTimes runEngine({
  required Coordinates coordinates,
  required DateComponents date,
  required CalculationParameters params,
  required double utcOffsetHours,
  String countryCode = '',
  String cityName = '',
}) {
  final baseJd =
      julianDay(date.year, date.month, date.day) -
      coordinates.longitude / 360.0;

  final rule = params.highLatitudeRule;
  if (rule != HighLatitudeRule.automatic) {
    return _computePass(
      baseJd: baseJd,
      coordinates: coordinates,
      params: params,
      utcOffsetHours: utcOffsetHours,
      countryCode: countryCode,
      cityName: cityName,
      rule: rule,
    );
  }

  final firstPass = _computePass(
    baseJd: baseJd,
    coordinates: coordinates,
    params: params,
    utcOffsetHours: utcOffsetHours,
    countryCode: countryCode,
    cityName: cityName,
    rule: HighLatitudeRule.none,
  );

  if (!_looksBroken(firstPass)) {
    return firstPass;
  }
  return _computePass(
    baseJd: baseJd,
    coordinates: coordinates,
    params: params,
    utcOffsetHours: utcOffsetHours,
    countryCode: countryCode,
    cityName: cityName,
    rule: HighLatitudeRule.seventhOfTheNight,
  );
}

RawMinuteTimes _computePass({
  required double baseJd,
  required Coordinates coordinates,
  required CalculationParameters params,
  required double utcOffsetHours,
  required String countryCode,
  required String cityName,
  required HighLatitudeRule rule,
}) {
  final dip = horizonDip(
    altitude: coordinates.altitude,
    method: params.method,
    countryCode: countryCode,
  );

  final times = computeRawTimes(
    baseJd: baseJd,
    latitude: coordinates.latitude,
    dip: dip,
    fajrAngle: params.fajrAngle,
    maghribValue: params.maghribValue,
    ishaValue: params.ishaValue,
    asrFactor: params.madhab.shadowFactor,
  );

  // Fold user tuning into the method offsets, in engine offset order
  // [Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha].
  final method = params.methodAdjustments;
  final user = params.adjustments;
  final offsets = <double>[
    (method.fajr + user.fajr).toDouble(),
    (method.sunrise + user.sunrise).toDouble(),
    (method.dhuhr + user.dhuhr).toDouble(),
    (method.asr + user.asr).toDouble(),
    (method.maghrib + user.maghrib).toDouble(),
    (method.isha + user.isha).toDouble(),
  ];

  final applyRamadan =
      params.method == 'makkah' &&
      countryCode.toUpperCase() == 'SA' &&
      params.isRamadan;

  adjustTimes(
    times,
    utcOffsetHours: utcOffsetHours,
    longitude: coordinates.longitude,
    offsetMinutes: offsets,
    maghribIsInterval: params.maghribIsInterval,
    maghribValue: params.maghribValue,
    ishaIsInterval: params.ishaIsInterval,
    ishaValue: params.ishaValue,
    applyRamadanIshaBump: applyRamadan,
  );

  if (params.method != null) {
    applyCityTweaks(times, method: params.method!, city: cityName);
  }

  if (rule != HighLatitudeRule.none) {
    adjustHighLatitudes(
      times,
      rule: rule,
      fajrAngle: params.fajrAngle,
      ishaIsInterval: params.ishaIsInterval,
      ishaValue: params.ishaValue,
      fajrOffsetMinutes: offsets[0],
      ishaOffsetMinutes: offsets[5],
    );
  }

  return [for (final time in times) roundToMinuteOfDay(time)];
}

/// Matches the reference engine's "result looks broken" heuristic that
/// triggers the automatic high-latitude retry: a missing/midnight Fajr, or
/// an Isha that is missing or lands in the 00:xx or 12:xx hour.
bool _looksBroken(RawMinuteTimes times) {
  final fajr = times[0];
  final isha = times[6];
  if (fajr == null || fajr == 0) {
    return true;
  }
  if (isha == null) {
    return true;
  }
  final ishaHour = isha ~/ 60;
  return ishaHour == 0 || ishaHour == 12;
}
