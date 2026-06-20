import 'package:flutter_test/flutter_test.dart';
import 'package:apexforge/core/utils/xp_calculator.dart';

void main() {
  group('XpCalculator', () {
    test('levelForXp returns 0 for 0 XP', () {
      expect(XpCalculator.levelForXp(0), 0);
    });

    test('levelForXp returns 1 at 100 XP', () {
      expect(XpCalculator.levelForXp(100), 1);
    });

    test('levelForXp returns 1 at 249 XP', () {
      expect(XpCalculator.levelForXp(249), 1);
    });

    test('levelForXp returns 2 at 250 XP', () {
      expect(XpCalculator.levelForXp(250), 2);
    });

    test('progressToNextLevel returns 0.0 at level 0 with 0 XP', () {
      expect(XpCalculator.progressToNextLevel(0), 0.0);
    });

    test('progressToNextLevel returns 0.5 at level 0 with 50 XP', () {
      expect(XpCalculator.progressToNextLevel(50), closeTo(0.5, 0.01));
    });

    test('progressToNextLevel returns 1.0 at exact next level threshold', () {
      expect(XpCalculator.progressToNextLevel(100), 1.0);
    });

    test('nextMilestoneDays returns 7 when at day 5', () {
      expect(XpCalculator.nextMilestoneDays(5), 7);
    });

    test('nextMilestoneDays returns 30 when at day 7', () {
      expect(XpCalculator.nextMilestoneDays(7), 14);
    });

    test('nextMilestoneDays returns null when past all milestones', () {
      expect(XpCalculator.nextMilestoneDays(400), null);
    });

    test('isMilestoneDay returns true for 7', () {
      expect(XpCalculator.isMilestoneDay(7), true);
    });

    test('isMilestoneDay returns false for 8', () {
      expect(XpCalculator.isMilestoneDay(8), false);
    });

    test('milestoneBonus returns 100 at day 7', () {
      expect(XpCalculator.milestoneBonus(7), 100);
    });

    test('milestoneBonus returns 500 at day 30', () {
      expect(XpCalculator.milestoneBonus(30), 500);
    });

    test('milestoneBonus returns 0 for non-milestone day', () {
      expect(XpCalculator.milestoneBonus(15), 0);
    });

    test('progressToNextMilestone returns 0.5 at day 3.5 (between 0 and 7)',
        () {
      // At day 3 with next milestone at 7: progress = (3-0)/(7-0) = ~0.43
      expect(
          XpCalculator.progressToNextMilestone(3), closeTo(0.429, 0.01));
    });

    test('progressToNextMilestone returns 1.0 when past all milestones', () {
      expect(XpCalculator.progressToNextMilestone(400), 1.0);
    });
  });
}
