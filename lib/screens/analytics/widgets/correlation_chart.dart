import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/repositories/analytics_repository.dart';

class CorrelationChart extends StatelessWidget {
  final List<CorrelationPoint> points;
  final String trackerFieldLabel;

  const CorrelationChart({
    super.key,
    required this.points,
    required this.trackerFieldLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Log tracker entries + journal entries on the same days to see correlations',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),
        ),
      );
    }

    final spots = points.map((p) {
      return FlSpot(p.trackerValue, p.mood.toDouble());
    }).toList();

    final maxX = points.map((p) => p.trackerValue).reduce((a, b) => a > b ? a : b);
    final minX = points.map((p) => p.trackerValue).reduce((a, b) => a < b ? a : b);

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
            'TRACKER vs MOOD',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$trackerFieldLabel vs Mood (${points.length} data points)',
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ScatterChart(
              ScatterChartData(
                scatterSpots: spots
                    .map((s) => ScatterSpot(
                          s.x,
                          s.y,
                          dotPainter: FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.accentGold.withAlpha(180),
                            strokeWidth: 0,
                          ),
                        ))
                    .toList(),
                minX: minX - 1,
                maxX: maxX + 1,
                minY: 0.5,
                maxY: 5.5,
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: AppColors.surfaceBright, strokeWidth: 0.5),
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final moods = ['', '😢', '😕', '😐', '😊', '🔥'];
                        final i = value.toInt();
                        if (i < 1 || i > 5) return const SizedBox.shrink();
                        return Text(moods[i],
                            style: const TextStyle(fontSize: 12));
                      },
                      interval: 1,
                      reservedSize: 28,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      trackerFieldLabel,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 10,
                        color: AppColors.textHint,
                      ),
                    ),
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
