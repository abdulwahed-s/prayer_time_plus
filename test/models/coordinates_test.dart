import 'package:prayer_time_plus/prayer_time_plus.dart';
import 'package:test/test.dart';

void main() {
  group('Coordinates', () {
    test('is permissive by default', () {
      final coordinates = Coordinates(1000, -1000);
      expect(coordinates.latitude, 1000);
      expect(coordinates.longitude, -1000);
      expect(coordinates.altitude, 0);
    });

    test('validate: true rejects out-of-range latitude', () {
      expect(() => Coordinates(90.1, 0, validate: true), throwsArgumentError);
      expect(() => Coordinates(-90.1, 0, validate: true), throwsArgumentError);
    });

    test('validate: true rejects out-of-range longitude', () {
      expect(() => Coordinates(0, 180.1, validate: true), throwsArgumentError);
      expect(() => Coordinates(0, -180.1, validate: true), throwsArgumentError);
    });

    test('validate: true accepts boundary values', () {
      expect(Coordinates(90, 180, validate: true).latitude, 90);
      expect(Coordinates(-90, -180, validate: true).longitude, -180);
    });

    test('has value equality', () {
      expect(Coordinates(1, 2, altitude: 3), Coordinates(1, 2, altitude: 3));
      expect(
        Coordinates(1, 2, altitude: 3).hashCode,
        Coordinates(1, 2, altitude: 3).hashCode,
      );
      expect(Coordinates(1, 2), isNot(Coordinates(2, 1)));
    });
  });
}
