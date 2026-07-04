// ignore_for_file: avoid_print

import 'package:prayer_time_plus/prayer_time_plus.dart';

void main() {
  // Sohar, Oman on 2026-06-28, at UTC+4.
  final coordinates = Coordinates(24.3486, 56.6953, altitude: 5);
  const date = DateComponents(2026, 6, 28);

  // Start from a preset, then customise as needed.
  final params =
      CalculationMethod.oman.getParameters()
        ..madhab = Madhab.hanafi
        ..highLatitudeRule = HighLatitudeRule.seventhOfTheNight
        ..adjustments.fajr = 2;

  final times = PrayerTimes(
    coordinates,
    date,
    params,
    utcOffset: const Duration(hours: 4),
    countryCode: 'OM',
    cityName: 'sohar',
  );

  String hhmm(DateTime? t) =>
      t == null
          ? '--:--'
          : '${t.hour.toString().padLeft(2, '0')}:'
              '${t.minute.toString().padLeft(2, '0')}';

  print('Fajr    ${hhmm(times.fajr)}');
  print('Sunrise ${hhmm(times.sunrise)}');
  print('Dhuhr   ${hhmm(times.dhuhr)}');
  print('Asr     ${hhmm(times.asr)}');
  print('Maghrib ${hhmm(times.maghrib)}');
  print('Isha    ${hhmm(times.isha)}');

  // Auto-resolve a method from a country code.
  final autoMethod = AutoMethod.forCountry('OM');
  print('Auto method for OM: ${autoMethod.key}');

  // Sunnah times for the night, and the Qibla direction.
  final sunnah = SunnahTimes(times);
  print('Last third of the night: ${hhmm(sunnah.lastThirdOfTheNight)}');
  print('Qibla: ${Qibla(coordinates).direction.toStringAsFixed(1)}°');

  // Current and next prayer relative to a given instant (1 pm local here,
  // expressed as its UTC instant).
  final atOnePm = DateTime.utc(2026, 6, 28, 13, 0).subtract(times.utcOffset);
  print(
    'At 13:00 — current: ${times.currentPrayer(atOnePm).name}, '
    'next: ${times.nextPrayer(atOnePm).name}',
  );
}
