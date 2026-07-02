import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  group('DateComponents', () {
    test('from(DateTime) extracts year, month, day', () {
      final date = DateComponents.from(DateTime(2026, 6, 28, 23, 59));
      expect(date, const DateComponents(2026, 6, 28));
    });

    test('has value equality', () {
      expect(
        const DateComponents(2026, 1, 2),
        const DateComponents(2026, 1, 2),
      );
      expect(
        const DateComponents(2026, 1, 2),
        isNot(const DateComponents(2026, 2, 1)),
      );
    });

    test('toString is zero-padded', () {
      expect(
        const DateComponents(2026, 6, 8).toString(),
        'DateComponents(2026-06-08)',
      );
    });
  });
}
