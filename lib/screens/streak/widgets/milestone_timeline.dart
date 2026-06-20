import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/providers/streak_provider.dart';

class MilestoneTimeline extends ConsumerWidget {
  const MilestoneTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(currentStreakDaysProvider);
    final nextMilestone = ref.watch(nextMilestoneDaysProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MILESTONES',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.accentGold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ...AppConstants.streakMilestones.map((milestone) {
          final isAchieved = days >= milestone;
          final isCurrent = nextMilestone == milestone;
          final label = AppConstants.milestoneLabels[milestone] ?? '$milestone Days';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                _MilestoneCircle(
                  isAchieved: isAchieved,
                  isCurrent: isCurrent,
                  days: milestone,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$milestone Day${milestone == 1 ? '' : 's'} — $label',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isAchieved
                              ? AppColors.accentGold
                              : isCurrent
                                  ? AppColors.primaryGreenBright
                                  : AppColors.textHint,
                        ),
                      ),
                      if (isAchieved)
                        const Text(
                          'Achieved ✓',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: AppColors.success,
                          ),
                        ),
                      if (isCurrent && !isAchieved)
                        Text(
                          '${milestone - days} days away',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: AppColors.primaryGreenBright,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _MilestoneCircle extends StatelessWidget {
  final bool isAchieved;
  final bool isCurrent;
  final int days;

  const _MilestoneCircle({
    required this.isAchieved,
    required this.isCurrent,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    if (isAchieved) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.accentGold,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: Colors.black, size: 18),
      );
    }

    if (isCurrent) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withAlpha(60),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryGreenBright, width: 2),
        ),
        child: Center(
          child: Text(
            '$days',
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreenBright,
            ),
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .scaleXY(begin: 1.0, end: 1.1, duration: 900.ms)
          .then()
          .scaleXY(begin: 1.1, end: 1.0, duration: 900.ms);
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfaceBright, width: 1.5),
      ),
      child: Center(
        child: Text(
          '$days',
          style: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 11,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
