import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/providers/task_provider.dart';

class PomodoroTimerWidget extends ConsumerWidget {
  const PomodoroTimerWidget({super.key});

  String _phaseLabel(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return 'FOCUS';
      case PomodoroPhase.shortBreak:
        return 'SHORT BREAK';
      case PomodoroPhase.longBreak:
        return 'LONG BREAK';
      default:
        return '';
    }
  }

  int _totalSeconds(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return AppConstants.pomodoroWorkMinutes * 60;
      case PomodoroPhase.shortBreak:
        return AppConstants.pomodoroBreakMinutes * 60;
      case PomodoroPhase.longBreak:
        return AppConstants.pomodoroLongBreak * 60;
      default:
        return AppConstants.pomodoroWorkMinutes * 60;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);

    if (state.phase == PomodoroPhase.idle) return const SizedBox.shrink();

    final total = _totalSeconds(state.phase);
    final percent = state.secondsRemaining / total;

    return Container(
      color: AppColors.surface,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 24,
            lineWidth: 3,
            percent: percent.clamp(0.0, 1.0),
            progressColor: AppColors.accentGold,
            backgroundColor: AppColors.surfaceVariant,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _phaseLabel(state.phase),
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                AppDateUtils.formatMMSS(state.secondsRemaining),
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              state.isRunning
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: AppColors.textSecondary,
              size: 28,
            ),
            onPressed: () {
              if (state.isRunning) {
                notifier.pause();
              } else {
                notifier.resume();
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.skip_next_rounded,
              color: AppColors.textSecondary,
              size: 28,
            ),
            onPressed: notifier.skip,
          ),
        ],
      ),
    );
  }
}
