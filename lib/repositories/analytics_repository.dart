import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/relapse_event.dart';
import '../models/tracker_entry.dart';
import '../models/journal_entry.dart';
import '../models/task_model.dart';
import '../core/constants/firestore_paths.dart';
import '../core/utils/date_utils.dart';

class CorrelationPoint {
  final DateTime date;
  final double trackerValue;
  final int mood;

  const CorrelationPoint({
    required this.date,
    required this.trackerValue,
    required this.mood,
  });
}

class WeeklyReport {
  final int tasksCompleted;
  final int tasksCompletedLastWeek;
  final int xpEarned;
  final int journalDays;
  final int trackerDays;
  final int streakDays;
  final double avgMood;
  final String motivationalMessage;

  const WeeklyReport({
    required this.tasksCompleted,
    required this.tasksCompletedLastWeek,
    required this.xpEarned,
    required this.journalDays,
    required this.trackerDays,
    required this.streakDays,
    required this.avgMood,
    required this.motivationalMessage,
  });
}

class AnalyticsRepository {
  final FirebaseFirestore _firestore;

  AnalyticsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Returns a map of date → streak day count (0 = not active / relapse)
  Future<Map<DateTime, int>> getStreakHeatmapData(
    String uid, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Map<DateTime, int> result = {};

    // Get relapses in range
    final relapseSnap = await _firestore
        .collection(FirestorePaths.relapses(uid))
        .where('occurredAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('occurredAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    final relapses = relapseSnap.docs
        .map((d) => RelapseEvent.fromFirestore(d))
        .toList();

    // Mark relapse days as -1
    for (final r in relapses) {
      final day = AppDateUtils.startOfDay(r.occurredAt);
      result[day] = -1;
    }

    // Fill in streak days
    final now = DateTime.now();
    final days = AppDateUtils.daysBetween(startDate, now);
    for (int i = 0; i <= days; i++) {
      final day = AppDateUtils.startOfDay(
          startDate.add(Duration(days: i)));
      if (!result.containsKey(day)) {
        result[day] = i + 1;
      }
    }

    return result;
  }

  Future<List<CorrelationPoint>> getCorrelationData(
    String uid,
    String trackerId,
    String fieldId, {
    int limitDays = 90,
  }) async {
    final from = DateTime.now().subtract(Duration(days: limitDays));

    final entriesSnap = await _firestore
        .collection(FirestorePaths.trackerEntries(uid, trackerId))
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .orderBy('date')
        .get();

    final journalSnap = await _firestore
        .collection(FirestorePaths.journalEntries(uid))
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .orderBy('date')
        .get();

    final moodByDay = <DateTime, int>{};
    for (final doc in journalSnap.docs) {
      final entry = JournalEntry.fromFirestore(doc);
      final day = AppDateUtils.startOfDay(entry.date);
      moodByDay[day] = entry.mood;
    }

    final points = <CorrelationPoint>[];
    for (final doc in entriesSnap.docs) {
      final entry = TrackerEntry.fromFirestore(doc);
      final day = AppDateUtils.startOfDay(entry.date);
      final mood = moodByDay[day];
      final value = entry.values[fieldId];
      if (mood != null && value != null) {
        final numValue = double.tryParse(value.toString());
        if (numValue != null) {
          points.add(CorrelationPoint(
            date: day,
            trackerValue: numValue,
            mood: mood,
          ));
        }
      }
    }

    return points;
  }

  Future<WeeklyReport> getWeeklyReport(String uid, int currentStreakDays) async {
    final thisWeekStart = DateTime.now().subtract(const Duration(days: 7));
    final lastWeekStart = DateTime.now().subtract(const Duration(days: 14));
    final lastWeekEnd = thisWeekStart;

    // Tasks this week
    final tasksSnap = await _firestore
        .collection(FirestorePaths.tasks(uid))
        .where('isCompleted', isEqualTo: true)
        .where('completedAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(thisWeekStart))
        .get();

    // Tasks last week
    final tasksLastSnap = await _firestore
        .collection(FirestorePaths.tasks(uid))
        .where('isCompleted', isEqualTo: true)
        .where('completedAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(lastWeekStart))
        .where('completedAt',
            isLessThanOrEqualTo: Timestamp.fromDate(lastWeekEnd))
        .get();

    // Journal entries this week
    final journalSnap = await _firestore
        .collection(FirestorePaths.journalEntries(uid))
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(thisWeekStart))
        .get();

    final journalEntries = journalSnap.docs
        .map((d) => JournalEntry.fromFirestore(d))
        .toList();

    final avgMood = journalEntries.isEmpty
        ? 3.0
        : journalEntries.map((e) => e.mood).reduce((a, b) => a + b) /
            journalEntries.length;

    final xpEarned = journalEntries.fold<int>(
          0, (sum, e) => sum + e.xpAwarded) +
        (tasksSnap.docs
            .map((d) => TaskModel.fromFirestore(d))
            .fold<int>(0, (sum, t) => sum + t.xpReward));

    String message;
    if (tasksSnap.docs.length >= tasksLastSnap.docs.length) {
      message = 'You crushed it this week. Keep the momentum going!';
    } else {
      message = 'Rough week? That\'s okay. Warriors rise again.';
    }

    return WeeklyReport(
      tasksCompleted: tasksSnap.docs.length,
      tasksCompletedLastWeek: tasksLastSnap.docs.length,
      xpEarned: xpEarned,
      journalDays: journalEntries.length,
      trackerDays: 0,
      streakDays: currentStreakDays,
      avgMood: avgMood,
      motivationalMessage: message,
    );
  }
}
