import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class MoodSelector extends StatefulWidget {
  final int selectedMood;
  final ValueChanged<int> onMoodChanged;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodChanged,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  static const _moods = [
    (emoji: '😢', label: 'Terrible'),
    (emoji: '😕', label: 'Low'),
    (emoji: '😐', label: 'Neutral'),
    (emoji: '😊', label: 'Good'),
    (emoji: '🔥', label: 'Amazing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MOOD',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.accentGold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_moods.length, (i) {
            final mood = _moods[i];
            final level = i + 1;
            final isSelected = widget.selectedMood == level;

            return GestureDetector(
              onTap: () => widget.onMoodChanged(level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentGold.withAlpha(30)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentGold
                        : AppColors.surfaceBright,
                    width: isSelected ? 1.5 : 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      mood.emoji,
                      style: TextStyle(
                        fontSize: isSelected ? 28 : 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mood.label,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
