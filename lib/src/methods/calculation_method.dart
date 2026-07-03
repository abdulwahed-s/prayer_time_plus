import '../models/prayer_adjustments.dart';
import 'calculation_parameters.dart';
import 'method_params.dart';

/// Preset calculation methods.
///
/// Each preset carries a Fajr angle, an Isha angle or interval, an optional
/// Maghrib interval, and per-prayer minute offsets. Call [getParameters] to
/// obtain a fresh, customisable [CalculationParameters]:
///
/// ```dart
/// final params = CalculationMethod.muslimWorldLeague.getParameters();
/// ```
enum CalculationMethod {
  // ── Global standards ──────────────────────────────────────────────

  /// Muslim World League: Fajr 18°, Isha 17°.
  muslimWorldLeague('mwl'),

  /// Egyptian General Authority of Survey: Fajr 19.5°, Isha 17.5°.
  egyptian('egypt'),

  /// University of Islamic Sciences, Karachi: Fajr 18°, Isha 18°.
  karachi('karachi'),

  /// Umm al-Qura, Makkah: Fajr 18.5°, Isha = Maghrib + 90 min.
  ///
  /// During Ramadan (see [CalculationParameters.isRamadan]) Isha becomes
  /// Maghrib + 120 min for locations in Saudi Arabia.
  ummAlQura('makkah'),

  /// Islamic Society of North America: Fajr 15°, Isha 15°.
  northAmerica('isna'),

  // ── Gulf ──────────────────────────────────────────────────────────

  /// UAE (GAIAE): Fajr 18.5°, Isha 18.5° − 3 min, Maghrib sunset + 2 min,
  /// Fajr +1, Sunrise −4, Dhuhr +2.
  emirates('emirates'),

  /// Dubai: no dedicated parameter row — uses the Muslim World League base
  /// values (Fajr 18°, Isha 17°).
  dubai('dubai'),

  /// Qatar Calendar House: Fajr 18°, Isha = Maghrib + 90 min, Maghrib
  /// sunset + 2 min.
  qatar('qatar'),

  /// Kuwait: Fajr 18°, Isha 17.5°.
  kuwait('kuwait'),

  /// Oman: Fajr 18°, Isha 18° + 1 min, Maghrib sunset + 5 min, Dhuhr +5,
  /// Asr +5.
  oman('oman'),

  /// Muscat, Oman (city variant): Fajr 17.74°, Isha 18.229°, Sunrise +1,
  /// Dhuhr +6, Asr +6, Maghrib sunset + 6 min.
  omanMuscat('omanMuscat'),

  // ── Levant & Iraq ─────────────────────────────────────────────────

  /// Jordan: Fajr 18.12°, Isha 17.975°, Maghrib sunset + 1 min.
  jordan('jordan'),

  /// Palestine: Fajr 20.11°, Isha 17.9°, Sunrise −5, Maghrib sunset
  /// + 4 min.
  palestine('palestine'),

  /// Syria (Hashemi): Fajr 19.5°, Isha 17.5°.
  syria('syria'),

  /// Iraq: Fajr 18°, Isha 17°, Dhuhr +5, Asr +3, Maghrib sunset + 2 min.
  iraq('iraq'),

  // ── North Africa ──────────────────────────────────────────────────

  /// Morocco (Habous): Fajr 19.09°, Isha 17°, Sunrise −2, Dhuhr +5,
  /// Maghrib sunset + 3 min.
  morocco('morocco'),

  /// Azrou, Morocco (city variant): Fajr 19.1°, Isha 17°, Sunrise −1,
  /// Dhuhr +5, Maghrib sunset + 1 min.
  azrou('azrou'),

  /// Algeria: Fajr 18°, Isha 17°, Maghrib sunset + 3 min.
  algeria('algeria'),

  /// Tunisia: Fajr 18°, Isha 18° + 1 min, Fajr −1, Dhuhr +7, Maghrib
  /// sunset + 1 min.
  tunisia('tunisia'),

  /// Libya: Fajr 18.3°, Isha 18.35°, Dhuhr +4, Maghrib sunset + 4 min.
  libya('libya'),

  /// Sudan: Fajr 18.12°, Isha 17.88°, Sunrise +3, Dhuhr +3, Maghrib
  /// sunset − 4 min.
  sudan('sudan'),

  // ── Asia ──────────────────────────────────────────────────────────

  /// Turkey (Diyanet): Fajr 18°, Isha 16.93°, Sunrise −6, Dhuhr +6,
  /// Asr +4, Maghrib sunset + 5 min.
  turkey('turkey'),

  /// Southeast Asia (Brunei, Cambodia, Laos, Myanmar, Philippines,
  /// Singapore, Thailand, Vietnam): Fajr 20°, Isha 18°, Dhuhr +1.
  malaysia('malaysia'),

  /// Malaysia (updated national preset): Fajr 20°, Isha 18.46°, Dhuhr +3,
  /// Asr +2, Maghrib sunset + 1 min.
  malaysia2('malaysia2'),

