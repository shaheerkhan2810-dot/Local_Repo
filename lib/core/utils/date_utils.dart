import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool isToday(DateTime date) => isSameDay(date, DateTime.now());

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  static int daysBetween(DateTime from, DateTime to) {
    final f = startOfDay(from);
    final t = startOfDay(to);
    return t.difference(f).inDays;
  }

  static int streakDays(DateTime startDate) {
    return daysBetween(startDate, DateTime.now());
  }

  /// Returns "2h 34m" or "45s" format
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    } else if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds.remainder(60);
      if (seconds > 0) return '${minutes}m ${seconds}s';
      return '${minutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Returns "25:00" format for pomodoro timer
  static String formatMMSS(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatDate(DateTime date) =>
      DateFormat('MMM d, yyyy').format(date);

  static String formatDateShort(DateTime date) =>
      DateFormat('MMM d').format(date);

  static String formatDateVeryShort(DateTime date) =>
      DateFormat('d MMM').format(date);

  static String formatTime(DateTime date) =>
      DateFormat('h:mm a').format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat('MMM d, yyyy • h:mm a').format(date);

  static String formatRelative(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isYesterday(date)) return 'Yesterday';
    final diff = daysBetween(date, DateTime.now());
    if (diff <= 7) return '$diff days ago';
    return formatDate(date);
  }

  static String formatStreakDuration(int days) {
    if (days == 0) return '0 days';
    if (days == 1) return '1 day';
    if (days < 30) return '$days days';
    if (days < 365) {
      final months = (days / 30).floor();
      final remaining = days % 30;
      if (remaining == 0) return '$months month${months > 1 ? 's' : ''}';
      return '$months month${months > 1 ? 's' : ''} $remaining day${remaining > 1 ? 's' : ''}';
    }
    final years = (days / 365).floor();
    final remaining = days % 365;
    if (remaining == 0) return '$years year${years > 1 ? 's' : ''}';
    return '$years year${years > 1 ? 's' : ''} ${(remaining / 30).floor()} month${(remaining / 30).floor() > 1 ? 's' : ''}';
  }

  /// Get list of the last N days as DateTime (start of day)
  static List<DateTime> lastNDays(int n) {
    final now = startOfDay(DateTime.now());
    return List.generate(n, (i) => now.subtract(Duration(days: n - 1 - i)));
  }

  /// Get list of dates in the current week (Mon–Sun)
  static List<DateTime> currentWeek() {
    final now = startOfDay(DateTime.now());
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }
}
