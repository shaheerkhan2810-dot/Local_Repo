import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/challenge_provider.dart';
import 'package:apexforge/screens/challenges/widgets/xp_progress_ring.dart';
import 'package:apexforge/widgets/apex_button.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';
import 'package:apexforge/widgets/confirmation_dialog.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  final String challengeId;

  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allChallengesProvider);
    final builtInAsync = ref.watch(builtInChallengesProvider);

    return allAsync.when(
      data: (allProgress) {
        final progress = allProgress
            .where((p) => p.challengeId == challengeId)
            .firstOrNull;

        return builtInAsync.when(
          data: (builtIn) {
            final challenge =
                progress?.challenge ??
                builtIn.where((c) => c.id == challengeId).firstOrNull;

            if (challenge == null) {
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(backgroundColor: AppColors.surface),
                body: const Center(
                  child: Text('Challenge not found',
                      style: TextStyle(color: AppColors.textHint)),
                ),
              );
            }

            final isActive = progress != null && !progress.isCompleted;
            final isCompleted = progress?.isCompleted ?? false;

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.surface,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  challenge.title,
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Hero
                  Center(
                    child: Column(
                      children: [
                        Text(challenge.iconEmoji,
                            style: const TextStyle(fontSize: 64)),
                        const SizedBox(height: 12),
                        if (isActive && progress != null)
                          XpProgressRing(
                            progress: progress.progressPercent,
                            size: 120,
                            centerText:
                                '${(progress.progressPercent * 100).toInt()}%',
                            subText: 'complete',
                          ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withAlpha(38),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.accentGold, width: 1),
                            ),
                            child: const Text(
                              '🏆  COMPLETED',
                              style: TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentGold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Stats row
                  Row(
                    children: [
                      _StatChip(
                          label: 'Duration',
                          value: '${challenge.durationDays}d'),
                      const SizedBox(width: 10),
                      _StatChip(
                          label: 'XP Reward',
                          value: '+${challenge.xpReward}'),
                      const SizedBox(width: 10),
                      _StatChip(
                          label: 'Domain',
                          value: challenge.domain.toUpperCase()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'ABOUT',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    challenge.description,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  if (!isActive && !isCompleted)
                    ApexButton(
                      label: 'Join Challenge',
                      onPressed: () async {
                        await ref
                            .read(challengeNotifierProvider.notifier)
                            .joinChallenge(challenge);
                        if (context.mounted) {
                          ApexSnackbar.show(context,
                              '${challenge.iconEmoji} Challenge started!');
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  if (isActive && progress != null) ...[
                    ApexButton(
                      label: 'Log Progress +1',
                      onPressed: () async {
                        await ref
                            .read(challengeNotifierProvider.notifier)
                            .updateProgress(
                              progress.id,
                              progress.currentValue + 1,
                              isCompleted: progress.currentValue + 1 >=
                                  challenge.targetValue,
                            );
                        if (context.mounted) {
                          ApexSnackbar.show(context, 'Progress updated!');
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    ApexButton(
                      label: 'Abandon',
                      isOutlined: true,
                      color: AppColors.error,
                      onPressed: () async {
                        final confirmed = await showConfirmationDialog(
                          context,
                          title: 'Abandon Challenge',
                          message:
                              'Are you sure? Your progress will be lost.',
                          confirmLabel: 'Abandon',
                          isDestructive: true,
                        );
                        if (confirmed && context.mounted) {
                          await ref
                              .read(challengeNotifierProvider.notifier)
                              .abandonChallenge(progress.id);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            ),
          ),
          error: (_, __) => Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: Text('Error', style: TextStyle(color: AppColors.error)),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: Text('Error', style: TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.surfaceBright, width: 0.5),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.accentGold,
              ),
            ),
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
      ),
    );
  }
}
