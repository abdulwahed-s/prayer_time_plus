import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  final sohar = Coordinates(24.3486, 56.6953, altitude: 5);
  const utcOffset = Duration(hours: 4);

  PrayerTimes day(int d) => PrayerTimes(
    sohar,
    DateComponents(2026, 6, d),
    CalculationMethod.muslimWorldLeague.getParameters(),
    utcOffset: utcOffset,
    countryCode: 'OM',
    cityName: 'sohar',
  );

  group('SunnahTimes', () {
    test('splits the night from Maghrib to the next Fajr', () {
      final today = day(28);
      final tomorrow = day(29);
      final sunnah = SunnahTimes(today);

      final maghrib = today.maghrib!;
      final nextFajr = tomorrow.fajr!;
      final nightMinutes = nextFajr.difference(maghrib).inMinutes;

      expect(
        sunnah.middleOfTheNight,
        maghrib.add(Duration(minutes: (nightMinutes / 2).round())),
      );
      expect(
        sunnah.lastThirdOfTheNight,
        maghrib.add(Duration(minutes: (nightMinutes * 2 / 3).round())),
      );
    });

    test('orders the markers within the night', () {
      final today = day(28);
      final tomorrow = day(29);
      final sunnah = SunnahTimes(today);

      expect(sunnah.middleOfTheNight!.isAfter(today.maghrib!), isTrue);
      expect(
        sunnah.lastThirdOfTheNight!.isAfter(sunnah.middleOfTheNight!),
        isTrue,
      );
      expect(sunnah.lastThirdOfTheNight!.isBefore(tomorrow.fajr!), isTrue);
    });
  });
}
