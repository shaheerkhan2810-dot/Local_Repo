import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/repositories/analytics_repository.dart';

class WeeklyReportCard extends StatelessWidget {
  final WeeklyReport report;

  const WeeklyReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final taskDiff = report.tasksCompleted - report.tasksCompletedLastWeek;
    final taskTrend = taskDiff >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'WEEKLY REPORT',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGold,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: taskTrend
                      ? AppColors.success.withAlpha(30)
                      : AppColors.error.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      taskTrend
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 14,
                      color: taskTrend ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      taskTrend
                          ? '+$taskDiff vs last week'
                          : '$taskDiff vs last week',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        color: taskTrend ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats grid
          Row(
            children: [
              _StatBox(
                  emoji: '✅',
                  label: 'Tasks Done',
                  value: '${report.tasksCompleted}'),
              const SizedBox(width: 10),
              _StatBox(
                  emoji: '⚡',
                  label: 'XP Earned',
                  value: '+${report.xpEarned}'),
              const SizedBox(width: 10),
              _StatBox(
                  emoji: '✍️',
                  label: 'Journal Days',
                  value: '${report.journalDays}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatBox(
                  emoji: '🔥',
                  label: 'Streak Days',
                  value: '${report.streakDays}'),
              const SizedBox(width: 10),
              _StatBox(
                  emoji: '😊',
                  label: 'Avg Mood',
                  value: report.avgMood.toStringAsFixed(1)),
              const SizedBox(width: 10),
              _StatBox(
                  emoji: '📊',
                  label: 'Tracker Days',
                  value: '${report.trackerDays}'),
            ],
          ),
          const SizedBox(height: 16),
          // Motivational message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.primaryGreen.withAlpha(80), width: 0.5),
            ),
            child: Row(
              children: [
                const Text('💬', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    report.motivationalMessage,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatBox(
      {required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.accentGold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
