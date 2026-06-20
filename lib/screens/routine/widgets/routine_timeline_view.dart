import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/routine_block.dart';

class RoutineTimelineView extends StatelessWidget {
  final List<RoutineBlock> blocks;

  const RoutineTimelineView({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = blocks.fold(0, (sum, b) => sum + b.durationMinutes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'TIMELINE',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGold,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            Text(
              'Total: ${total ~/ 60}h ${total % 60}m',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...blocks.asMap().entries.map((e) {
          final i = e.key;
          final block = e.value;
          final isLast = i == blocks.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline line
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.accentGold,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.background, width: 2),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: AppColors.surfaceBright,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Block
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.surfaceBright, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Text(block.iconEmoji,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  block.title,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${block.durationMinutes} min',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
