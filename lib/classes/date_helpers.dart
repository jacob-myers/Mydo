// Idea from:
// https://stackoverflow.com/questions/54391477/check-if-datetime-variable-is-today-tomorrow-or-yesterday

extension DateHelpers on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }
}