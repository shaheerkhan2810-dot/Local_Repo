import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withAlpha(180),
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBright, width: 0.5),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Rajdhani',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelLabel,
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isDestructive ? AppColors.error : AppColors.primaryGreen,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmLabel,
            style: const TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
