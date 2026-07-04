import 'dart:io';

import 'package:prayer_time_plus/prayer_time_plus.dart';

/// Prints today's prayer times for a sample location (Sohar, Oman).
///
/// Run with `dart run prayer_time_plus`.
void main() {
  final coordinates = Coordinates(24.3486, 56.6953, altitude: 5);
  const utcOffset = Duration(hours: 4);
  final params = CalculationMethod.oman.getParameters();

  final times = PrayerTimes.today(
    coordinates,
    params,
    utcOffset: utcOffset,
    countryCode: 'OM',
    cityName: 'sohar',
  );

  final date = times.dateComponents;
  final output =
      StringBuffer()
        ..writeln('Sohar, Oman — ${_date(date)} (method: ${params.method})')
        ..writeln('  Fajr     ${_time(times.fajr)}')
        ..writeln('  Sunrise  ${_time(times.sunrise)}')
        ..writeln('  Dhuhr    ${_time(times.dhuhr)}')
        ..writeln('  Asr      ${_time(times.asr)}')
        ..writeln('  Maghrib  ${_time(times.maghrib)}')
        ..writeln('  Isha     ${_time(times.isha)}')
        ..writeln()
        ..writeln('  Current  ${times.currentPrayer().name}')
        ..writeln('  Next     ${times.nextPrayer().name}')
        ..writeln(
          '  Qibla    ${Qibla(coordinates).direction.toStringAsFixed(1)}° from N',
        );
  stdout.write(output.toString());
}

String _time(DateTime? time) =>
    time == null
        ? '--:--'
        : '${time.hour.toString().padLeft(2, '0')}:'
            '${time.minute.toString().padLeft(2, '0')}';

String _date(DateComponents date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
