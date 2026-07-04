import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  group('CalculationMethod', () {
    test('decodes the oman preset', () {
      final params = CalculationMethod.oman.getParameters();
      expect(params.method, 'oman');
      expect(params.fajrAngle, 18.0);
      expect(params.maghribIsInterval, isTrue);
      expect(params.maghribValue, 5.0);
      expect(params.ishaIsInterval, isFalse);
      expect(params.ishaValue, 18.0);
      expect(params.methodAdjustments.dhuhr, 5);
      expect(params.methodAdjustments.asr, 5);
      expect(params.methodAdjustments.isha, 1);
      expect(params.adjustments.fajr, 0);
    });

    test('decodes the ummAlQura interval Isha', () {
      final params = CalculationMethod.ummAlQura.getParameters();
      expect(params.fajrAngle, 18.5);
      expect(params.ishaIsInterval, isTrue);
      expect(params.ishaValue, 90.0);
      expect(params.isRamadan, isFalse);
    });

    test('decodes negative offsets (emirates)', () {
      final params = CalculationMethod.emirates.getParameters();
      expect(params.methodAdjustments.fajr, 1);
      expect(params.methodAdjustments.sunrise, -4);
      expect(params.methodAdjustments.dhuhr, 2);
      expect(params.methodAdjustments.isha, -3);
    });

    test('dubai falls back to the MWL base values', () {
      final dubai = CalculationMethod.dubai.getParameters();
      final mwl = CalculationMethod.muslimWorldLeague.getParameters();
      expect(dubai.method, 'dubai');
      expect(dubai.fajrAngle, mwl.fajrAngle);
      expect(dubai.ishaValue, mwl.ishaValue);
      expect(dubai.maghribIsInterval, mwl.maghribIsInterval);
    });

    test('getParameters returns fresh instances', () {
      final first =
          CalculationMethod.muslimWorldLeague.getParameters()
            ..madhab = Madhab.hanafi
            ..adjustments.fajr = 10;
      final second = CalculationMethod.muslimWorldLeague.getParameters();
      expect(first.madhab, Madhab.hanafi);
      expect(second.madhab, Madhab.shafi);
      expect(second.adjustments.fajr, 0);
    });

    test('every preset produces usable parameters', () {
      for (final method in CalculationMethod.values) {
        final params = method.getParameters();
        expect(params.method, method.key);
        expect(params.fajrAngle, greaterThan(0), reason: method.key);
        expect(params.ishaValue, greaterThan(0), reason: method.key);
      }
    });

    test('fromKey resolves every enum key and rejects unknown ones', () {
      for (final method in CalculationMethod.values) {
        expect(CalculationMethod.fromKey(method.key), method);
      }
      expect(CalculationMethod.fromKey('jafari'), isNull);
      expect(CalculationMethod.fromKey('tehran'), isNull);
      expect(CalculationMethod.fromKey('nope'), isNull);
    });

    test('keys are unique', () {
      final keys = CalculationMethod.values.map((m) => m.key).toSet();
      expect(keys, hasLength(CalculationMethod.values.length));
    });
  });

  group('CalculationParameters', () {
    test('copyWith deep-copies the adjustment objects', () {
      final original = CalculationMethod.muslimWorldLeague.getParameters();
      final copy = original.copyWith()..adjustments.fajr = 7;
      expect(original.adjustments.fajr, 0);
      expect(copy.adjustments.fajr, 7);
    });

    test('withMethodAdjustments replaces only the method offsets', () {
      final params = CalculationMethod.muslimWorldLeague
          .getParameters()
          .withMethodAdjustments(PrayerAdjustments(dhuhr: 3));
      expect(params.methodAdjustments.dhuhr, 3);
      expect(params.fajrAngle, 18.0);
    });

    test('custom construction defaults', () {
      final params = CalculationParameters(fajrAngle: 18, ishaValue: 17);
      expect(params.method, isNull);
      expect(params.maghribIsInterval, isFalse);
      expect(params.maghribValue, 0);
      expect(params.ishaIsInterval, isFalse);
      expect(params.madhab, Madhab.shafi);
      expect(params.highLatitudeRule, isNull);
      expect(params.isRamadan, isFalse);
    });
  });
}
