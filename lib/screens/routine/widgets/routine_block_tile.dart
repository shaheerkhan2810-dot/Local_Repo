import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/models/routine_block.dart';

class RoutineBlockTile extends StatelessWidget {
  final RoutineBlock block;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool showDragHandle;

  const RoutineBlockTile({
    super.key,
    required this.block,
    required this.onDelete,
    required this.onEdit,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle)
              const Icon(Icons.drag_handle_rounded,
                  color: AppColors.textHint, size: 20),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  block.iconEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          block.title,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.timer_outlined,
                size: 12, color: AppColors.textHint),
            const SizedBox(width: 4),
            Text(
              '${block.durationMinutes} min',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            if (block.description != null && block.description!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  block.description!,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: AppColors.textSecondary, size: 18),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 18),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
