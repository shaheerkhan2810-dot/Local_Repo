import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/providers/streak_provider.dart';
import 'package:apexforge/widgets/apex_button.dart';

class RelapseModal extends ConsumerStatefulWidget {
  const RelapseModal({super.key});

  @override
  ConsumerState<RelapseModal> createState() => _RelapseModalState();
}

class _RelapseModalState extends ConsumerState<RelapseModal> {
  int _currentStep = 0;
  String? _selectedTrigger;
  int _selectedMood = 3;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  static const List<String> _moodEmojis = ['😢', '😕', '😐', '😊', '🔥'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitRelapse() async {
    setState(() => _isLoading = true);
    final streakDays = ref.read(currentStreakDaysProvider);
    await ref.read(streakNotifierProvider.notifier).logRelapse(
          triggerCategory: _selectedTrigger,
          mood: _selectedMood,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          streakDaysBefore: streakDays,
        );
    setState(() => _isLoading = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final days = ref.watch(currentStreakDaysProvider);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.surfaceBright)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPadding),
      child: _buildStep(days),
    );
  }

  Widget _buildStep(int days) {
    switch (_currentStep) {
      case 0:
        return _StepZero(
          streakDays: days,
          onCancel: () => Navigator.of(context).pop(),
          onContinue: () => setState(() => _currentStep = 1),
        );
      case 1:
        return _StepOne(
          selectedTrigger: _selectedTrigger,
          onSelect: (t) => setState(() => _selectedTrigger = t),
          onNext: () => setState(() => _currentStep = 2),
          onBack: () => setState(() => _currentStep = 0),
        );
      case 2:
        return _StepTwo(
          selectedMood: _selectedMood,
          notesController: _notesController,
          moodEmojis: _moodEmojis,
          isLoading: _isLoading,
          onMoodSelect: (m) => setState(() => _selectedMood = m),
          onSubmit: _submitRelapse,
          onBack: () => setState(() => _currentStep = 1),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepZero extends StatelessWidget {
  final int streakDays;
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const _StepZero({
    required this.streakDays,
    required this.onCancel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.warning_amber_rounded,
            color: AppColors.error, size: 48),
        const SizedBox(height: 12),
        const Text(
          'Are you sure?',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Logging a relapse will reset your streak.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$streakDays day${streakDays == 1 ? '' : 's'} will be lost',
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.surfaceBright),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepOne extends StatelessWidget {
  final String? selectedTrigger;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _StepOne({
    required this.selectedTrigger,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What triggered it?',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: AppConstants.relapseTriggerCategories.map((trigger) {
            final isSelected = selectedTrigger == trigger;
            return GestureDetector(
              onTap: () => onSelect(trigger),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.error.withAlpha(40)
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.error
                        : AppColors.surfaceBright,
                    width: 1,
                  ),
                ),
                child: Text(
                  trigger,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: isSelected
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            TextButton(
              onPressed: onBack,
              child: const Text(
                'Back',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepTwo extends StatelessWidget {
  final int selectedMood;
  final TextEditingController notesController;
  final List<String> moodEmojis;
  final bool isLoading;
  final ValueChanged<int> onMoodSelect;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const _StepTwo({
    required this.selectedMood,
    required this.notesController,
    required this.moodEmojis,
    required this.isLoading,
    required this.onMoodSelect,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(moodEmojis.length, (i) {
            final isSelected = selectedMood == i + 1;
            return GestureDetector(
              onTap: () => onMoodSelect(i + 1),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentGold.withAlpha(30)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppColors.accentGold, width: 1.5)
                      : null,
                ),
                child: Text(
                  moodEmojis[i],
                  style: TextStyle(fontSize: isSelected ? 32 : 26),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: notesController,
          maxLines: 3,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Optional notes...',
            hintStyle: const TextStyle(
              fontFamily: 'Nunito',
              color: AppColors.textHint,
            ),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            TextButton(
              onPressed: onBack,
              child: const Text(
                'Back',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'I Relapsed',
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
