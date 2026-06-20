extension DateTimeExt on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  int daysBetween(DateTime other) {
    return startOfDay.difference(other.startOfDay).inDays.abs();
  }
}
