// The 11-element parameter array for every calculation-method key,
// copied verbatim from the reference engine's method table.
//
// Column semantics:
//   [0] Fajr depression angle, degrees.
//   [1] Maghrib mode flag: 1 = interval (sunset + [2] minutes), 0 = angle
//       mode (the [2] angle is never used in the final time; Maghrib is
//       always derived from sunset).
//   [2] Maghrib parameter (minutes when [1] == 1).
//   [3] Isha mode flag: 1 = interval (Maghrib + [4] minutes), 0 = angle.
//   [4] Isha parameter (degrees when [3] == 0, minutes when [3] == 1).
//   [5..10] Baked-in minute offsets: Fajr, Sunrise, Dhuhr, Asr, Maghrib
//       (relative to sunset), Isha.
//

/// Parameter arrays keyed by method key.
const Map<String, List<double>> methodParams = {
  'mwl': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'custom': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'none': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'morocco': [19.09, 0, 0, 0, 17.0, 0, -2, 5, 0, 3, 0],
  'azrou': [19.1, 0, 0, 0, 17.0, 0, -1, 5, 0, 1, 0],
  'algeria': [18.0, 1, 3.0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'sudan': [18.12, 0, 0, 0, 17.88, 0, 3, 3, 0, -4, 0],
  'makkah': [18.5, 1, 0, 1, 90.0, 0, 0, 0, 0, 0, 0],
  'egypt': [19.5, 1, 0, 0, 17.5, 0, 0, 0, 0, 0, 0],
  'karachi': [18.0, 1, 0, 0, 18.0, 0, 0, 0, 0, 0, 0],
  'tunisia': [18.0, 1, 1.0, 0, 18.0, -1, 0, 7, 0, 0, 1],
  'turkey': [18.0, 0, 0, 0, 16.93, 0, -6, 6, 4, 5, 0],
  'malaysia': [20.0, 1, 0, 0, 18.0, 0, 0, 1, 0, 0, 0],
  'malaysia2': [20.0, 1, 0, 0, 18.46, 0, 0, 3, 2, 1, 0],
  'indonesia': [20.0, 1, 0, 0, 18.0, 2, -2, 2, 2, 2, 2],
  'palestine': [20.11, 0, 0, 0, 17.9, 0, -5, 0, 0, 4, 0],
  'oman': [18.0, 1, 5.0, 0, 18.0, 0, 0, 5, 5, 0, 1],
  'omanMuscat': [17.74, 0, 0, 0, 18.229, 0, 1, 6, 6, 6, 0],
  'kazakhstan': [14.97, 0, 0, 0, 14.96, 0, 0, 5, 5, 0, 0],
  'tajikistan': [18.0, 1, 0, 0, 18.0, 0, 0, 0, 0, 0, 0],
  'emirates': [18.5, 1, 2.0, 0, 18.5, 1, -4, 2, 0, 0, -3],
  'jordan': [18.12, 0, 0, 0, 17.975, 0, 0, 0, 0, 1, 0],
  'kuwait': [18.0, 1, 0, 0, 17.5, 0, 0, 0, 0, 0, 0],
  'qatar': [18.0, 1, 0, 1, 90.0, 0, 0, 0, 0, 2, 0],
  'libya': [18.3, 0, 0, 0, 18.35, 0, 0, 4, 0, 4, 0],
  'syria': [19.5, 1, 0, 0, 17.5, 0, 0, 0, 0, 0, 0],
  'iraq': [18.0, 0, 0, 0, 17.0, 0, 0, 5, 3, 2, 0],
  'maldives': [19.0, 1, 0, 0, 19.0, 0, -1, 4, 1, 1, 1],
  'moscow': [16.0, 0, 0, 0, 15.1, 0, 0, 1, 1, 1, 2],
  'blackburn': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'london': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'birmingham': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'aachen': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'munchen': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'potsdam': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'nurnberg': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'austria': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'belgium': [18.0, 0, 0, 0, 18.0, 0, 0, 0, 0, 0, 0],
  'luxembourg': [18.0, 1, 0, 0, 17.0, 0, 0, 0, 0, 0, 0],
  'czech': [12.04, 0, 0, 0, 12.04, 0, 0, 5, 0, -2, 0],
  'switzerland': [17.99, 0, 0, 1, 100.0, 1, 4, 0, 0, -4, 0],
  'fribourg': [18.01, 0, 0, 1, 100.0, 1, 5, 0, 0, -5, 0],
  'uoif': [12.0, 1, 0, 0, 12.0, -5, 0, 5, 0, 4, 5],
  'paris': [12.0, 1, 0, 0, 12.0, -5, 0, 5, 0, 4, 5],
  'toulouse': [12.0, 1, 0, 0, 12.0, -5, 0, 5, 0, 4, 5],
  'lyon': [12.0, 1, 0, 0, 12.0, -5, 0, 5, 0, 4, 5],
  'orleans': [15.0, 0, 0, 0, 12.34, 0, 0, 5, 0, 0, 0],
  'isna': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
  'montreal': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
  'windsor': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
  'calgary': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
  'mississauga': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
  'southkorea': [18.0, 1, 0, 0, 18.0, 1, -1, 0, 0, 0, -6],
  'rotterdam': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
  'dordrecht': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
  'eindhoven': [15.0, 1, 0, 0, 15.0, 0, 0, 0, 0, 0, 0],
};

/// Ultimate fallback when a key (and even `mwl`) is missing.
const List<double> fallbackParams = [18, 1, 0, 0, 17, 0, 0, 0, 0, 0, 0];

/// Returns the parameter array for [key], falling back to `mwl` and then to
/// [fallbackParams] for unknown keys (e.g. `dubai`, which has no row of its
/// own).
List<double> paramsForKey(String key) =>
    methodParams[key] ?? methodParams['mwl'] ?? fallbackParams;
