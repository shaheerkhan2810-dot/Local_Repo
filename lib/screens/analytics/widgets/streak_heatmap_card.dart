import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/utils/date_utils.dart';

class StreakHeatmapCard extends StatelessWidget {
  final Map<DateTime, int> heatmapData;

  const StreakHeatmapCard({super.key, required this.heatmapData});

  @override
  Widget build(BuildContext context) {
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
          const Text(
            '365-DAY STREAK MAP',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          _HeatmapGrid(data: heatmapData),
          const SizedBox(height: 10),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _LegendItem(color: AppColors.error.withAlpha(180), label: 'Relapse'),
              const SizedBox(width: 12),
              _LegendItem(color: AppColors.surfaceBright, label: 'Off'),
              const SizedBox(width: 12),
              _LegendItem(color: AppColors.primaryGreen, label: 'Active'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  final Map<DateTime, int> data;

  const _HeatmapGrid({required this.data});

  Color _colorForValue(int? value) {
    if (value == null) return AppColors.surfaceBright;
    if (value == -1) return AppColors.error.withAlpha(180);
    if (value == 0) return AppColors.surfaceBright;
    final intensity = (value / 365.0).clamp(0.1, 1.0);
    return Color.lerp(
      AppColors.primaryGreen.withAlpha(80),
      AppColors.primaryGreen,
      intensity,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weeksCount = 52;
    final cellSize = (MediaQuery.of(context).size.width - 64) / weeksCount;

    return SizedBox(
      height: 7 * (cellSize + 1) + 1,
      child: Row(
        children: List.generate(weeksCount, (w) {
          return Column(
            children: List.generate(7, (d) {
              final dayOffset = (weeksCount - 1 - w) * 7 + (6 - d);
              final date = AppDateUtils.startOfDay(
                  now.subtract(Duration(days: dayOffset)));
              final value = data[date];

              return Container(
                width: cellSize,
                height: cellSize,
                margin: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  color: _colorForValue(value),
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

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
