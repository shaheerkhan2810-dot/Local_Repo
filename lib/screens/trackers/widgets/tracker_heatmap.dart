import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/tracker_entry.dart';
import 'package:apexforge/core/utils/date_utils.dart';

class TrackerHeatmap extends StatelessWidget {
  final List<TrackerEntry> entries;
  final int weeks;

  const TrackerHeatmap({
    super.key,
    required this.entries,
    this.weeks = 12,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: weeks * 7 - 1));

    final loggedDays = entries
        .map((e) => AppDateUtils.startOfDay(e.date))
        .toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIVITY',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.accentGold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: Row(
            children: List.generate(weeks, (weekIndex) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (dayIndex) {
                    final date = startDate.add(
                        Duration(days: weekIndex * 7 + dayIndex));
                    final isLogged = loggedDays
                        .contains(AppDateUtils.startOfDay(date));
                    final isToday = AppDateUtils.isToday(date);

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: isLogged
                              ? AppColors.primaryGreen
                              : AppColors.surfaceBright,
                          borderRadius: BorderRadius.circular(2),
                          border: isToday
                              ? Border.all(
                                  color: AppColors.accentGold, width: 1)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _Legend(color: AppColors.surfaceBright, label: 'No entry'),
            const SizedBox(width: 12),
            _Legend(color: AppColors.primaryGreen, label: 'Logged'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 10,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }
}
