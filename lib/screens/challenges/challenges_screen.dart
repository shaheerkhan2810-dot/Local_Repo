import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/challenge_provider.dart';
import 'package:apexforge/screens/challenges/widgets/challenge_card.dart';
import 'package:apexforge/widgets/apex_empty_state.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(allChallengesProvider);
    final builtInAsync = ref.watch(builtInChallengesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'CHALLENGES',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.accentGold,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accentGold,
          labelStyle: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Available'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // Active tab
          allAsync.when(
            data: (all) {
              final active =
                  all.where((p) => !p.isCompleted).toList();
              if (active.isEmpty) {
                return ApexEmptyState(
                  emoji: '⚡',
                  title: 'No active challenges',
                  subtitle: 'Join a challenge to start leveling up',
                  actionLabel: 'Browse Challenges',
                  onAction: () => _tab.animateTo(1),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: active.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () =>
                      context.push('/challenges/${active[i].challengeId}'),
                  child: ChallengeCard(
                    challenge: active[i].challenge ??
                        _emptyChallenge(active[i].challengeId),
                    progress: active[i],
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            ),
            error: (_, __) => const Center(
              child: Text('Error', style: TextStyle(color: AppColors.error)),
            ),
          ),

          // Available tab
          builtInAsync.when(
            data: (challenges) {
              final activeIds = allAsync.value
                      ?.where((p) => !p.isCompleted)
                      .map((p) => p.challengeId)
                      .toSet() ??
                  {};
              final available = challenges
                  .where((c) => !activeIds.contains(c.id))
                  .toList();
              if (available.isEmpty) {
                return const ApexEmptyState(
                  emoji: '🏆',
                  title: 'All caught up!',
                  subtitle: 'You\'re in all available challenges',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: available.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => ChallengeCard(
                  challenge: available[i],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            ),
            error: (_, __) => const Center(
              child: Text('Error', style: TextStyle(color: AppColors.error)),
            ),
          ),

          // Completed tab
          allAsync.when(
            data: (all) {
              final completed =
                  all.where((p) => p.isCompleted).toList();
              if (completed.isEmpty) {
                return const ApexEmptyState(
                  emoji: '🎯',
                  title: 'No completed challenges yet',
                  subtitle: 'Finish a challenge to see it here',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: completed.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => ChallengeCard(
                  challenge: completed[i].challenge ??
                      _emptyChallenge(completed[i].challengeId),
                  progress: completed[i],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            ),
            error: (_, __) => const Center(
              child: Text('Error', style: TextStyle(color: AppColors.error)),
            ),
          ),
        ],
      ),
    );
  }

  Challenge _emptyChallenge(String id) => Challenge(
        id: id,
        title: 'Challenge',
        description: '',
        type: 'streak',
        targetValue: 1,
        durationDays: 30,
        xpReward: 0,
        domain: 'discipline',
        difficulty: 'medium',
        iconEmoji: '🎯',
      );
}
