/// Julian day for the Gregorian calendar date [year]-[month]-[day].
///
/// [month] is 1..12 and [day] is the day of month. No time-of-day or
/// timezone enters here; time is added later as a day fraction and the
/// longitude shift (`JD - lng/360`) is applied by the caller.
double julianDay(int year, int month, int day) {
  var y = year;
  var m = month;
  if (m <= 2) {
    y -= 1;
    m += 12;
  }
  // Gregorian century correction: 2 - A + floor(A / 4), A = floor(y / 100).
  final a = (y / 100).floorToDouble();
  return ((y + 4716) * 365.25).floorToDouble() +
      ((m + 1) * 30.6001).floorToDouble() +
      day +
      (2 - a + (a / 4).floorToDouble()) -
      1524.5;
}
