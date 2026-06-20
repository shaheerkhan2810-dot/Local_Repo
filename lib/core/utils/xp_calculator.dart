import '../constants/app_constants.dart';

class XpCalculator {
  XpCalculator._();

  /// Returns the level for a given total XP amount
  static int levelForXp(int totalXp) {
    int level = 0;
    for (int i = AppConstants.levelThresholds.length - 1; i >= 0; i--) {
      if (totalXp >= AppConstants.levelThresholds[i]) {
        level = i;
        break;
      }
    }
    return level;
  }

  /// Returns XP required to reach the next level
  static int xpForNextLevel(int currentLevel) {
    if (currentLevel >= AppConstants.levelThresholds.length - 1) {
      return AppConstants.levelThresholds.last;
    }
    return AppConstants.levelThresholds[currentLevel + 1];
  }

  /// Returns progress (0.0–1.0) toward the next level
  static double progressToNextLevel(int totalXp) {
    final level = levelForXp(totalXp);
    if (level >= AppConstants.levelThresholds.length - 1) return 1.0;
    final currentLevelXp = AppConstants.levelThresholds[level];
    final nextLevelXp = AppConstants.levelThresholds[level + 1];
    final progress = (totalXp - currentLevelXp) / (nextLevelXp - currentLevelXp);
    return progress.clamp(0.0, 1.0);
  }

  /// Returns XP bonus for hitting a streak milestone
  static int milestoneBonus(int streakDays) {
    switch (streakDays) {
      case 7:
        return AppConstants.xpMilestone7;
      case 30:
        return AppConstants.xpMilestone30;
      case 90:
        return AppConstants.xpMilestone90;
      case 180:
        return AppConstants.xpMilestone180;
      case 365:
        return AppConstants.xpMilestone365;
      default:
        return 0;
    }
  }

  /// Check if a streak day qualifies for a milestone
  static bool isMilestoneDay(int streakDays) =>
      AppConstants.streakMilestones.contains(streakDays);

  /// Returns the next milestone day count given current streak
  static int? nextMilestoneDays(int currentDays) {
    for (final m in AppConstants.streakMilestones) {
      if (m > currentDays) return m;
    }
    return null;
  }

  /// Progress (0.0–1.0) toward next streak milestone
  static double progressToNextMilestone(int currentDays) {
    int prevMilestone = 0;
    for (final m in AppConstants.streakMilestones) {
      if (currentDays < m) {
        final total = m - prevMilestone;
        final done = currentDays - prevMilestone;
        return (done / total).clamp(0.0, 1.0);
      }
      prevMilestone = m;
    }
    return 1.0;
  }

  /// Returns list of badge IDs that should be unlocked at a given streak day
  static List<String> badgesForStreak(int streakDays) {
    return AppConstants.milestoneBadgeIds.entries
        .where((e) => e.key <= streakDays)
        .map((e) => e.value)
        .toList();
  }

  /// Get domain for a given XP action
  static String domainForAction(String actionType) {
    switch (actionType) {
      case 'streak_day':
      case 'relapse_reset':
      case 'challenge_day':
        return AppConstants.domainDiscipline;
      case 'gym_entry':
      case 'body_tracker':
        return AppConstants.domainBody;
      case 'journal':
      case 'study':
      case 'meditation':
      case 'reading':
        return AppConstants.domainMind;
      case 'work':
      case 'finance':
      case 'side_hustle':
        return AppConstants.domainWealth;
      default:
        return AppConstants.domainDiscipline;
    }
  }
}
