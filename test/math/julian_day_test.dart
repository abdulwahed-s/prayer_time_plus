import 'package:prayer_time_plus/src/math/julian_day.dart';
import 'package:test/test.dart';

void main() {
  group('julianDay', () {
    test('computes 2026-06-28', () {
      expect(julianDay(2026, 6, 28), 2461219.5);
    });

    test('handles the January/February year shift', () {
      // 2000-01-01 00:00 UT is the classic JD 2451544.5.
      expect(julianDay(2000, 1, 1), 2451544.5);
      expect(julianDay(2000, 2, 29), 2451603.5);
    });

    test('J2000 epoch anchor', () {
      // 2000-01-01 12:00 TT = JD 2451545.0, so midnight is 2451544.5.
      expect(julianDay(2000, 1, 1) + 0.5, 2451545.0);
    });
  });
}
