import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/providers/streak_provider.dart';

void main() {
  group('currentStreakDaysProvider', () {
    test('returns 0 when no streak data', () {
      final container = ProviderContainer(
        overrides: [
          mainStreakProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(currentStreakDaysProvider), 0);
    });
  });

  group('milestoneProgressProvider', () {
    test('returns progress value between 0 and 1', () {
      final container = ProviderContainer(
        overrides: [
          mainStreakProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(container.dispose);
      final progress = container.read(milestoneProgressProvider);
      expect(progress, greaterThanOrEqualTo(0.0));
      expect(progress, lessThanOrEqualTo(1.0));
    });
  });
}
