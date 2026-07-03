/// Offline Islamic prayer times, Qibla direction, and Sunnah times.
///
/// Computes the six daily prayer times (Fajr, Sunrise, Dhuhr, Asr, Maghrib,
/// Isha) plus Sunset from coordinates, a date, and calculation parameters,
/// with 50+ regional calculation methods and zero runtime dependencies.
library;

export 'src/auto/auto_method.dart';
export 'src/methods/calculation_method.dart';
export 'src/methods/calculation_parameters.dart';
export 'src/models/coordinates.dart';
export 'src/models/date_components.dart';
export 'src/models/high_latitude_rule.dart';
export 'src/models/madhab.dart';
export 'src/models/prayer.dart';
export 'src/models/prayer_adjustments.dart';
export 'src/prayer_times.dart';
