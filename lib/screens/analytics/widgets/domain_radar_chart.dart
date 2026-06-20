import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';

class DomainRadarChart extends StatelessWidget {
  final Map<String, int> domainXp;

  const DomainRadarChart({super.key, required this.domainXp});

  @override
  Widget build(BuildContext context) {
    final total = domainXp.values.fold(0, (a, b) => a + b);
    if (total == 0) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No XP earned yet across domains',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),
        ),
      );
    }

    final maxVal = domainXp.values.reduce((a, b) => a > b ? a : b).toDouble();

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
            'DOMAIN RADAR',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                ticksTextStyle: TextStyle(fontSize: 0, color: Colors.transparent),
                getTitle: (i, angle) {
                  final domains = AppConstants.allDomains;
                  if (i >= domains.length) return RadarChartTitle(text: '');
                  final emoji = AppConstants.domainEmojis[domains[i]] ?? '';
                  return RadarChartTitle(
                    text: emoji,
                    angle: 0,
                  );
                },
                titleTextStyle: const TextStyle(fontSize: 16),
                tickCount: 4,
                radarBackgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                gridBorderData: BorderSide(
                    color: AppColors.surfaceBright, width: 0.5),
                tickBorderData: BorderSide(
                    color: AppColors.surfaceBright, width: 0.5),
                dataSets: [
                  RadarDataSet(
                    dataEntries: AppConstants.allDomains.map((d) {
                      final xp = domainXp[d]?.toDouble() ?? 0;
                      return RadarEntry(value: maxVal > 0 ? xp / maxVal : 0);
                    }).toList(),
                    borderColor: AppColors.accentGold,
                    fillColor: AppColors.accentGold.withAlpha(40),
                    borderWidth: 2,
                    entryRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Domain XP breakdown
          ...AppConstants.allDomains.map((d) {
            final xp = domainXp[d] ?? 0;
            final pct = maxVal > 0 ? xp / maxVal : 0.0;
            final color = _domainColor(d);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(
                    AppConstants.domainEmojis[d] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 72,
                    child: Text(
                      AppConstants.domainLabels[d] ?? d,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct.toDouble(),
                        backgroundColor: AppColors.surfaceBright,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$xp XP',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _domainColor(String domain) {
    switch (domain) {
      case AppConstants.domainDiscipline:
        return AppColors.domainDiscipline;
      case AppConstants.domainBody:
        return AppColors.domainBody;
      case AppConstants.domainMind:
        return AppColors.domainMind;
      case AppConstants.domainWealth:
        return AppColors.domainWealth;
      default:
        return AppColors.primaryGreen;
    }
  }
}
