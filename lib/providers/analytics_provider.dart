import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/analytics_repository.dart';
import 'user_provider.dart';
import 'streak_provider.dart';

export '../repositories/analytics_repository.dart'
    show CorrelationPoint, WeeklyReport;

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

final streakHeatmapProvider =
    FutureProvider<Map<DateTime, int>>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return {};
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 364));
  return ref.watch(analyticsRepositoryProvider).getStreakHeatmapData(
        uid,
        startDate: start,
        endDate: end,
      );
});

final weeklyReportProvider = FutureProvider<WeeklyReport?>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return null;
  final streakDays = ref.watch(currentStreakDaysProvider);
  return ref
      .watch(analyticsRepositoryProvider)
      .getWeeklyReport(uid, streakDays);
});

final correlationProvider =
    FutureProvider.family<List<CorrelationPoint>, CorrelationParams>(
        (ref, params) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return [];
  return ref.watch(analyticsRepositoryProvider).getCorrelationData(
        uid,
        params.trackerId,
        params.fieldId,
      );
});

class CorrelationParams {
  final String trackerId;
  final String fieldId;
  const CorrelationParams({required this.trackerId, required this.fieldId});

  @override
  bool operator ==(Object other) =>
      other is CorrelationParams &&
      other.trackerId == trackerId &&
      other.fieldId == fieldId;

  @override
  int get hashCode => Object.hash(trackerId, fieldId);
}
