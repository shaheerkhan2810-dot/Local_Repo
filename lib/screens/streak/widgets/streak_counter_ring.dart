import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/streak_provider.dart';

class StreakCounterRing extends ConsumerWidget {
  const StreakCounterRing({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(currentStreakDaysProvider);
    final nextMilestone = ref.watch(nextMilestoneDaysProvider);
    final progress = ref.watch(milestoneProgressProvider);

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(280, 280),
            painter: _RingPainter(progress: progress),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$days',
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 72,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentGold,
                  height: 1.0,
                ),
              ),
              const Text(
                'DAYS',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreenBright,
                  letterSpacing: 3,
                ),
              ),
              if (nextMilestone != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Next: $nextMilestone days',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 3000.ms, color: AppColors.accentGold.withAlpha(40));
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 16;
    const strokeWidth = 12.0;

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.surfaceVariant
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc — color shifts from green to gold as milestone approaches
    final Color arcColor = Color.lerp(
      AppColors.primaryGreenBright,
      AppColors.accentGold,
      progress,
    )!;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [AppColors.primaryGreenBright, arcColor],
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + (2 * math.pi * progress),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
