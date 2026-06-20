import 'package:flutter_test/flutter_test.dart';
import 'package:apexforge/models/main_streak.dart';

void main() {
  group('MainStreak', () {
    test('currentDays is 0 when startDate is today', () {
      final streak = MainStreak(
        id: 'current',
        startDate: DateTime.now(),
        isActive: true,
        lastUpdated: DateTime.now(),
      );
      expect(streak.currentDays, 0);
    });

    test('currentDays is 5 when startDate is 5 days ago', () {
      final streak = MainStreak(
        id: 'current',
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        isActive: true,
        lastUpdated: DateTime.now(),
      );
      expect(streak.currentDays, 5);
    });

    test('currentDays is 0 when streak is not active', () {
      final streak = MainStreak(
        id: 'current',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        isActive: false,
        lastUpdated: DateTime.now(),
      );
      expect(streak.currentDays, 0);
    });

    test('fresh streak has isActive=true and today as startDate', () {
      final before = DateTime.now();
      final streak = MainStreak.fresh();
      final after = DateTime.now();
      expect(streak.isActive, true);
      expect(streak.startDate.isAfter(before.subtract(const Duration(seconds: 1))), true);
      expect(streak.startDate.isBefore(after.add(const Duration(seconds: 1))), true);
    });

    test('copyWith preserves id', () {
      final streak = MainStreak(
        id: 'test-id',
        startDate: DateTime.now(),
        isActive: true,
        lastUpdated: DateTime.now(),
      );
      final copied = streak.copyWith(isActive: false);
      expect(copied.id, 'test-id');
      expect(copied.isActive, false);
    });
  });
}
