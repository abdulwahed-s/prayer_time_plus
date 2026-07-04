# Changelog

## 0.1.0

Initial release.

- Prayer-time engine: Julian day, sun position, single-pass solar-angle
  computation, adjust pipeline, four high-latitude rules, and nearest-minute
  rounding.
- `PrayerTimes` with `today()`, per-prayer `DateTime`s, and
  `currentPrayer`/`nextPrayer`/`timeForPrayer`.
- 50+ `CalculationMethod` presets with a customisable `CalculationParameters`
  (Fajr/Isha angles or intervals, Maghrib interval, per-prayer offsets,
  madhab, high-latitude rule).
- `Madhab` (Shafi/Hanafi) Asr and per-prayer minute tuning.
- `AutoMethod.forCountry` for ISO country-based method resolution.
- `SunnahTimes` night portions.
- Umm al-Qura Ramadan Isha rule.
- Command-line demo (`dart run prayer_time_plus`) and a runnable example.
- Pure Dart, zero runtime dependencies.