  /// Indonesia: Fajr 20°, Isha 18° + 2 min, Fajr +2, Sunrise −2, Dhuhr +2,
  /// Asr +2, Maghrib sunset + 2 min.
  indonesia('indonesia'),

  /// Kazakhstan (Kostanay): Fajr 14.97°, Isha 14.96°, Dhuhr +5, Asr +5.
  kazakhstan('kazakhstan'),

  /// Tajikistan: Fajr 18°, Isha 18°.
  tajikistan('tajikistan'),

  /// Maldives: Fajr 19°, Isha 19° + 1 min, Sunrise −1, Dhuhr +4, Asr +1,
  /// Maghrib sunset + 1 min.
  maldives('maldives'),

  /// South Korea: Fajr 18°, Isha 18° − 6 min, Fajr +1, Sunrise −1.
  southKorea('southkorea'),

  // ── Europe ────────────────────────────────────────────────────────

  /// Union des Organisations Islamiques de France: Fajr 12°, Isha 12°
  /// + 5 min, Fajr −5, Dhuhr +5, Maghrib sunset + 4 min.
  uoif('uoif'),

  /// Paris (same parameters as [uoif]).
  paris('paris'),

  /// Toulouse (same parameters as [uoif]).
  toulouse('toulouse'),

  /// Lyon (same parameters as [uoif]).
  lyon('lyon'),

  /// Orléans: Fajr 15°, Isha 12.34°, Dhuhr +5.
  orleans('orleans'),

  /// Moscow: Fajr 16°, Isha 15.1° + 2 min, Dhuhr +1, Asr +1, Maghrib
  /// sunset + 1 min.
  moscow('moscow'),

  /// Czech Republic: Fajr 12.04°, Isha 12.04°, Dhuhr +5, Maghrib sunset
  /// − 2 min.
  czech('czech'),

  /// Switzerland (Geneva): Fajr 17.99°, Isha = Maghrib + 100 min, Fajr +1,
  /// Sunrise +4, Maghrib sunset − 4 min.
  switzerland('switzerland'),

  /// Fribourg, Switzerland (city variant): Fajr 18.01°, Isha = Maghrib
  /// + 100 min, Fajr +1, Sunrise +5, Maghrib sunset − 5 min.
  fribourg('fribourg'),

  /// Belgium: Fajr 18°, Isha 18°.
  belgium('belgium'),

  /// Luxembourg: Fajr 18°, Isha 17°.
  luxembourg('luxembourg'),

  /// Austria: Fajr 18°, Isha 17°.
  austria('austria'),

  /// London: Fajr 18°, Isha 17°.
  london('london'),

  /// Birmingham: Fajr 18°, Isha 17°.
  birmingham('birmingham'),

  /// Blackburn: Fajr 18°, Isha 17°.
  blackburn('blackburn'),

  /// Aachen: Fajr 18°, Isha 17°.
  aachen('aachen'),

  /// Munich: Fajr 18°, Isha 17°.
  munchen('munchen'),

  /// Potsdam: Fajr 18°, Isha 17°.
  potsdam('potsdam'),

  /// Nuremberg: Fajr 18°, Isha 17°.
  nurnberg('nurnberg'),

  /// Rotterdam: Fajr 15°, Isha 15°.
  rotterdam('rotterdam'),

  /// Dordrecht: Fajr 15°, Isha 15°.
  dordrecht('dordrecht'),

  /// Eindhoven: Fajr 15°, Isha 15°.
  eindhoven('eindhoven'),

  // ── Americas ──────────────────────────────────────────────────────

  /// Montréal: Fajr 15°, Isha 15°.
  montreal('montreal'),

  /// Windsor: Fajr 15°, Isha 15°.
  windsor('windsor'),

  /// Calgary: Fajr 15°, Isha 15°.
  calgary('calgary'),

  /// Mississauga: Fajr 15°, Isha 15°.
  mississauga('mississauga'),

  // ── Custom ────────────────────────────────────────────────────────

  /// A blank starting point (Muslim World League values: Fajr 18°,
  /// Isha 17°) intended to be customised.
  other('custom');

  const CalculationMethod(this.key);

  /// The engine key for this method (e.g. `mwl`, `makkah`, `oman`).
  final String key;

  /// Looks a method up by its engine [key]; returns `null` when unknown.
  static CalculationMethod? fromKey(String key) {
    for (final method in values) {
      if (method.key == key) {
        return method;
      }
    }
    return null;
  }

  /// Builds a fresh [CalculationParameters] for this method.
  ///
  /// Every call returns a new instance (with new adjustment objects), so
  /// customising the result never affects other callers.
  CalculationParameters getParameters() {
    final params = paramsForKey(key);
    return CalculationParameters(
      method: key,
      fajrAngle: params[0],
      maghribIsInterval: params[1] == 1,
      maghribValue: params[2],
      ishaIsInterval: params[3] == 1,
      ishaValue: params[4],
      methodAdjustments: PrayerAdjustments(
        fajr: params[5].toInt(),
        sunrise: params[6].toInt(),
        dhuhr: params[7].toInt(),
        asr: params[8].toInt(),
        maghrib: params[9].toInt(),
        isha: params[10].toInt(),
      ),
    );
  }
}
