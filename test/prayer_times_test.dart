import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  final sohar = Coordinates(24.3486, 56.6953, altitude: 5);
  const date = DateComponents(2026, 6, 28);
  const utcOffset = Duration(hours: 4);

  PrayerTimes build() => PrayerTimes(
    sohar,
    date,
    CalculationMethod.muslimWorldLeague.getParameters(),
    utcOffset: utcOffset,
    countryCode: 'OM',
    cityName: 'sohar',
  );

  group('timeForPrayer', () {
    test('maps each prayer to its field', () {
      final times = build();
      expect(times.timeForPrayer(Prayer.fajr), times.fajr);
      expect(times.timeForPrayer(Prayer.sunrise), times.sunrise);
      expect(times.timeForPrayer(Prayer.dhuhr), times.dhuhr);
      expect(times.timeForPrayer(Prayer.asr), times.asr);
      expect(times.timeForPrayer(Prayer.maghrib), times.maghrib);
      expect(times.timeForPrayer(Prayer.isha), times.isha);
      expect(times.timeForPrayer(Prayer.none), isNull);
    });
  });

  group('currentPrayer / nextPrayer', () {
    // Local +4 instants expressed in UTC (wall clock minus the offset).
    DateTime atLocal(int hour, int minute) =>
        DateTime.utc(2026, 6, 28, hour, minute).subtract(utcOffset);

    test('before Fajr', () {
      final times = build();
      expect(times.currentPrayer(atLocal(3, 0)), Prayer.none);
      expect(times.nextPrayer(atLocal(3, 0)), Prayer.fajr);
    });

    test('early afternoon sits on Dhuhr with Asr next', () {
      final times = build();
      expect(times.currentPrayer(atLocal(13, 0)), Prayer.dhuhr);
      expect(times.nextPrayer(atLocal(13, 0)), Prayer.asr);
    });

    test('between Fajr and sunrise', () {
      final times = build();
      expect(times.currentPrayer(atLocal(4, 30)), Prayer.fajr);
      expect(times.nextPrayer(atLocal(4, 30)), Prayer.sunrise);
    });

    test('after Isha', () {
      final times = build();
      expect(times.currentPrayer(atLocal(23, 0)), Prayer.isha);
      expect(times.nextPrayer(atLocal(23, 0)), Prayer.none);
    });
  });

  group('construction', () {
    test('exposes inputs and a UTC-flagged local wall clock', () {
      final times = build();
      expect(times.coordinates, sohar);
      expect(times.dateComponents, date);
      expect(times.utcOffset, utcOffset);
      expect(times.fajr!.isUtc, isTrue);
      expect(times.fajr!.hour, 3);
      expect(times.fajr!.minute, 59);
    });

    test('today() uses the current date', () {
      final today = PrayerTimes.today(
        sohar,
        CalculationMethod.muslimWorldLeague.getParameters(),
        utcOffset: utcOffset,
      );
      final now = DateComponents.from(DateTime.now());
      expect(today.dateComponents, now);
    });
  });
}
