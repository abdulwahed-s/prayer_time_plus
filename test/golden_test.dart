import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

/// Formats a computed time as local `"HH:mm"` (fields are local wall clock).
String hhmm(DateTime? time) =>
    time == null
        ? '--:--'
        : '${time.hour.toString().padLeft(2, '0')}:'
            '${time.minute.toString().padLeft(2, '0')}';

void main() {
  // Verified golden vectors for Sohar, Oman:
  // lat 24.3486, lng 56.6953, altitude 5 m, utcOffset +4, 2026-06-28,
  // madhab Shafi (Standard).
  group('Sohar golden vectors', () {
    final sohar = Coordinates(24.3486, 56.6953, altitude: 5);
    const date = DateComponents(2026, 6, 28);
    const utcOffset = Duration(hours: 4);

    test('muslimWorldLeague matches to the minute', () {
      final times = PrayerTimes(
        sohar,
        date,
        CalculationMethod.muslimWorldLeague.getParameters(),
        utcOffset: utcOffset,
        countryCode: 'OM',
        cityName: 'sohar',
      );
      expect(hhmm(times.fajr), '03:59');
      expect(hhmm(times.sunrise), '05:27');
      expect(hhmm(times.dhuhr), '12:16');
      expect(hhmm(times.asr), '15:37');
      expect(hhmm(times.sunset), '19:05');
      expect(hhmm(times.maghrib), '19:05');
      expect(hhmm(times.isha), '20:28');
    });

    test('oman matches to the minute', () {
      final times = PrayerTimes(
        sohar,
        date,
        CalculationMethod.oman.getParameters(),
        utcOffset: utcOffset,
        countryCode: 'OM',
        cityName: 'sohar',
      );
      expect(hhmm(times.fajr), '03:59');
      expect(hhmm(times.sunrise), '05:27');
      expect(hhmm(times.dhuhr), '12:21');
      expect(hhmm(times.asr), '15:42');
      expect(hhmm(times.maghrib), '19:10');
      expect(hhmm(times.isha), '20:35');
    });
  });

  // Mecca, Umm al-Qura: lat 21.42667, lng 39.82611, utcOffset +3,
  // 2026-06-28. Dhuhr/Maghrib/Isha are the verified points in the chain.
  group('Mecca Umm al-Qura', () {
    final mecca = Coordinates(21.42667, 39.82611);
    const date = DateComponents(2026, 6, 28);

    test('interval Isha is Maghrib + 90 min outside Ramadan', () {
      final times = PrayerTimes(
        mecca,
        date,
        CalculationMethod.ummAlQura.getParameters(),
        utcOffset: const Duration(hours: 3),
        countryCode: 'SA',
        cityName: 'mecca',
      );
      expect(hhmm(times.dhuhr), '12:24');
      expect(hhmm(times.maghrib), '19:07');
      expect(hhmm(times.isha), '20:37');
    });

    test('Ramadan pushes Isha to Maghrib + 120 min in Saudi Arabia', () {
      final params =
          CalculationMethod.ummAlQura.getParameters()..isRamadan = true;
      final times = PrayerTimes(
        mecca,
        date,
        params,
        utcOffset: const Duration(hours: 3),
        countryCode: 'SA',
        cityName: 'mecca',
      );
      // 19:07 + 120 min = 21:07 (30 minutes later than the non-Ramadan Isha).
      expect(hhmm(times.maghrib), '19:07');
      expect(hhmm(times.isha), '21:07');
    });

    test('Ramadan bump does not apply outside Saudi Arabia', () {
      final params =
          CalculationMethod.ummAlQura.getParameters()..isRamadan = true;
      final times = PrayerTimes(
        mecca,
        date,
        params,
        utcOffset: const Duration(hours: 3),
        countryCode: 'AE',
        cityName: 'mecca',
      );
      expect(hhmm(times.isha), '20:37');
    });
  });
}
