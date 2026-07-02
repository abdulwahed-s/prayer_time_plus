import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  group('HighLatitudeRule.nightPortion', () {
    test('none allows no night fraction', () {
      expect(HighLatitudeRule.none.nightPortion(18), 0.0);
    });

    test('middleOfTheNight is half', () {
      expect(HighLatitudeRule.middleOfTheNight.nightPortion(18), 0.5);
    });

    test('seventhOfTheNight uses the exact 0.14286 literal', () {
      expect(HighLatitudeRule.seventhOfTheNight.nightPortion(18), 0.14286);
      expect(
        HighLatitudeRule.seventhOfTheNight.nightPortion(18),
        isNot(1 / 7),
        reason: 'the rounded literal is parity-critical',
      );
    });

    test('twilightAngle is angle / 60', () {
      expect(
        HighLatitudeRule.twilightAngle.nightPortion(18),
        closeTo(0.3, 1e-12),
      );
      expect(
        HighLatitudeRule.twilightAngle.nightPortion(15),
        closeTo(0.25, 1e-12),
      );
    });
  });
}
