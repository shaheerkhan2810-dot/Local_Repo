import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0D0D0D);
  static const Color surfaceVariant = Color(0xFF1A1A1A);
  static const Color surfaceBright = Color(0xFF242424);

  // Primary
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color primaryGreenLight = Color(0xFF2E7D32);
  static const Color primaryGreenBright = Color(0xFF43A047);

  // Accent
  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentGoldDim = Color(0xFFB8860B);
  static const Color accentGoldDark = Color(0xFF7B6000);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF606060);
  static const Color textDisabled = Color(0xFF404040);

  // Semantic
  static const Color error = Color(0xFFCF6679);
  static const Color errorDark = Color(0xFF8B1A2E);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Domains
  static const Color domainDiscipline = Color(0xFF7B1FA2);
  static const Color domainDisciplineLight = Color(0xFFAB47BC);
  static const Color domainBody = Color(0xFF1565C0);
  static const Color domainBodyLight = Color(0xFF42A5F5);
  static const Color domainMind = Color(0xFF00695C);
  static const Color domainMindLight = Color(0xFF26A69A);
  static const Color domainWealth = Color(0xFFE65100);
  static const Color domainWealthLight = Color(0xFFFF8A65);

  // Streak milestones
  static const Color milestone7 = Color(0xFF66BB6A);
  static const Color milestone30 = Color(0xFF29B6F6);
  static const Color milestone90 = Color(0xFFAB47BC);
  static const Color milestone180 = Color(0xFFFFCA28);
  static const Color milestone365 = Color(0xFFFFD700);

  // Difficulty
  static const Color difficultyEasy = Color(0xFF4CAF50);
  static const Color difficultyMedium = Color(0xFFFF9800);
  static const Color difficultyHard = Color(0xFFF44336);
  static const Color difficultyElite = Color(0xFFFFD700);

  // Rarity
  static const Color rarityCommon = Color(0xFF9E9E9E);
  static const Color rarityRare = Color(0xFF42A5F5);
  static const Color rarityEpic = Color(0xFFAB47BC);
  static const Color rarityLegendary = Color(0xFFFFD700);

  // Gradient helpers
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFB8860B), Color(0xFFFFD700)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D0D0D), Color(0xFF000000)],
  );
}
