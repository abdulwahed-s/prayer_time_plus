import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  group('Madhab', () {
    test('shadow factor is 1 for shafi and 2 for hanafi', () {
      expect(Madhab.shafi.shadowFactor, 1);
      expect(Madhab.hanafi.shadowFactor, 2);
    });
  });
}
