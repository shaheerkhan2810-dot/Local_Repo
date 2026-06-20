import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/challenge_provider.dart';
import 'package:apexforge/screens/home/widgets/streak_hero_card.dart';
import 'package:apexforge/screens/home/widgets/xp_domain_bar.dart';
import 'package:apexforge/screens/home/widgets/quick_action_grid.dart';
import 'package:apexforge/screens/home/widgets/today_summary_card.dart';
import 'package:apexforge/screens/challenges/widgets/challenge_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChallenges = ref.watch(activeChallengesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StreakHeroCard(),
                    const SizedBox(height: 16),
                    const XpDomainBar(),
                    const SizedBox(height: 16),
                    const QuickActionGrid(),
                    const SizedBox(height: 16),
                    const TodaySummaryCard(),
                    const SizedBox(height: 16),
                    const Text(
                      'ACTIVE CHALLENGES',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    activeChallenges.when(
                      data: (challenges) {
                        if (challenges.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'No active challenges. Join one to level up!',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 13,
                                color: AppColors.textHint,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: challenges.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final progress = challenges[index];
                              if (progress.challenge == null) {
                                return const SizedBox.shrink();
                              }
                              return SizedBox(
                                width: 220,
                                child: ChallengeCard(
                                  challenge: progress.challenge!,
                                  progress: progress,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.accentGold),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
