import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/journal_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/screens/journal/widgets/journal_tile.dart';
import 'package:apexforge/widgets/apex_empty_state.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  int? _moodFilter;

  static const List<Map<String, dynamic>> _moodFilters = [
    {'label': 'All', 'mood': null},
    {'label': '😢', 'mood': 1},
    {'label': '😕', 'mood': 2},
    {'label': '😐', 'mood': 3},
    {'label': '😊', 'mood': 4},
    {'label': '🔥', 'mood': 5},
  ];

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'JOURNAL',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              const Divider(height: 1, color: AppColors.surfaceBright),
              SizedBox(
                height: 47,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: _moodFilters.map((filter) {
                    final isSelected = _moodFilter == filter['mood'];
                    final label = filter['label'] as String;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _moodFilter = filter['mood'] as int?),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentGold.withAlpha(30)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentGold
                                : AppColors.surfaceBright,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            color: isSelected
                                ? AppColors.accentGold
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/journal/new'),
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.background,
        child: const Icon(Icons.add_rounded),
      ),
      body: entriesAsync.when(
        data: (entries) {
          final filtered = _moodFilter != null
              ? entries.where((e) => e.mood == _moodFilter).toList()
              : entries;

          if (filtered.isEmpty) {
            return ApexEmptyState(
              emoji: '✍️',
              title: 'No entries yet',
              subtitle: _moodFilter != null
                  ? 'No entries with this mood'
                  : 'Start writing your first entry',
              onAction: _moodFilter == null
                  ? () => context.push('/journal/new')
                  : null,
              actionLabel: 'Write Entry',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => JournalTile(
              entry: filtered[index],
              onTap: () => context.push('/journal/${filtered[index].id}'),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.accentGold),
          ),
        ),
        error: (_, __) => const Center(
          child: Text('Error loading journal',
              style: TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }
}
