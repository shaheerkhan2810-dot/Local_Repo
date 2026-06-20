import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/core/utils/xp_calculator.dart';
import 'package:apexforge/providers/user_provider.dart';

class XpDomainBar extends ConsumerWidget {
  const XpDomainBar({super.key});

  static const _domainColors = {
    AppConstants.domainDiscipline: AppColors.domainDiscipline,
    AppConstants.domainBody: AppColors.domainBody,
    AppConstants.domainMind: AppColors.domainMind,
    AppConstants.domainWealth: AppColors.domainWealth,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.value;
    final domains = profile?.domains ?? {
      AppConstants.domainDiscipline: 0,
      AppConstants.domainBody: 0,
      AppConstants.domainMind: 0,
      AppConstants.domainWealth: 0,
    };

    return Row(
      children: AppConstants.allDomains.map((domain) {
        final xp = domains[domain] ?? 0;
        final level = XpCalculator.levelForXp(xp);
        final color = _domainColors[domain] ?? AppColors.primaryGreen;
        final emoji = AppConstants.domainEmojis[domain] ?? '⚡';
        final label = AppConstants.domainLabels[domain] ?? domain;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: domain != AppConstants.allDomains.last ? 8 : 0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withAlpha(60), width: 0.5),
            ),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  'Lv $level',
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
