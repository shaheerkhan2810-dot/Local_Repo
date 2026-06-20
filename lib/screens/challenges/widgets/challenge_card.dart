import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/challenge.dart';
import 'package:apexforge/providers/challenge_provider.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';

class ChallengeCard extends ConsumerWidget {
  final Challenge challenge;
  final ChallengeProgress? progress;
  final bool compact;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.progress,
    this.compact = false,
  });

  Color get _difficultyColor {
    switch (challenge.difficulty) {
      case 'elite':
        return const Color(0xFFFFD700);
      case 'hard':
        return const Color(0xFFFF5722);
      case 'medium':
        return const Color(0xFF1565C0);
      default:
        return AppColors.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = progress != null && !progress!.isCompleted;
    final isCompleted = progress?.isCompleted ?? false;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? AppColors.accentGold.withOpacity(0.6)
              : _difficultyColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(challenge.iconEmoji,
                  style: const TextStyle(fontSize: 28)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _difficultyColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: _difficultyColor.withOpacity(0.5), width: 0.5),
                ),
                child: Text(
                  challenge.difficulty.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _difficultyColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            challenge.title,
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!compact) ...[
            const SizedBox(height: 4),
            Text(
              challenge.description,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          if (isActive && progress != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress!.progressPercent,
                backgroundColor: AppColors.surfaceBright,
                valueColor:
                    AlwaysStoppedAnimation<Color>(_difficultyColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${progress!.currentValue}/${challenge.targetValue}',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${progress!.daysRemaining}d left',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ] else if (!isActive) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded,
                        color: AppColors.accentGold, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+${challenge.xpReward} XP',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGold,
                      ),
                    ),
                  ],
                ),
                if (!isCompleted)
                  GestureDetector(
                    onTap: () async {
                      final notifier =
                          ref.read(challengeNotifierProvider.notifier);
                      await notifier.joinChallenge(challenge);
                      if (context.mounted) {
                        ApexSnackbar.show(context, '${challenge.iconEmoji} Challenge joined!');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'JOIN',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  )
                else
                  const Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.success, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'DONE',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
