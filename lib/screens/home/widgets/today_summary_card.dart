import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/providers/task_provider.dart';
import 'package:apexforge/providers/journal_provider.dart';
import 'package:apexforge/providers/streak_provider.dart';
import 'package:apexforge/widgets/apex_card.dart';

class TodaySummaryCard extends ConsumerWidget {
  const TodaySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysTasks = ref.watch(todaysTasksProvider);
    final journalEntries = ref.watch(journalEntriesProvider).value ?? [];
    final streakDays = ref.watch(currentStreakDaysProvider);

    final completedTasks = todaysTasks.where((t) => t.isCompleted).length;
    final totalTasks = todaysTasks.length;

    final today = DateTime.now();
    final hasEntryToday = journalEntries.any(
      (e) => AppDateUtils.isToday(e.date),
    );

    return ApexCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TODAY'S PROGRESS",
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentGold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MetricTile(
                emoji: '✅',
                value: '$completedTasks/$totalTasks',
                label: 'Tasks',
              ),
              _MetricTile(
                emoji: hasEntryToday ? '📓' : '📔',
                value: hasEntryToday ? 'Done' : 'None',
                label: 'Journal',
              ),
              _MetricTile(
                emoji: '🔥',
                value: '$streakDays',
                label: 'Streak',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;

  const _MetricTile({
    required this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.accentGold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
