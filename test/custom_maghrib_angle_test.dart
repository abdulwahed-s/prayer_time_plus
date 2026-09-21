import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  // Cross-package conformance fixture shared with the Kotlin and Swift suites.
  final sohar = Coordinates(24.3486, 56.6953, altitude: 5);
  const date = DateComponents(2026, 6, 28);
  const utcOffset = Duration(hours: 4);

  CalculationParameters custom({
    double maghribValue = 0,
    bool maghribIsInterval = false,
    double ishaValue = 17,
    bool ishaIsInterval = false,
    PrayerAdjustments? methodAdjustments,
    PrayerAdjustments? adjustments,
  }) => CalculationParameters(
    method: 'custom',
    fajrAngle: 18,
    maghribIsInterval: maghribIsInterval,
    maghribValue: maghribValue,
    ishaIsInterval: ishaIsInterval,
    ishaValue: ishaValue,
    methodAdjustments: methodAdjustments,
    adjustments: adjustments,
    highLatitudeRule: HighLatitudeRule.none,
  );

  PrayerTimes times(CalculationParameters params) => PrayerTimes(
    sohar,
    date,
    params,
    utcOffset: utcOffset,
    countryCode: 'OM',
    cityName: 'sohar',
  );

  test('positive Maghrib angle produces a post-sunset time', () {
    final result = times(custom(maghribValue: 4));

    expect(result.maghrib, isNotNull);
    expect(result.maghrib!.isAfter(result.sunset!), isTrue);
  });

  test('zero and negative Maghrib angles retain sunset', () {
    for (final angle in [0.0, -4.0]) {
      final result = times(custom(maghribValue: angle));
      expect(result.maghrib, result.sunset, reason: '$angle degrees');
    }
  });

  test('Maghrib interval remains minutes after sunset', () {
    final result = times(custom(maghribIsInterval: true, maghribValue: 5));

    expect(result.maghrib!.difference(result.sunset!).inMinutes, 5);
  });

  test('interval Isha is based on final angle-based Maghrib', () {
    final result = times(
      custom(maghribValue: 4, ishaIsInterval: true, ishaValue: 90),
    );

    expect(result.maghrib!.isAfter(result.sunset!), isTrue);
    expect(result.isha!.difference(result.maghrib!).inMinutes, 90);
  });

  test('unavailable Maghrib angle falls back to sunset', () {
    final london = PrayerTimes(
      Coordinates(51.5080, -0.1281),
      const DateComponents(2026, 7, 9),
      custom(maghribValue: 18, ishaIsInterval: true, ishaValue: 90),
      utcOffset: const Duration(hours: 1),
      countryCode: 'GB',
      cityName: 'London',
    );

    expect(london.maghrib, london.sunset);
    expect(london.isha!.difference(london.maghrib!).inMinutes, 90);
  });

  test('Maghrib angle at or after angle-based Isha falls back to sunset', () {
    final result = times(custom(maghribValue: 20, ishaValue: 17));

    expect(result.maghrib, result.sunset);
    expect(result.maghrib!.isBefore(result.isha!), isTrue);
  });

  test('custom angle prayers remain chronological', () {
    final result = times(custom(maghribValue: 4, ishaValue: 17));

    expect(result.fajr!.isBefore(result.maghrib!), isTrue);
    expect(result.sunset!.isBefore(result.maghrib!), isTrue);
    expect(result.maghrib!.isBefore(result.isha!), isTrue);
  });

  test('existing presets without a Maghrib angle retain golden results', () {
    final mwl = times(CalculationMethod.muslimWorldLeague.getParameters());
    final oman = times(CalculationMethod.oman.getParameters());

    expect((mwl.sunset!.hour, mwl.sunset!.minute), (19, 5));
    expect((mwl.maghrib!.hour, mwl.maghrib!.minute), (19, 5));
    expect((mwl.isha!.hour, mwl.isha!.minute), (20, 28));
    expect((oman.maghrib!.hour, oman.maghrib!.minute), (19, 10));
    expect((oman.isha!.hour, oman.isha!.minute), (20, 35));
  });

  test('custom preset has the shared defaults and stable key', () {
    final params = CalculationMethod.other.getParameters();
    final result = times(params);

    expect(CalculationMethod.other.key, 'custom');
    expect(CalculationMethod.fromKey('custom'), CalculationMethod.other);
    expect(params.method, 'custom');
    expect(params.fajrAngle, 18);
    expect(params.maghribIsInterval, isTrue);
    expect(params.maghribValue, 0);
    expect(params.ishaIsInterval, isFalse);
    expect(params.ishaValue, 17);
    expect(result.maghrib, result.sunset);
  });

  test('method and user adjustments are applied exactly once', () {
    final base = times(
      custom(maghribValue: 4, ishaIsInterval: true, ishaValue: 90),
    );
    final tuned = times(
      custom(
        maghribValue: 4,
        ishaIsInterval: true,
        ishaValue: 90,
        methodAdjustments: PrayerAdjustments(maghrib: 2, isha: 3),
        adjustments: PrayerAdjustments(maghrib: 3, isha: 4),
      ),
    );

    expect(tuned.maghrib!.difference(base.maghrib!).inMinutes, 5);
    expect(tuned.isha!.difference(base.isha!).inMinutes, 12);
  });
}
