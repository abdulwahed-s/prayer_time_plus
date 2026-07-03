import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:prayer_time_plus/src/data/auto_method_resolution.dart';
import 'package:test/test.dart';

void main() {
  group('AutoMethod.forCountry', () {
    test('resolves the documented sanity set', () {
      expect(AutoMethod.forCountry('OM'), CalculationMethod.oman);
      expect(AutoMethod.forCountry('SA'), CalculationMethod.ummAlQura);
      expect(AutoMethod.forCountry('AE'), CalculationMethod.emirates);
      expect(AutoMethod.forCountry('TR'), CalculationMethod.turkey);
      expect(AutoMethod.forCountry('FR'), CalculationMethod.uoif);
      expect(AutoMethod.forCountry('US'), CalculationMethod.northAmerica);
      expect(AutoMethod.forCountry('GB'), CalculationMethod.muslimWorldLeague);
      expect(AutoMethod.forCountry('PK'), CalculationMethod.karachi);
      expect(AutoMethod.forCountry('EG'), CalculationMethod.egyptian);
      expect(AutoMethod.forCountry('ID'), CalculationMethod.indonesia);
      expect(AutoMethod.forCountry('MY'), CalculationMethod.malaysia2);
    });

    test('is case-insensitive', () {
      expect(AutoMethod.forCountry('om'), CalculationMethod.oman);
      expect(AutoMethod.forCountry('sa'), CalculationMethod.ummAlQura);
    });

    test('falls back to Muslim World League for unknown codes', () {
      expect(AutoMethod.forCountry('ZZ'), CalculationMethod.muslimWorldLeague);
      expect(AutoMethod.forCountry(''), CalculationMethod.muslimWorldLeague);
    });

    test('every bundled country key maps to a known method', () {
      for (final code in autoCountryMethods.keys) {
        expect(
          CalculationMethod.fromKey(autoCountryMethods[code]!),
          isNotNull,
          reason: code,
        );
      }
    });
  });
}
