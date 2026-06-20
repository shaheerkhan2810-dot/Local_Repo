import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class ApexButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final IconData? icon;

  const ApexButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        height: 52,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color ?? AppColors.accentGold, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _buildChild(isOutlinedStyle: true),
        ),
      );
    }

    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primaryGreen,
          disabledBackgroundColor:
              (color ?? AppColors.primaryGreen).withAlpha(100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _buildChild(isOutlinedStyle: false),
      ),
    );
  }

  Widget _buildChild({required bool isOutlinedStyle}) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlinedStyle ? (color ?? AppColors.accentGold) : Colors.white,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18,
            color: isOutlinedStyle
                ? (color ?? AppColors.accentGold)
                : Colors.white,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isOutlinedStyle
                ? (color ?? AppColors.accentGold)
                : Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
