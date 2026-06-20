import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/models/task_model.dart';
import 'package:apexforge/providers/task_provider.dart';
import 'package:apexforge/widgets/apex_button.dart';
import 'package:apexforge/widgets/apex_text_field.dart';
import 'package:apexforge/widgets/apex_snackbar.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _uuid = const Uuid();

  DateTime? _dueDate;
  int _priority = 2;
  String? _domain;
  bool _isRecurring = false;
  String _recurrenceRule = 'daily';
  double _xpReward = 5;
  int _pomodoroEstimate = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentGold,
            surface: AppColors.surfaceVariant,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _addTask() async {
    if (_titleController.text.trim().isEmpty) {
      ApexSnackbar.show(context, 'Enter a task title', isError: true);
      return;
    }
    setState(() => _isLoading = true);

    final task = TaskModel(
      id: _uuid.v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
      domain: _domain,
      isRecurring: _isRecurring,
      recurrenceRule: _isRecurring ? _recurrenceRule : null,
      xpReward: _xpReward.round(),
      pomodoroEstimate: _pomodoroEstimate,
      createdAt: DateTime.now(),
    );

    final result =
        await ref.read(taskNotifierProvider.notifier).createTask(task);
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (result != null) {
      ApexSnackbar.show(context, 'Task added!', isSuccess: true);
      Navigator.of(context).pop();
    } else {
      ApexSnackbar.show(context, 'Failed to add task', isError: true);
    }
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceBright,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ADD TASK',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ApexTextField(
              label: 'Task Title',
              controller: _titleController,
              hint: 'What needs to be done?',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            ApexTextField(
              label: 'Description (optional)',
              controller: _descController,
              maxLines: 3,
              hint: 'Additional details...',
            ),
            const SizedBox(height: 12),
            // Due date
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.surfaceBright, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppColors.textHint, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      _dueDate != null
                          ? AppDateUtils.formatDate(_dueDate!)
                          : 'Set due date (optional)',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: _dueDate != null
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                      ),
                    ),
                    if (_dueDate != null) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _dueDate = null),
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.textHint, size: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Priority
            const Text(
              'PRIORITY',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _PriorityChip(
                  label: 'Low',
                  value: 1,
                  selectedValue: _priority,
                  color: AppColors.success,
                  onSelect: (v) => setState(() => _priority = v),
                ),
                const SizedBox(width: 8),
                _PriorityChip(
                  label: 'Medium',
                  value: 2,
                  selectedValue: _priority,
                  color: AppColors.warning,
                  onSelect: (v) => setState(() => _priority = v),
                ),
                const SizedBox(width: 8),
                _PriorityChip(
                  label: 'High',
                  value: 3,
                  selectedValue: _priority,
                  color: AppColors.error,
                  onSelect: (v) => setState(() => _priority = v),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Domain
            DropdownButtonFormField<String?>(
              value: _domain,
              dropdownColor: AppColors.surfaceVariant,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Domain (optional)',
                labelStyle: const TextStyle(
                    fontFamily: 'Nunito', color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('No domain'),
                ),
                ...AppConstants.allDomains.map((d) => DropdownMenuItem(
                      value: d,
                      child: Text(
                          '${AppConstants.domainEmojis[d]} ${AppConstants.domainLabels[d]}'),
                    )),
              ],
              onChanged: (v) => setState(() => _domain = v),
            ),
            const SizedBox(height: 14),
            // Recurring
            SwitchListTile(
              value: _isRecurring,
              onChanged: (v) => setState(() => _isRecurring = v),
              activeColor: AppColors.accentGold,
              title: const Text(
                'Recurring Task',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['daily', 'weekly', 'monthly'].map((rule) {
                  return ChoiceChip(
                    label: Text(rule.capitalize()),
                    selected: _recurrenceRule == rule,
                    selectedColor: AppColors.accentGold.withAlpha(40),
                    backgroundColor: AppColors.surfaceVariant,
                    labelStyle: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: _recurrenceRule == rule
                          ? AppColors.accentGold
                          : AppColors.textSecondary,
                    ),
                    side: BorderSide(
                      color: _recurrenceRule == rule
                          ? AppColors.accentGold
                          : AppColors.surfaceBright,
                    ),
                    onSelected: (_) =>
                        setState(() => _recurrenceRule = rule),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 14),
            // XP Reward
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'XP REWARD',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGold,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  '${_xpReward.round()} XP',
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 14,
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Slider(
              value: _xpReward,
              min: 1,
              max: 20,
              divisions: 19,
              activeColor: AppColors.accentGold,
              inactiveColor: AppColors.surfaceVariant,
              onChanged: (v) => setState(() => _xpReward = v),
            ),
            // Pomodoro estimate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'POMODOROS',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: AppColors.textHint, size: 20),
                      onPressed: () {
                        if (_pomodoroEstimate > 1) {
                          setState(() => _pomodoroEstimate--);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_pomodoroEstimate 🍅',
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: AppColors.textHint, size: 20),
                      onPressed: () => setState(() => _pomodoroEstimate++),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ApexButton(
              label: 'Add Task',
              onPressed: _addTask,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final int value;
  final int selectedValue;
  final Color color;
  final ValueChanged<int> onSelect;

  const _PriorityChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.color,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(40) : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AppColors.surfaceBright,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension _StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
