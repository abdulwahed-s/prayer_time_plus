import 'package:prayer_time_plus/src/math/julian_day.dart';
import 'package:prayer_time_plus/src/math/sun_position.dart';
import 'package:test/test.dart';

void main() {
  group('sunPosition', () {
    // Sohar (lng 56.6953), 2026-06-28. Expected values verified against the
    // reference engine.
    final soharJd = julianDay(2026, 6, 28) - 56.6953 / 360.0;

    test('verified Sohar intermediates', () {
      final position = sunPosition(soharJd + 12.0 / 24.0);
      expect(position.declination, closeTo(23.2676, 1e-4));
      expect(position.equationOfTime, closeTo(-0.05468, 1e-5));
    });

    // Mecca (lng 39.82611), same date. Expected values were hand-computed
    // with rounded intermediates, so they are asserted loosely as a sanity
    // check on the formula chain.
    final meccaJd = julianDay(2026, 6, 28) - 39.82611 / 360.0;

    test('longitude-shifted base date', () {
      expect(meccaJd, closeTo(2461219.389372, 1e-6));
    });

    test('Mecca sanity values at the Dhuhr guess (t=0.5)', () {
      final position = sunPosition(meccaJd + 12.0 / 24.0);
      expect(position.declination, closeTo(23.262, 1e-2));
      expect(position.equationOfTime, closeTo(-0.054885, 5e-4));
    });

    test('Mecca sanity values at the Sunset guess (t=0.75)', () {
      final position = sunPosition(meccaJd + 18.0 / 24.0);
      expect(position.declination, closeTo(23.247, 1e-2));
      expect(position.equationOfTime, closeTo(-0.055518, 5e-4));
    });
  });
}
