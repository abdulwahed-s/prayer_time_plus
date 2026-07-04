# Calculation methods

Every `CalculationMethod` preset and the exact parameters it applies. For the
overall algorithm and API, see the [README](../README.md).

## How a method is applied

For a date and location the engine derives the sun's position and then places
each prayer:

- **Fajr** and **Isha** occur when the sun is a set angle *below* the horizon.
  Each method defines those twilight angles. A few authorities instead define
  **Isha as a fixed interval** — a number of minutes after Maghrib (for
  example Umm al-Qura's 90 minutes).
- **Sunrise** and **Sunset** occur at the horizon, with a standard refraction
  allowance of 0.833°. A handful of methods/countries add an altitude
  (elevation) correction of `0.0347 × √altitude` degrees.
- **Dhuhr** is solar noon.
- **Asr** is when an object's shadow reaches `factor +` its noon shadow, where
  `factor` is 1 for the standard madhab and 2 for Hanafi.
- **Maghrib** is always derived from Sunset (Sunset + the method's Maghrib
  offset, plus an interval for methods that use one).

Each method also carries **per-prayer minute offsets** published by its
authority. In the table these appear in the "Other offsets" column; Maghrib is
shown relative to Sunset, and Isha as an angle or an interval after Maghrib.

Angles are degrees below the horizon. "sunset ± N" and "+N min" are minutes.

## Parameters by method

| Method | Fajr | Maghrib | Isha | Other offsets (min) |
|---|---|---|---|---|
| `muslimWorldLeague` | 18° | sunset | 17° | — |
| `egyptian` | 19.5° | sunset | 17.5° | — |
| `karachi` | 18° | sunset | 18° | — |
| `ummAlQura` | 18.5° | sunset | Maghrib + 90 min¹ | — |
| `northAmerica` | 15° | sunset | 15° | — |
| `emirates` | 18.5° | sunset + 2 | 18.5° − 3 min | Fajr +1, Sunrise −4, Dhuhr +2 |
| `dubai` | 18° | sunset | 17° | — (falls back to MWL) |
| `qatar` | 18° | sunset + 2 | Maghrib + 90 min | — |
| `kuwait` | 18° | sunset | 17.5° | — |
| `oman` | 18° | sunset + 5 | 18° + 1 min | Dhuhr +5, Asr +5 |
| `omanMuscat` | 17.74° | sunset + 6 | 18.229° | Sunrise +1, Dhuhr +6, Asr +6 |
| `jordan` | 18.12° | sunset + 1 | 17.975° | — |
| `palestine` | 20.11° | sunset + 4 | 17.9° | Fajr −5 |
| `syria` | 19.5° | sunset | 17.5° | — |
| `iraq` | 18° | sunset + 2 | 17° | Dhuhr +5, Asr +3 |
| `morocco` | 19.09° | sunset + 3 | 17° | Sunrise −2, Dhuhr +5 |
| `azrou` | 19.1° | sunset + 1 | 17° | Sunrise −1, Dhuhr +5 |
| `algeria` | 18° | sunset + 3 | 17° | — |
| `tunisia` | 18° | sunset + 1 | 18° + 1 min | Fajr −1, Dhuhr +7 |
| `libya` | 18.3° | sunset + 4 | 18.35° | Dhuhr +4 |
| `sudan` | 18.12° | sunset − 4 | 17.88° | Sunrise +3, Dhuhr +3 |
| `turkey` | 18° | sunset + 5 | 16.93° | Sunrise −6, Dhuhr +6, Asr +4 |
| `malaysia` | 20° | sunset | 18° | Dhuhr +1 |
| `malaysia2` | 20° | sunset + 1 | 18.46° | Dhuhr +3, Asr +2 |
| `indonesia` | 20° | sunset + 2 | 18° + 2 min | Fajr +2, Sunrise −2, Dhuhr +2, Asr +2 |
| `kazakhstan` | 14.97° | sunset | 14.96° | Dhuhr +5, Asr +5 |
| `tajikistan` | 18° | sunset | 18° | — |
| `maldives` | 19° | sunset + 1 | 19° + 1 min | Fajr −1, Dhuhr +4, Asr +1 |
| `southKorea` | 18° | sunset | 18° − 6 min | Fajr +1, Sunrise −1 |
| `uoif` | 12° | sunset + 4 | 12° + 5 min | Fajr −5, Dhuhr +5 |
| `paris` | 12° | sunset + 4 | 12° + 5 min | Fajr −5, Dhuhr +5 |
| `toulouse` | 12° | sunset + 4 | 12° + 5 min | Fajr −5, Dhuhr +5 |
| `lyon` | 12° | sunset + 4 | 12° + 5 min | Fajr −5, Dhuhr +5 |
| `orleans` | 15° | sunset | 12.34° | Dhuhr +5 |
| `moscow` | 16° | sunset + 1 | 15.1° + 2 min | Dhuhr +1, Asr +1 |
| `czech` | 12.04° | sunset − 2 | 12.04° | Dhuhr +5 |
| `switzerland` | 17.99° | sunset − 4 | Maghrib + 100 min | Fajr +1, Sunrise +4 |
| `fribourg` | 18.01° | sunset − 5 | Maghrib + 100 min | Fajr +1, Sunrise +5 |
| `belgium` | 18° | sunset | 18° | — |
| `luxembourg` | 18° | sunset | 17° | — |
| `austria` | 18° | sunset | 17° | — |
| `london` | 18° | sunset | 17° | — |
| `birmingham` | 18° | sunset | 17° | — |
| `blackburn` | 18° | sunset | 17° | — |
| `aachen` | 18° | sunset | 17° | — |
| `munchen` | 18° | sunset | 17° | — |
| `potsdam` | 18° | sunset | 17° | — |
| `nurnberg` | 18° | sunset | 17° | — |
| `rotterdam` | 15° | sunset | 15° | — |
| `dordrecht` | 15° | sunset | 15° | — |
| `eindhoven` | 15° | sunset | 15° | — |
| `montreal` | 15° | sunset | 15° | — |
| `windsor` | 15° | sunset | 15° | — |
| `calgary` | 15° | sunset | 15° | — |
| `mississauga` | 15° | sunset | 15° | — |
| `other` | 18° | sunset | 17° | — (blank preset to customise) |

¹ `ummAlQura` extends Isha to Maghrib + 120 min during Ramadan when the
`countryCode` is `SA` and `params.isRamadan` is set.

## Related settings

- **Madhab** — `Madhab.shafi` (Asr shadow factor 1) or `Madhab.hanafi`
  (factor 2, a later Asr). Independent of the method.
- **High-latitude rule** — `none`, `middleOfTheNight`, `seventhOfTheNight`, or
  `twilightAngle`, for places where the sun never reaches the twilight angle.
- **Elevation** — the `morocco`, `iraq`, `tunisia`, `jordan`, `orleans`,
  `sudan`, `belgium`, and `kazakhstan` methods (and locations in `PS`, `IL`,
  `CZ`, `CH`) add the altitude correction to Sunrise/Sunset.
- **Custom** — build any configuration with the `CalculationParameters`
  constructor, or start from `CalculationMethod.other`.
