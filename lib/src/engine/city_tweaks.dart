// Hard-coded per-city minute tweaks applied by the `birmingham`, `paris`,
// and `belgium` methods after the offset step and before the high-latitude
// fallback. City names are matched after normalisation (trim, remove
// whitespace, lowercase); unmatched cities get no tweak.

// Exact fractional-hour literals per minute magnitude, kept bit-for-bit
// (they are not exactly n/60 at the last ulp).
const Map<int, double> _minuteHours = {
  0: 0.0,
  1: 0.0166666666666667,
  2: 0.0333333333333334,
  3: 0.0500000000000001,
  4: 0.0666666666666668,
  5: 0.08333333333333351,
  6: 0.1000000000000002,
  7: 0.1166666666666669,
  8: 0.1333333333333336,
  10: 0.16666666666666702,
  11: 0.1833333333333337,
  14: 0.2333333333333338,
};

double _hoursFor(int minutes) =>
    minutes < 0 ? -_minuteHours[-minutes]! : _minuteHours[minutes]!;

// Per-prayer deltas (minutes) in engine order
// [Fajr, Sunrise, Dhuhr, Asr, Sunset, Maghrib, Isha].
const List<int> _bradford = [-1, -1, -1, -3, 3, 3, 2];
const List<int> _glasgow = [6, 6, 6, 11, 5, 5, 5];
const List<int> _cardiff = [8, 8, 10, 1, 5, 5, 4];
const List<int> _liverpool = [4, 4, 4, 2, 8, 8, 7];
const List<int> _london = [-6, -6, -7, -4, -4, -4, -14];
const List<int> _luton = [-6, -6, -5, -4, -3, -3, 7];
const List<int> _newcastle = [-2, -2, -1, -7, -4, -4, -14];
const List<int> _middlesbrough = [-4, -4, -3, -1, 2, 2, 0];
const List<int> _manchester = [1, 1, 2, -1, -1, -1, 0];

const Map<String, List<int>> _birminghamDeltas = {
  'bradford': _bradford,
  'برادفورد': _bradford,
  'glasgow': _glasgow,
  'glaschu': _glasgow,
  'glesga': _glasgow,
  'غلازغو': _glasgow,
  'غلاسكو': _glasgow,
  'جلاسكو': _glasgow,
  'جلاسجو': _glasgow,
  'cardiff': _cardiff,
  'cardif': _cardiff,
  'كارديف': _cardiff,
  'liverpool': _liverpool,
  'ليفربول': _liverpool,
  'london': _london,
  'cityoflondon': _london,
  'thecity': _london,
  'thesquaremile': _london,
  'londres': _london,
  'citédelondres': _london,
  'لندن': _london,
  'مدينةلندن': _london,
  'المدينة': _london,
  'الميلالمربع': _london,
  'luton': _luton,
  'لوتون': _luton,
  'لوتن': _luton,
  'newcastle': _newcastle,
  'newcastleupontyne': _newcastle,
  'نيوكاسل': _newcastle,
  'نيوكاسلأبونتاين': _newcastle,
  'middlesbrough': _middlesbrough,
  'middlesborough': _middlesbrough,
  'ميدلزبرة': _middlesbrough,
  'ميدلزبره': _middlesbrough,
  'مدليسبره': _middlesbrough,
  'manchester': _manchester,
  'مانشستر': _manchester,
  'مانشيستر': _manchester,
  'منشيستر': _manchester,
  'منشستر': _manchester,
};

// Uniform delta (minutes) applied to all seven times.
const Map<String, int> _parisDeltas = {
  'melun': -1,
  'مولن': -1,
  'meaux': -2,
  'مو': -2,
  'vaux-le-pénil': -2,
  'vauxlepénil': -2,
  'châlons-en-champagne': -8,
  'chalons-en-champagne': -8,
  'châlonsenchampagne': -8,
  'chalonsenchampagne': -8,
  'châlons-sur-marne': -8,
  'chalons-sur-marne': -8,
  'châlonssurmarne': -8,
  'chalonssurmarne': -8,
  'شالونسورمارن': -8,
  'شالونأونكومباني': -8,
  'marne': -8,
  'المارن': -8,
  'مارن': -8,
  'chartres': 3,
  'شارتر': 3,
  'nogent-sur-seine': -5,
  'nogentsurseine': -5,
  'شالونسورسان': -5,
};

const Map<String, int> _belgiumDeltas = {
  'liège': -5,
  'liege': -5,
  'lidje': -5,
  'lüttich': -5,
  'لييج': -5,
  'luxembourg': -6,
  'luxemburg': -6,
  'لوكسمبورغ': -6,
  'verviers': -6,
  'vervî': -6,
  'فيرفييتوا': -6,
  'houthalen': -4,
  'houthalen-helchteren': -4,
  'اوتلان': -4,
  'hasselt': -4,
  'هاسلت': -4,
  'namur': -2,
  'nameur': -2,
  'namen': -2,
  'نامور': -2,
  'mons': 2,
  'bergen': 2,
  'montes': 2,
  'مونس': 2,
  'renaix': 3,
  'ronse': 3,
  'رنز': 3,
  'gent': 3,
  'ghent': 3,
  'gand': 3,
  'غنت': 3,
  'tournai': 4,
  'tornacum': 4,
  'doornik': 4,
  'تورناي': 4,
  'bruge': 4,
  'bruges': 4,
  'brugge': 4,
  'brügge': 4,
  'بروج': 4,
  'kortrijk': 4,
  'kortrik': 4,
  'kortryk': 4,
  'كورتريك': 4,
};

/// Normalises a city name the way the engine matches it: trimmed, all
/// whitespace removed, lowercased.
String normalizeCityName(String city) =>
    city.trim().replaceAll(RegExp(r'\s+'), '').toLowerCase();

/// Adds the per-city minute tweaks to [times] in place.
///
/// Active only for the `birmingham`, `paris`, and `belgium` methods; other
/// methods and unknown cities are left untouched.
void applyCityTweaks(
  List<double> times, {
  required String method,
  required String city,
}) {
  final name = normalizeCityName(city);
  switch (method) {
    case 'birmingham':
      final deltas = _birminghamDeltas[name];
      if (deltas != null) {
        for (var i = 0; i < times.length; i++) {
          times[i] += _hoursFor(deltas[i]);
        }
      }
    case 'paris':
      final delta = _parisDeltas[name];
      if (delta != null) {
        for (var i = 0; i < times.length; i++) {
          times[i] += _hoursFor(delta);
        }
      }
    case 'belgium':
      final delta = _belgiumDeltas[name];
      if (delta != null) {
        for (var i = 0; i < times.length; i++) {
          times[i] += _hoursFor(delta);
        }
      }
  }
}
