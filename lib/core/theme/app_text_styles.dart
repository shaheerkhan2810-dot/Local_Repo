import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display — Rajdhani Bold, hero numbers
  static const TextStyle displayHero = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 96,
    fontWeight: FontWeight.w700,
    color: AppColors.accentGold,
    height: 1.0,
    letterSpacing: -2,
  );

  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 56,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  // Headings — Rajdhani SemiBold
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Labels — Rajdhani Regular
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  // Body — Nunito
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    height: 1.4,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );

  // Caption / metadata
  static const TextStyle caption = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    letterSpacing: 0.4,
  );

  // Milestone / badge labels
  static const TextStyle milestoneLabel = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.accentGold,
    letterSpacing: 1.5,
  );
}
