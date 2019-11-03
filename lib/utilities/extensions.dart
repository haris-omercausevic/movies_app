class Extensions {
  static int getLengthOrDefault(Iterable value) => value?.length ?? 0;

  static bool isListNullOrEmpty(Iterable value) => value == null || value.isEmpty;
  static bool isStringNullOrEmpty(String value) => value == null || value.isEmpty;
  static bool areDatesEqual(DateTime left, DateTime right) => left.year == right.year && left.month == right.month && left.day == right.day;

  static DateTime getWithMinimumTime(DateTime value) => DateTime(value.year, value.month, value.day, 0, 0, 0, 0);
  static DateTime getWithMaximumTime(DateTime value) => DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
}
