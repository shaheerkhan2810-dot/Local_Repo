import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class ApexSnackbar {
  ApexSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    final Color bgColor;
    final Color textColor;
    final IconData icon;

    if (isError) {
      bgColor = AppColors.error.withAlpha(230);
      textColor = Colors.white;
      icon = Icons.error_outline_rounded;
    } else if (isSuccess) {
      bgColor = AppColors.primaryGreenBright.withAlpha(230);
      textColor = Colors.white;
      icon = Icons.check_circle_outline_rounded;
    } else {
      bgColor = AppColors.surfaceVariant;
      textColor = AppColors.textPrimary;
      icon = Icons.info_outline_rounded;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
