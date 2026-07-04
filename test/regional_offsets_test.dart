import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

int? minutes(DateTime? time) =>
    time == null ? null : time.hour * 60 + time.minute;

void main() {
  // Every preset should equal a same-angle, zero-offset baseline shifted by
  // exactly its documented per-prayer minute offsets. Adding whole minutes
  // commutes with nearest-minute rounding, so this is exact.
  //
  // A low latitude keeps every angle-based time well defined, and altitude 0
  // neutralises the elevation term, so only the offsets differ.
  final location = Coordinates(15.0, 45.0);
  const date = DateComponents(2026, 6, 28);
  const utcOffset = Duration(hours: 3);

  for (final method in CalculationMethod.values) {
    test('${method.key} applies its offsets over the baseline', () {
      final params =
          method.getParameters()..highLatitudeRule = HighLatitudeRule.none;
      final offsets = params.methodAdjustments;

      final baseline =
          method.getParameters()
            ..highLatitudeRule = HighLatitudeRule.none
            ..methodAdjustments = PrayerAdjustments();

      final actual = PrayerTimes(location, date, params, utcOffset: utcOffset);
      final base = PrayerTimes(location, date, baseline, utcOffset: utcOffset);

      expect(minutes(actual.fajr), minutes(base.fajr)! + offsets.fajr);
      expect(minutes(actual.sunrise), minutes(base.sunrise)! + offsets.sunrise);
      expect(minutes(actual.dhuhr), minutes(base.dhuhr)! + offsets.dhuhr);
      expect(minutes(actual.asr), minutes(base.asr)! + offsets.asr);
      expect(minutes(actual.maghrib), minutes(base.maghrib)! + offsets.maghrib);

      // Interval Isha is measured from Maghrib, so it also picks up the
      // Maghrib offset; angle Isha only picks up the Isha offset.
      final expectedIsha =
          params.ishaIsInterval
              ? minutes(base.isha)! + offsets.maghrib + offsets.isha
              : minutes(base.isha)! + offsets.isha;
      expect(minutes(actual.isha), expectedIsha);
    });
  }

  test('user adjustments stack on top of the method offsets', () {
    final params =
        CalculationMethod.oman.getParameters()
          ..highLatitudeRule = HighLatitudeRule.none
          ..adjustments.dhuhr = 3;
    final baseline =
        CalculationMethod.oman.getParameters()
          ..highLatitudeRule = HighLatitudeRule.none;

    final tuned = PrayerTimes(location, date, params, utcOffset: utcOffset);
    final base = PrayerTimes(location, date, baseline, utcOffset: utcOffset);
    expect(minutes(tuned.dhuhr), minutes(base.dhuhr)! + 3);
  });
}
