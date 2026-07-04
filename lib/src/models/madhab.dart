/// Juristic school used for the Asr calculation.
///
/// Asr falls when an object's shadow equals its noon shadow plus
/// [shadowFactor] times the object's height.
enum Madhab {
  /// Standard rule (Shafi'i, Maliki, Hanbali): shadow factor 1.
  shafi,

  /// Hanafi rule: shadow factor 2 (a later Asr).
  hanafi;

  /// The Asr shadow-length factor for this madhab.
  ///
  /// Derived as `index + 1`, so the declaration order above is significant.
  int get shadowFactor => index + 1;
}
