import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/utils/xp_calculator.dart';
import 'package:apexforge/models/user_profile.dart';

class XpLevelCard extends StatelessWidget {
  final UserProfile profile;

  const XpLevelCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final level = XpCalculator.levelForXp(profile.totalXP);
    final progress = XpCalculator.progressToNextLevel(profile.totalXP);
    final nextThreshold = XpCalculator.xpForNextLevel(level);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withAlpha(40),
            AppColors.accentGold.withAlpha(15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentGold.withAlpha(80),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(
                      color: AppColors.accentGold, width: 2),
                ),
                child: profile.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          profile.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _DefaultAvatar(
                              name: profile.displayName),
                        ),
                      )
                    : _DefaultAvatar(name: profile.displayName),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName.isEmpty ? 'Warrior' : profile.displayName,
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'LVL',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.background,
                      ),
                    ),
                    Text(
                      '$level',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${profile.totalXP} XP',
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGold,
                    ),
                  ),
                  Text(
                    level < 17
                        ? '${nextThreshold - profile.totalXP} XP to Level ${level + 1}'
                        : 'MAX LEVEL',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceBright,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  final String name;
  const _DefaultAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'W',
        style: const TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.accentGold,
        ),
      ),
    );
  }
}
