/// A geographic position used as the observer location.
///
/// Latitude is in degrees, north positive; longitude is in degrees, **east
/// positive**; [altitude] is in metres above sea level and only affects the
/// handful of calculation methods that apply an elevation correction to
/// sunrise/sunset.
///
/// ```dart
/// final sohar = Coordinates(24.3486, 56.6953, altitude: 5);
/// ```
class Coordinates {
  /// Creates a coordinate pair.
  ///
  /// By default no validation is performed. Pass `validate: true` to throw
  /// an [ArgumentError] when [latitude] is outside `[-90, 90]` or
  /// [longitude] is outside `[-180, 180]`.
  Coordinates(
    this.latitude,
    this.longitude, {
    this.altitude = 0,
    bool validate = false,
  }) {
    if (validate) {
      if (latitude < -90 || latitude > 90) {
        throw ArgumentError.value(
          latitude,
          'latitude',
          'must be within [-90, 90]',
        );
      }
      if (longitude < -180 || longitude > 180) {
        throw ArgumentError.value(
          longitude,
          'longitude',
          'must be within [-180, 180]',
        );
      }
    }
  }

  /// Latitude in degrees, north positive.
  final double latitude;

  /// Longitude in degrees, east positive.
  final double longitude;

  /// Altitude in metres above sea level.
  final double altitude;

  @override
  bool operator ==(Object other) =>
      other is Coordinates &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.altitude == altitude;

  @override
  int get hashCode => Object.hash(latitude, longitude, altitude);

  @override
  String toString() => 'Coordinates($latitude, $longitude, alt: $altitude m)';
}
