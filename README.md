# prayer_time_plus

[![pub package](https://img.shields.io/pub/v/prayer_time_plus.svg)](https://pub.dev/packages/prayer_time_plus)
[![pub points](https://img.shields.io/pub/points/prayer_time_plus)](https://pub.dev/packages/prayer_time_plus/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Islamic prayer times and Sunnah times for Dart and Flutter — computed offline
from solar geometry, with **zero runtime dependencies**.

> **Also available for [Swift](https://github.com/abdulwahed-s/prayer-time-plus-swift)
> and [Kotlin / JVM](https://github.com/abdulwahed-s/prayer-time-plus-kotlin).** All three
> are faithful ports of the same solar engine and compute identical times to the minute.
> See [Other platforms](#other-platforms).

Give it a location, a date, and a UTC offset, and it returns the five daily
prayer times (plus Sunrise and Sunset). It ships 50+ calculation methods used
by authorities worldwide and can pick one automatically from a country code.

- Pure Dart: runs on Dart Native, Flutter, and Web. No assets, no network.
- Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha, and Sunset.
- Shafi and Hanafi Asr, four high-latitude rules, per-prayer minute tuning.
- Sunnah night portions and current/next prayer helpers.

## Install

```yaml
dependencies:
  prayer_time_plus: ^0.2.0
```

```dart
import 'package:prayer_time_plus/prayer_time_plus.dart';
```

## Quick start

```dart
final coordinates = Coordinates(24.3486, 56.6953, altitude: 5);
final params = CalculationMethod.oman.getParameters();

final times = PrayerTimes(
  coordinates,
  DateComponents(2026, 6, 28),
  params,
  utcOffset: Duration(hours: 4),
);

print(times.fajr);    // dawn
print(times.maghrib); // sunset prayer
```

## How it works

The times come from the sun's position, not a lookup table, so any date and
place on Earth works offline.

For the given date the engine computes the **Julian day**, then the sun's
**declination** and the **equation of time**. From those it finds:

- **Dhuhr** — solar noon, when the sun crosses the meridian.
- **Sunrise** and **Sunset** — when the sun sits on the horizon (with a small
  refraction allowance, and an optional altitude correction).
- **Fajr** and **Isha** — when the sun is a certain angle *below* the horizon
  before dawn and after dusk. Each calculation method defines those twilight
  angles (or, for some authorities, a fixed number of minutes).
- **Asr** — when an object's shadow reaches a set multiple of its length; the
  multiple is 1 for the standard madhab and 2 for Hanafi.

**Maghrib** is taken from Sunset, and **Isha** is either its twilight angle or
a fixed interval after Maghrib. Each method also carries small per-prayer
minute offsets published by its authority. Finally the times are shifted to
the local clock using your UTC offset, adjusted at high latitudes where
twilight may not occur, and rounded to the nearest minute.

## Reading the results

Each time is a `DateTime` whose fields are the **local wall-clock time** at
your `utcOffset` — so `times.fajr!.hour` is the local hour. The instances are
flagged UTC so they never depend on the host machine's timezone; **don't call
`toLocal()`** on them. For the true instant, use
`times.fajr!.subtract(times.utcOffset)`. A time is `null` only when the sun
never reaches the required angle and the high-latitude rule leaves it
undefined.

```dart
String hhmm(DateTime? t) => t == null
    ? '--:--'
    : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
```

## Calculation methods

Pick a preset and call `getParameters()`:

```dart
final params = CalculationMethod.muslimWorldLeague.getParameters();
```

The most widely used methods, by their twilight angles:

| Method | Fajr | Isha |
|---|---|---|
| `muslimWorldLeague` | 18° | 17° |
| `egyptian` | 19.5° | 17.5° |
| `karachi` | 18° | 18° |
| `ummAlQura` | 18.5° | 90 min after Maghrib |
| `northAmerica` (ISNA) | 15° | 15° |
| `dubai` | 18° | 17° |
| `qatar` | 18° | 90 min after Maghrib |
| `kuwait` | 18° | 17.5° |
| `turkey` | 18° | 16.93° |

### All presets

- **Global** — `muslimWorldLeague`, `egyptian`, `karachi`, `ummAlQura`,
  `northAmerica`
- **Gulf** — `emirates`, `dubai`, `qatar`, `kuwait`, `oman`, `omanMuscat`
- **Levant & Iraq** — `jordan`, `palestine`, `syria`, `iraq`
- **North Africa** — `morocco`, `azrou`, `algeria`, `tunisia`, `libya`,
  `sudan`
- **Asia** — `turkey`, `malaysia`, `malaysia2`, `indonesia`, `kazakhstan`,
  `tajikistan`, `maldives`, `southKorea`
- **Europe** — `uoif`, `paris`, `toulouse`, `lyon`, `orleans`, `moscow`,
  `czech`, `switzerland`, `fribourg`, `belgium`, `luxembourg`, `austria`,
  `london`, `birmingham`, `blackburn`, `aachen`, `munchen`, `potsdam`,
  `nurnberg`, `rotterdam`, `dordrecht`, `eindhoven`
- **Americas** — `montreal`, `windsor`, `calgary`, `mississauga`
- **Custom** — `other`

Each preset bakes in its authority's angles and per-prayer minute offsets. For
every method's exact angles, Maghrib/Isha rules, offsets, and how each is
computed, see **[doc/calculation_methods.md](doc/calculation_methods.md)**. Use
`CalculationMethod.other` (or the `CalculationParameters` constructor) to
define your own.

## Customizing

```dart
final params = CalculationMethod.muslimWorldLeague.getParameters()
  ..madhab = Madhab.hanafi                              // later Asr
  ..highLatitudeRule = HighLatitudeRule.seventhOfTheNight
  ..adjustments.fajr = 2                                // your own minute tuning
  ..adjustments.isha = -3;
```

- **`madhab`** — `Madhab.shafi` (shadow factor 1, the standard for Shafi'i,
  Maliki, and Hanbali) or `Madhab.hanafi` (factor 2).
- **`highLatitudeRule`** — `automatic`, `none`, `middleOfTheNight`,
  `seventhOfTheNight`, or `twilightAngle`, for places where the sun may not
  reach the twilight angle. `automatic` first tries unadjusted angle-based
  times, then recomputes with `seventhOfTheNight` if Fajr or Isha come out
  degenerate. Use `none` to never apply a fallback.
- **`adjustments`** — your per-prayer minute offsets, applied on top of the
  method's own.

## Auto method resolution

```dart
final method = AutoMethod.forCountry('OM'); // CalculationMethod.oman
```

Covers every ISO-3166 country code and falls back to Muslim World League for
unknown ones.

## Current and next prayer

```dart
times.currentPrayer(); // e.g. Prayer.dhuhr
times.nextPrayer();    // e.g. Prayer.asr
times.timeForPrayer(Prayer.asr);
```

Both take an optional instant and default to now.

## Sunnah times

```dart
final sunnah = SunnahTimes(times);
print(sunnah.middleOfTheNight);
print(sunnah.lastThirdOfTheNight);
```

## Command line

```
dart run prayer_time_plus
```

Prints today's times and the current/next prayer for a sample location.

## Other platforms

The same solar engine, ported idiomatically to three ecosystems — identical
results to the minute:

| Platform | Package | Repository |
|---|---|---|
| **Dart / Flutter** — you are here | [`prayer_time_plus`](https://pub.dev/packages/prayer_time_plus) | [prayer_time_plus](https://github.com/abdulwahed-s/prayer_time_plus) |
| Swift · iOS, macOS, watchOS, tvOS, Linux | [Swift Package Index](https://swiftpackageindex.com/abdulwahed-s/prayer-time-plus-swift) | [prayer-time-plus-swift](https://github.com/abdulwahed-s/prayer-time-plus-swift) |
| Kotlin / JVM | [`io.github.abdulwahed-s:prayer-time-plus`](https://central.sonatype.com/artifact/io.github.abdulwahed-s/prayer-time-plus) | [prayer-time-plus-kotlin](https://github.com/abdulwahed-s/prayer-time-plus-kotlin) |

## License

MIT — see [LICENSE](LICENSE).
