import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/streak_provider.dart';

class StreakHeroCard extends ConsumerWidget {
  const StreakHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(currentStreakDaysProvider);
    final nextMilestone = ref.watch(nextMilestoneDaysProvider);
    final progress = ref.watch(milestoneProgressProvider);

    return GestureDetector(
      onTap: () => context.push('/streak'),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D0D0D), Color(0xFF0A1F0A), Color(0xFF000000)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryGreen.withAlpha(80), width: 1),
        ),
        child: Stack(
          children: [
            // Top-left flame + label
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    days == 1 ? 'DAY STREAK' : 'DAY STREAK',
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            // Main center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'DAYS CLEAN',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (days == 0)
                    const Text(
                      'BEGIN YOUR\nJOURNEY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentGold,
                        height: 1.1,
                        letterSpacing: 2,
                      ),
                    )
                  else
                    _AnimatedDaysCounter(days: days)
                        .animate()
                        .fadeIn(duration: 600.ms),
                  if (nextMilestone != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '/ $nextMilestone DAYS',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        color: AppColors.primaryGreenBright,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Bottom progress bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreenBright),
                  minHeight: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDaysCounter extends StatefulWidget {
  final int days;

  const _AnimatedDaysCounter({required this.days});

  @override
  State<_AnimatedDaysCounter> createState() => _AnimatedDaysCounterState();
}

class _AnimatedDaysCounterState extends State<_AnimatedDaysCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(begin: 0, end: widget.days.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Text(
        _animation.value.round().toString(),
        style: const TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 88,
          fontWeight: FontWeight.w700,
          color: AppColors.accentGold,
          height: 1.0,
          letterSpacing: -2,
        ),
      ),
    );
  }
}
