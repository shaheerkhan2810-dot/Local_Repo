import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/constants/app_constants.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/models/task_model.dart';
import 'package:apexforge/providers/task_provider.dart';
import 'package:apexforge/widgets/apex_badge_chip.dart';

class TaskTile extends ConsumerWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  Color _priorityColor() {
    switch (task.priority) {
      case 1:
        return AppColors.success;
      case 3:
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  Color _domainColor() {
    switch (task.domain) {
      case AppConstants.domainDiscipline:
        return AppColors.domainDiscipline;
      case AppConstants.domainBody:
        return AppColors.domainBody;
      case AppConstants.domainMind:
        return AppColors.domainMind;
      case AppConstants.domainWealth:
        return AppColors.domainWealth;
      default:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskNotifierProvider.notifier);
    final priorityColor = _priorityColor();

    return GestureDetector(
      onLongPress: () => _showOptionsMenu(context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: priorityColor, width: 3),
            top: const BorderSide(color: AppColors.surfaceBright, width: 0.5),
            right:
                const BorderSide(color: AppColors.surfaceBright, width: 0.5),
            bottom:
                const BorderSide(color: AppColors.surfaceBright, width: 0.5),
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: task.isCompleted,
              onChanged: (v) =>
                  notifier.toggleComplete(task.id, v ?? false),
              activeColor: AppColors.primaryGreenBright,
              checkColor: Colors.white,
              side: const BorderSide(color: AppColors.textHint, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: task.isCompleted
                  ? AppColors.textHint
                  : AppColors.textPrimary,
              decoration:
                  task.isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: AppColors.textHint,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                if (task.dueDate != null) ...[
                  Text(
                    AppDateUtils.formatDateShort(task.dueDate!),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (task.domain != null) ...[
                  ApexBadgeChip(
                    label: AppConstants.domainLabels[task.domain] ??
                        task.domain!,
                    color: _domainColor(),
                  ),
                  const SizedBox(width: 6),
                ],
                ApexBadgeChip(
                  label: task.priorityLabel,
                  color: priorityColor,
                ),
              ],
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.textHint, size: 20),
            onPressed: () => notifier.deleteTask(task.id),
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskNotifierProvider.notifier);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceVariant,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined,
                color: AppColors.textSecondary),
            title: const Text('Edit',
                style: TextStyle(
                    fontFamily: 'Nunito', color: AppColors.textPrimary)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading:
                const Icon(Icons.delete_outline, color: AppColors.error),
            title: const Text('Delete',
                style: TextStyle(
                    fontFamily: 'Nunito', color: AppColors.error)),
            onTap: () {
              notifier.deleteTask(task.id);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined,
                color: AppColors.accentGold),
            title: const Text('Start Pomodoro',
                style: TextStyle(
                    fontFamily: 'Nunito', color: AppColors.textPrimary)),
            onTap: () {
              ref
                  .read(pomodoroProvider.notifier)
                  .start(taskId: task.id);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
