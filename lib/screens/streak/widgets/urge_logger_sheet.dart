import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/providers/streak_provider.dart';
import 'package:apexforge/widgets/apex_button.dart';

class UrgeLoggerSheet extends ConsumerStatefulWidget {
  const UrgeLoggerSheet({super.key});

  @override
  ConsumerState<UrgeLoggerSheet> createState() => _UrgeLoggerSheetState();
}

class _UrgeLoggerSheetState extends ConsumerState<UrgeLoggerSheet> {
  double _intensity = 5;
  final _triggerController = TextEditingController();
  String? _selectedCopingTool;
  bool _overcame = false;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _triggerController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    await ref.read(streakNotifierProvider.notifier).logUrge(
          intensity: _intensity.round(),
          trigger: _triggerController.text.trim().isEmpty
              ? null
              : _triggerController.text.trim(),
          copingToolUsed: _selectedCopingTool,
          overcame: _overcame,
        );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _submitted = true;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.surfaceBright)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPadding),
      child: _submitted ? _buildSuccess() : _buildForm(),
    );
  }

  Widget _buildSuccess() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('💪', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text(
            'Stay strong!',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.accentGold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Urge logged. You got this.',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LOG URGE',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Intensity: ${_intensity.round()}/10',
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Slider(
            value: _intensity,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: AppColors.accentGold,
            inactiveColor: AppColors.surfaceVariant,
            onChanged: (v) => setState(() => _intensity = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _triggerController,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'What triggered it? (optional)',
              labelStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accentGold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Coping Tool Used',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCopingTool,
            dropdownColor: AppColors.surfaceVariant,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: 'Select a coping tool',
              hintStyle: const TextStyle(color: AppColors.textHint),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('None'),
              ),
              ...AppConstants.copingTools.map((tool) => DropdownMenuItem(
                    value: tool['id'],
                    child: Text('${tool['emoji']} ${tool['label']}'),
                  )),
            ],
            onChanged: (v) => setState(() => _selectedCopingTool = v),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: _overcame,
            onChanged: (v) => setState(() => _overcame = v),
            activeColor: AppColors.accentGold,
            title: const Text(
              'I overcame this urge',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 20),
          ApexButton(
            label: 'Submit',
            onPressed: _submit,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
