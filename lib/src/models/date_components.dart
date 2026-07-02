/// A plain Gregorian calendar date (year, month, day) with no time of day
/// and no timezone.
///
/// ```dart
/// final date = DateComponents(2026, 6, 28);
/// final today = DateComponents.from(DateTime.now());
/// ```
class DateComponents {
  /// Creates a date from [year], [month] (1..12), and [day] (1..31).
  const DateComponents(this.year, this.month, this.day);

  /// Extracts the year, month, and day of [dateTime].
  factory DateComponents.from(DateTime dateTime) =>
      DateComponents(dateTime.year, dateTime.month, dateTime.day);

  /// Calendar year.
  final int year;

  /// Calendar month, 1 (January) through 12 (December).
  final int month;

  /// Day of the month, starting at 1.
  final int day;

  @override
  bool operator ==(Object other) =>
      other is DateComponents &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      'DateComponents($year-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')})';
}
