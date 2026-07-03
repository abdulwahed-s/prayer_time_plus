import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  group('Qibla', () {
    test('matches known bearings', () {
      expect(
        Qibla(Coordinates(24.3486, 56.6953)).direction,
        closeTo(262.7151, 1e-3),
      );
      expect(
        Qibla(Coordinates(40.7128, -74.0059)).direction,
        closeTo(58.4818, 1e-3),
      );
      expect(
        Qibla(Coordinates(38.9072, -77.0369)).direction,
        closeTo(56.5605, 1e-3),
      );
      expect(
        Qibla(Coordinates(51.5074, -0.1278)).direction,
        closeTo(118.9872, 1e-3),
      );
    });

    test('points south from due north of the Kaaba and vice versa', () {
      expect(Qibla(Coordinates(40.0, 39.826206)).direction, closeTo(180, 1e-9));
      expect(Qibla(Coordinates(0.0, 39.826206)).direction, closeTo(0, 1e-9));
    });

    test('is always normalised to [0, 360)', () {
      expect(
        Qibla(Coordinates(-33.8688, 151.2093)).direction,
        inInclusiveRange(0, 360),
      );
    });
  });
}
