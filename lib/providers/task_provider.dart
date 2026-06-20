import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/task_repository.dart';
import '../models/task_model.dart';
import '../core/utils/date_utils.dart';
import '../core/constants/app_constants.dart';
import 'user_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final taskListProvider = StreamProvider<List<TaskModel>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return const Stream.empty();
  return ref.watch(taskRepositoryProvider).watchTasks(uid);
});

final todaysTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(taskListProvider).value ?? [];
  final today = DateTime.now();
  return tasks.where((t) {
    if (t.isCompleted && !AppDateUtils.isToday(t.completedAt ?? DateTime(2000))) {
      return false;
    }
    if (t.dueDate != null && AppDateUtils.isToday(t.dueDate!)) return true;
    if (t.isRecurring) return _matchesRecurrence(t, today);
    if (!t.isCompleted && t.dueDate == null) return true;
    return false;
  }).toList();
});

bool _matchesRecurrence(TaskModel task, DateTime date) {
  final rule = task.recurrenceRule;
  if (rule == null) return false;
  if (rule == 'daily') return true;
  if (rule.startsWith('weekly:')) {
    final days = rule.substring(7).split(',');
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = dayNames[date.weekday - 1];
    return days.contains(dayName);
  }
  if (rule.startsWith('monthly:')) {
    final dayOfMonth = int.tryParse(rule.substring(8));
    return dayOfMonth == date.day;
  }
  return false;
}

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _repo;
  final String uid;

  TaskNotifier(this._repo, this.uid) : super(const AsyncValue.data(null));

  Future<String?> createTask(TaskModel task) async {
    state = const AsyncValue.loading();
    try {
      final id = await _repo.createTask(uid, task);
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    await _repo.updateTask(uid, task);
  }

  Future<void> toggleComplete(String taskId, bool complete) async {
    await _repo.toggleComplete(uid, taskId, complete);
  }

  Future<void> deleteTask(String taskId) async {
    await _repo.deleteTask(uid, taskId);
  }

  Future<void> incrementPomodoro(String taskId) async {
    await _repo.incrementPomodoro(uid, taskId);
  }
}

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  final uid = ref.watch(currentUidProvider) ?? '';
  return TaskNotifier(ref.watch(taskRepositoryProvider), uid);
});

// Pomodoro timer — in-memory only, not persisted
enum PomodoroPhase { work, shortBreak, longBreak, idle }

class PomodoroState {
  final PomodoroPhase phase;
  final int secondsRemaining;
  final int completedPomodoros;
  final bool isRunning;
  final String? activeTaskId;

  const PomodoroState({
    this.phase = PomodoroPhase.idle,
    this.secondsRemaining = AppConstants.pomodoroWorkMinutes * 60,
    this.completedPomodoros = 0,
    this.isRunning = false,
    this.activeTaskId,
  });

  PomodoroState copyWith({
    PomodoroPhase? phase,
    int? secondsRemaining,
    int? completedPomodoros,
    bool? isRunning,
    String? activeTaskId,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isRunning: isRunning ?? this.isRunning,
      activeTaskId: activeTaskId ?? this.activeTaskId,
    );
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  Timer? _timer;

  PomodoroNotifier() : super(const PomodoroState());

  void start({String? taskId}) {
    if (state.phase == PomodoroPhase.idle) {
      state = PomodoroState(
        phase: PomodoroPhase.work,
        secondsRemaining: AppConstants.pomodoroWorkMinutes * 60,
        completedPomodoros: state.completedPomodoros,
        isRunning: true,
        activeTaskId: taskId,
      );
    } else {
      state = state.copyWith(isRunning: true);
    }
    _startTimer();
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    state = state.copyWith(isRunning: true);
    _startTimer();
  }

  void skip() {
    _timer?.cancel();
    _advancePhase();
  }

  void reset() {
    _timer?.cancel();
    state = const PomodoroState();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsRemaining <= 0) {
        _timer?.cancel();
        _advancePhase();
        return;
      }
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
    });
  }

  void _advancePhase() {
    if (state.phase == PomodoroPhase.work) {
      final completed = state.completedPomodoros + 1;
      final isLongBreak =
          completed % AppConstants.pomodorosBeforeLongBreak == 0;
      final breakSeconds = isLongBreak
          ? AppConstants.pomodoroLongBreak * 60
          : AppConstants.pomodoroBreakMinutes * 60;
      state = state.copyWith(
        phase: isLongBreak ? PomodoroPhase.longBreak : PomodoroPhase.shortBreak,
        secondsRemaining: breakSeconds,
        completedPomodoros: completed,
        isRunning: false,
      );
    } else {
      state = PomodoroState(
        phase: PomodoroPhase.work,
        secondsRemaining: AppConstants.pomodoroWorkMinutes * 60,
        completedPomodoros: state.completedPomodoros,
        isRunning: false,
        activeTaskId: state.activeTaskId,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier();
});
