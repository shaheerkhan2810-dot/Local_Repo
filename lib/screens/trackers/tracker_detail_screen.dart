import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/providers/tracker_provider.dart';

class TrackerDetailScreen extends ConsumerStatefulWidget {
  final String trackerId;

  const TrackerDetailScreen({super.key, required this.trackerId});

  @override
  ConsumerState<TrackerDetailScreen> createState() =>
      _TrackerDetailScreenState();
}

class _TrackerDetailScreenState extends ConsumerState<TrackerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackerAsync =
        ref.watch(trackerDetailProvider(widget.trackerId));
    final entriesAsync =
        ref.watch(trackerEntriesProvider(widget.trackerId));

    return trackerAsync.when(
      data: (tracker) {
        if (tracker == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.surface,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(
              child: Text('Tracker not found',
                  style: TextStyle(color: AppColors.textHint)),
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: AppColors.textSecondary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Text(tracker.emoji,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tracker.name,
                    style: const TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.textSecondary),
                onPressed: () =>
                    context.push('/trackers/${tracker.id}/edit'),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.accentGold,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.accentGold,
              labelStyle: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Entries'),
                Tab(text: 'Photos'),
              ],
            ),
          ),
          floatingActionButton: _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () =>
                      context.push('/trackers/${tracker.id}/entry'),
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: AppColors.background,
                  child: const Icon(Icons.add_rounded),
                )
              : null,
          body: entriesAsync.when(
            data: (entries) => TabBarView(
              controller: _tabController,
              children: [
                // Overview tab
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Stats row
                    Row(
                      children: [
                        _StatTile(
                            label: 'Streak',
                            value: '${_calcStreak(entries)}d'),
                        _StatTile(
                            label: 'Total',
                            value: '${entries.length}'),
                        _StatTile(
                            label: 'XP/entry',
                            value: '${tracker.xpPerEntry}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.surfaceBright, width: 0.5),
                      ),
                      child: const Center(
                        child: Text(
                          'Heatmap — log entries to see data',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Entries tab
                entries.isEmpty
                    ? const Center(
                        child: Text(
                          'No entries yet. Tap + to log one.',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: AppColors.textHint,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: entries.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.surfaceBright,
                                  width: 0.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppDateUtils.formatDate(entry.date),
                                  style: const TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentGold,
                                  ),
                                ),
                                if (entry.values.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.values.entries
                                        .map((e) =>
                                            '${e.key}: ${e.value}')
                                        .join(' · '),
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                                if (entry.notes != null &&
                                    entry.notes!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.notes!,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 12,
                                      color: AppColors.textHint,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                // Photos tab
                Builder(builder: (context) {
                  final photos = entries
                      .expand((e) => e.mediaUrls)
                      .toList();
                  if (photos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No photos yet',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: AppColors.textHint,
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: photos[index],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppColors.surfaceVariant,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.broken_image,
                              color: AppColors.textHint),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              ),
            ),
            error: (_, __) => const Center(
              child: Text('Error loading entries',
                  style: TextStyle(color: AppColors.error)),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: Text('Error', style: TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }

  int _calcStreak(List entries) {
    if (entries.isEmpty) return 0;
    int streak = 0;
    var checkDate = AppDateUtils.startOfDay(DateTime.now());
    for (var entry in entries) {
      final entryDate = AppDateUtils.startOfDay(entry.date);
      if (entryDate == checkDate ||
          entryDate ==
              checkDate.subtract(const Duration(days: 1))) {
        streak++;
        checkDate = entryDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: AppColors.surfaceBright, width: 0.5),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.accentGold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
