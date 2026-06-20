import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/models/custom_tracker.dart';
import 'package:apexforge/widgets/apex_badge_chip.dart';

class TrackerCard extends StatelessWidget {
  final CustomTracker tracker;
  final VoidCallback? onTap;

  const TrackerCard({super.key, required this.tracker, this.onTap});

  Color get _trackerColor {
    try {
      return Color(
          int.parse(tracker.colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _trackerColor;
    final domainLabel =
        AppConstants.domainLabels[tracker.domain] ?? tracker.domain;
    final domainColor = _domainColor(tracker.domain);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: color, width: 3),
            top: const BorderSide(color: AppColors.surfaceBright, width: 0.5),
            right:
                const BorderSide(color: AppColors.surfaceBright, width: 0.5),
            bottom:
                const BorderSide(color: AppColors.surfaceBright, width: 0.5),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(tracker.emoji,
                    style: const TextStyle(fontSize: 22)),
                const Spacer(),
                ApexBadgeChip(label: domainLabel, color: domainColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tracker.name,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to view entries',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
            const Spacer(),
            _SevenDaySparkline(tracker: tracker),
          ],
        ),
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

class _SevenDaySparkline extends StatelessWidget {
  final CustomTracker tracker;

  const _SevenDaySparkline({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      return AppDateUtils.startOfDay(now.subtract(Duration(days: 6 - i)));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }).toList(),
    );
  }
}
