import '../data/auto_method_resolution.dart';
import '../methods/calculation_method.dart';

/// Resolves a [CalculationMethod] automatically from a location's country.
///
/// The bundled table covers every ISO-3166 country, so [forCountry] answers
/// from the country map directly and falls back to Muslim World League for
/// unrecognised codes.
abstract final class AutoMethod {
  /// The method conventionally used in the country given by [iso2]
  /// (ISO-3166 alpha-2, case-insensitive).
  ///
  /// ```dart
  /// AutoMethod.forCountry('OM'); // CalculationMethod.oman
  /// AutoMethod.forCountry('sa'); // CalculationMethod.ummAlQura
  /// ```
  static CalculationMethod forCountry(String iso2) {
    final key = methodKeyForCountry(iso2);
    return CalculationMethod.fromKey(key) ??
        CalculationMethod.muslimWorldLeague;
  }

  /// The raw method key for [iso2] (e.g. `oman`, `makkah`), or the default
  /// key when the country is unknown.
  static String methodKeyForCountry(String iso2) =>
      autoCountryMethods[iso2.toUpperCase()] ?? autoMethodDefault;
}
