import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../repositories/streak_repository.dart';
import '../models/main_streak.dart';
import '../models/relapse_event.dart';
import '../models/urge_log.dart';
import '../core/utils/xp_calculator.dart';
import '../core/constants/app_constants.dart';
import 'user_provider.dart';
import 'auth_provider.dart';

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  return StreakRepository();
});

final mainStreakProvider = StreamProvider<MainStreak?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(streakRepositoryProvider).watchStreak(uid);
});

final currentStreakDaysProvider = Provider<int>((ref) {
  final streak = ref.watch(mainStreakProvider).value;
  if (streak == null || !streak.isActive) return 0;
  return streak.currentDays;
});

final nextMilestoneDaysProvider = Provider<int?>((ref) {
  final days = ref.watch(currentStreakDaysProvider);
  return XpCalculator.nextMilestoneDays(days);
});

final nextMilestoneLabelProvider = Provider<String?>((ref) {
  final next = ref.watch(nextMilestoneDaysProvider);
  if (next == null) return null;
  return AppConstants.milestoneLabels[next];
});

final milestoneProgressProvider = Provider<double>((ref) {
  final days = ref.watch(currentStreakDaysProvider);
  return XpCalculator.progressToNextMilestone(days);
});

final relapseHistoryProvider = StreamProvider<List<RelapseEvent>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(streakRepositoryProvider).watchRelapses(uid);
});

final urgeLogs30DayProvider = StreamProvider<List<UrgeLog>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(streakRepositoryProvider).watchUrgeLogs(uid, limitDays: 30);
});

class StreakNotifier extends StateNotifier<AsyncValue<void>> {
  final StreakRepository _repo;
  final String uid;
  final Ref _ref;
  final _uuid = const Uuid();

  StreakNotifier(this._repo, this.uid, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> startStreak() async {
    state = const AsyncValue.loading();
    try {
      await _repo.startStreak(uid);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logRelapse({
    String? reason,
    String? triggerCategory,
    required int mood,
    String? notes,
    required int streakDaysBefore,
  }) async {
    state = const AsyncValue.loading();
    try {
      final relapse = RelapseEvent(
        id: _uuid.v4(),
        occurredAt: DateTime.now(),
        streakDaysBefore: streakDaysBefore,
        reason: reason,
        triggerCategory: triggerCategory,
        mood: mood,
        notes: notes,
      );
      await _repo.logRelapse(uid, relapse);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logUrge({
    required int intensity,
    String? trigger,
    int? durationMinutes,
    String? copingToolUsed,
    required bool overcame,
  }) async {
    try {
      final urge = UrgeLog(
        id: _uuid.v4(),
        loggedAt: DateTime.now(),
        intensity: intensity,
        trigger: trigger,
        durationMinutes: durationMinutes,
        copingToolUsed: copingToolUsed,
        overcame: overcame,
      );
      await _repo.logUrge(uid, urge);
    } catch (e) {
      // Non-critical — don't update state
    }
  }
}

final streakNotifierProvider =
    StateNotifierProvider<StreakNotifier, AsyncValue<void>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return StreakNotifier(ref.watch(streakRepositoryProvider), uid, ref);
});
