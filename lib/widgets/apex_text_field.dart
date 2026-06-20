import 'package:flutter/material.dart';
import 'package:apexforge/core/theme/app_colors.dart';

class ApexTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const ApexTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.suffix,
    this.onChanged,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: obscure ? 1 : maxLines,
      onChanged: onChanged,
      enabled: enabled,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onTap: onTap,
      style: const TextStyle(
        fontFamily: 'Nunito',
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          color: AppColors.textHint,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: AppColors.surfaceBright, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.accentGold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          color: AppColors.error,
        ),
      ),
    );
  }
}
