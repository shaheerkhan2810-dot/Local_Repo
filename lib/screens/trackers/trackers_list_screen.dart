import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/tracker_provider.dart';
import 'package:apexforge/screens/trackers/widgets/tracker_card.dart';
import 'package:apexforge/widgets/apex_empty_state.dart';

class TrackersListScreen extends ConsumerWidget {
  const TrackersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackersAsync = ref.watch(trackerListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'TRACKERS',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.surfaceBright),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/trackers/new'),
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add_rounded),
      ),
      body: trackersAsync.when(
        data: (trackers) {
          final active = trackers.where((t) => !t.isArchived).toList();
          if (active.isEmpty) {
            return ApexEmptyState(
              emoji: '📊',
              title: 'No trackers yet',
              subtitle: 'Create your first life tracker',
              actionLabel: 'Create Tracker',
              onAction: () => context.push('/trackers/new'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: active.length,
              itemBuilder: (context, index) {
                final tracker = active[index];
                return TrackerCard(
                  tracker: tracker,
                  onTap: () =>
                      context.push('/trackers/${tracker.id}'),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
        ),
        error: (e, _) => Center(
          child: Text(
            'Error loading trackers',
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: AppColors.error,
            ),
          ),
        ),
      ),
    );
  }
}
