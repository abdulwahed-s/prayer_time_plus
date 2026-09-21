import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:prayer_time_plus/src/data/auto_method_resolution.dart';
import 'package:test/test.dart';

// Every supported country-wide preset. Global/regional defaults and city-only
// variants are intentionally excluded.
const _dedicatedNationalMethods = <String, CalculationMethod>{
  'AE': CalculationMethod.emirates,
  'AT': CalculationMethod.austria,
  'BE': CalculationMethod.belgium,
  'CH': CalculationMethod.switzerland,
  'CZ': CalculationMethod.czech,
  'DZ': CalculationMethod.algeria,
  'EG': CalculationMethod.egyptian,
  'FR': CalculationMethod.uoif,
  'ID': CalculationMethod.indonesia,
  'IQ': CalculationMethod.iraq,
  'JO': CalculationMethod.jordan,
  'KR': CalculationMethod.southKorea,
  'KW': CalculationMethod.kuwait,
  'KZ': CalculationMethod.kazakhstan,
  'LU': CalculationMethod.luxembourg,
  'LY': CalculationMethod.libya,
  'MA': CalculationMethod.morocco,
  'MV': CalculationMethod.maldives,
  'MY': CalculationMethod.malaysia2,
  'OM': CalculationMethod.oman,
  'PK': CalculationMethod.karachi,
  'PS': CalculationMethod.palestine,
  'QA': CalculationMethod.qatar,
  'SA': CalculationMethod.ummAlQura,
  'SD': CalculationMethod.sudan,
  'SY': CalculationMethod.syria,
  'TJ': CalculationMethod.tajikistan,
  'TN': CalculationMethod.tunisia,
  'TR': CalculationMethod.turkey,
};

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

    test('resolves the corrected Iraq and Austria defaults', () {
      expect(AutoMethod.forCountry('IQ'), CalculationMethod.iraq);
      expect(AutoMethod.forCountry('AT'), CalculationMethod.austria);
    });

    test('resolves every dedicated national method', () {
      for (final entry in _dedicatedNationalMethods.entries) {
        expect(
          AutoMethod.forCountry(entry.key),
          entry.value,
          reason: entry.key,
        );
      }
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
