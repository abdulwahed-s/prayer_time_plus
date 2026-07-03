import 'models/date_components.dart';
import 'prayer_times.dart';

/// Night-portion times derived from a day's prayer times.
///
/// The night runs from Maghrib on the source day to Fajr the next day, so
/// constructing this recomputes the following day's Fajr using the same
/// coordinates, parameters, and offset.
///
/// ```dart
/// final sunnah = SunnahTimes(prayerTimes);
/// print(sunnah.lastThirdOfTheNight);
/// ```
class SunnahTimes {
  /// Computes the Sunnah times for the night following [prayerTimes].
  factory SunnahTimes(PrayerTimes prayerTimes) {
    final date = prayerTimes.dateComponents;
    final nextDay = DateComponents.from(
      DateTime(date.year, date.month, date.day).add(const Duration(days: 1)),
    );
    final tomorrow = PrayerTimes(
      prayerTimes.coordinates,
      nextDay,
      prayerTimes.calculationParameters,
      utcOffset: prayerTimes.utcOffset,
    );

    final maghrib = prayerTimes.maghrib;
    final nextFajr = tomorrow.fajr;
    if (maghrib == null || nextFajr == null) {
      return const SunnahTimes._(null, null);
    }

    final nightMinutes = nextFajr.difference(maghrib).inMinutes;
    return SunnahTimes._(
      maghrib.add(Duration(minutes: (nightMinutes / 2).round())),
      maghrib.add(Duration(minutes: (nightMinutes * 2 / 3).round())),
    );
  }

  const SunnahTimes._(this.middleOfTheNight, this.lastThirdOfTheNight);

  /// The midpoint between Maghrib and the next day's Fajr, or `null` when
  /// either endpoint is undefined.
  final DateTime? middleOfTheNight;

  /// The start of the last third of the night, or `null` when either
  /// endpoint is undefined.
  final DateTime? lastThirdOfTheNight;
}
