import 'package:prayer_time_plus/src/engine/rounding.dart';
import 'package:test/test.dart';

void main() {
  group('roundToMinuteOfDay', () {
    test('exact hour', () {
      expect(roundToMinuteOfDay(12.0), 720);
    });

    test('rounds up past the half-minute', () {
      // 12:29:40 -> 12:30.
      expect(roundToMinuteOfDay(12 + (29 * 60 + 40) / 3600), 12 * 60 + 30);
    });

    test('rounds down before the half-minute', () {
      // 12:29:20 -> 12:29.
      expect(roundToMinuteOfDay(12 + (29 * 60 + 20) / 3600), 12 * 60 + 29);
    });

    test('an exact :30 does not round up (truncated half-minute literal)', () {
      // The reference adds 0.0083333333 h (just under 30 s) before
      // truncating, so a time landing exactly on :30 stays in its minute.
      expect(roundToMinuteOfDay(12 + 29.5 / 60), 12 * 60 + 29);
    });

    test('wraps across midnight', () {
      // 23:59:48 -> 24:00 -> 00:00.
      expect(roundToMinuteOfDay(23 + 59.8 / 60), 0);
    });

    test('undefined time is null', () {
      expect(roundToMinuteOfDay(double.nan), isNull);
    });
  });
}
