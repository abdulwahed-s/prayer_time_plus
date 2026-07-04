import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  group('PrayerAdjustments', () {
    test('defaults to zero offsets', () {
      final adjustments = PrayerAdjustments();
      expect(adjustments.fajr, 0);
      expect(adjustments.sunrise, 0);
      expect(adjustments.dhuhr, 0);
      expect(adjustments.asr, 0);
      expect(adjustments.maghrib, 0);
      expect(adjustments.isha, 0);
    });

    test('fields are mutable for cascade-style tuning', () {
      final adjustments =
          PrayerAdjustments()
            ..fajr = 2
            ..isha = -3;
      expect(adjustments.fajr, 2);
      expect(adjustments.isha, -3);
    });

    test('copyWith replaces only the given fields', () {
      final adjustments = PrayerAdjustments(fajr: 1, isha: 2);
      final copy = adjustments.copyWith(isha: 5);
      expect(copy.fajr, 1);
      expect(copy.isha, 5);
      expect(adjustments.isha, 2, reason: 'original is untouched');
    });
  });
}
