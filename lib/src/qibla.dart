import 'dart:math' as math;

import 'models/coordinates.dart';

/// The Qibla direction from a location.
///
/// ```dart
/// final qibla = Qibla(Coordinates(24.3486, 56.6953));
/// print(qibla.direction); // degrees clockwise from true north
/// ```
class Qibla {
  /// Computes the Qibla direction from [coordinates].
  Qibla(Coordinates coordinates) : direction = _bearing(coordinates);

  /// The initial great-circle bearing to the Kaaba, in degrees clockwise
  /// from true north, normalised to `[0, 360)`.
  final double direction;

  // Kaaba coordinates in degrees.
  static const double _kaabaLatitude = 21.422487;
  static const double _kaabaLongitude = 39.826206;

  static double _bearing(Coordinates coordinates) {
    final kaabaLat = _toRadians(_kaabaLatitude);
    final observerLat = _toRadians(coordinates.latitude);
    final deltaLng = _toRadians(_kaabaLongitude - coordinates.longitude);
    final y = math.sin(deltaLng) * math.cos(kaabaLat);
    final x =
        math.cos(observerLat) * math.sin(kaabaLat) -
        math.sin(observerLat) * math.cos(kaabaLat) * math.cos(deltaLng);
    final degrees = _toDegrees(math.atan2(y, x)) + 360.0;
    return degrees % 360.0;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180.0;

  static double _toDegrees(double radians) => radians * 180.0 / math.pi;
}
