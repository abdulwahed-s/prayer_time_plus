import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  // A northern city in midsummer: the sun still rises and sets, but never
  // reaches the 18 deg Fajr/Isha depression, so the angle method leaves
  // Fajr and Isha undefined while the night length stays well defined.
  final oslo = Coordinates(59.9139, 10.7522);
  const date = DateComponents(2026, 6, 21);
  const utcOffset = Duration(hours: 2);

  CalculationParameters mwlWith(HighLatitudeRule? rule) =>
      CalculationMethod.muslimWorldLeague.getParameters()
        ..highLatitudeRule = rule;

  test('rule none leaves Fajr and Isha undefined', () {
    final times = PrayerTimes(
      oslo,
      date,
      mwlWith(HighLatitudeRule.none),
      utcOffset: utcOffset,
    );
    expect(times.fajr, isNull);
    expect(times.isha, isNull);
    // Daytime prayers are still defined.
    expect(times.dhuhr, isNotNull);
    expect(times.asr, isNotNull);
  });

  test('each fraction rule fills Fajr and Isha in', () {
    for (final rule in [
      HighLatitudeRule.middleOfTheNight,
      HighLatitudeRule.seventhOfTheNight,
      HighLatitudeRule.twilightAngle,
    ]) {
      final times = PrayerTimes(
        oslo,
        date,
        mwlWith(rule),
        utcOffset: utcOffset,
      );
      expect(times.fajr, isNotNull, reason: '$rule Fajr');
      expect(times.isha, isNotNull, reason: '$rule Isha');
      // Fajr sits before sunrise on the same morning. (Isha can wrap past
      // midnight at this latitude, so it is not ordered against Maghrib on
      // the same calendar date.)
      expect(times.fajr!.isBefore(times.sunrise!), isTrue, reason: '$rule');
    }
  });

  test('middle-of-night places Fajr earlier than one-seventh', () {
    final mid = PrayerTimes(
      oslo,
      date,
      mwlWith(HighLatitudeRule.middleOfTheNight),
      utcOffset: utcOffset,
    );
    final seventh = PrayerTimes(
      oslo,
      date,
      mwlWith(HighLatitudeRule.seventhOfTheNight),
      utcOffset: utcOffset,
    );
    // A larger night fraction (1/2 > 1/7) pushes Fajr earlier.
    expect(mid.fajr!.isBefore(seventh.fajr!), isTrue);
  });

  test('automatic rule (null) recovers from a degenerate day', () {
    final auto = PrayerTimes(oslo, date, mwlWith(null), utcOffset: utcOffset);
    expect(auto.fajr, isNotNull);
    expect(auto.isha, isNotNull);
  });
}
