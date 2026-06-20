import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/core/utils/date_utils.dart';
import 'package:apexforge/providers/analytics_provider.dart';
import 'package:apexforge/providers/user_provider.dart';
import 'package:apexforge/services/export_service.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmapAsync = ref.watch(streakHeatmapProvider);
    final weeklyAsync = ref.watch(weeklyReportProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.value;

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
        title: const Text(
          'ANALYTICS',
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded,
                color: AppColors.textSecondary),
            onPressed: () async {
              ApexSnackbar.show(context, 'Preparing export...');
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.surfaceBright),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 30-Day Heatmap
                  const _SectionHeader('30-DAY HEATMAP'),
                  const SizedBox(height: 12),
                  heatmapAsync.when(
                    data: (heatmap) =>
                        _HeatmapGrid(heatmap: heatmap),
                    loading: () => const SizedBox(
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accentGold),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),

                  // This Week
                  const _SectionHeader('THIS WEEK'),
                  const SizedBox(height: 12),
                  weeklyAsync.when(
                    data: (report) => report != null
                        ? _WeeklyReportCard(report: report)
                        : const SizedBox.shrink(),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.accentGold),
                        strokeWidth: 2,
                      ),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),

                  // XP Domains
                  const _SectionHeader('XP DOMAINS'),
                  const SizedBox(height: 12),
                  if (profile != null)
                    _DomainBarsSection(domains: profile.domains)
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 24),

                  // Insights
                  const _SectionHeader('INSIGHTS'),
                  const SizedBox(height: 12),
                  const _InsightsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApexSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontFamily: 'Nunito', fontSize: 14)),
        backgroundColor: AppColors.surfaceVariant,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Rajdhani',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.accentGold,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  final Map<DateTime, int> heatmap;

  const _HeatmapGrid({required this.heatmap});

  @override
  Widget build(BuildContext context) {
    final days = AppDateUtils.lastNDays(35);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        final day = days[index];
        final value = heatmap[AppDateUtils.startOfDay(day)] ?? 0;
        final intensity = value > 0 ? (value / 30).clamp(0.2, 1.0) : 0.0;

        return Tooltip(
          message: AppDateUtils.formatDateShort(day),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: value > 0
                  ? AppColors.primaryGreenBright.withAlpha(
                      (intensity * 255).round())
                  : AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}

class _WeeklyReportCard extends StatelessWidget {
  final WeeklyReport report;

  const _WeeklyReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.motivationalMessage,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatTile(label: 'Tasks', value: '${report.tasksCompleted}'),
              _StatTile(label: 'Journal', value: '${report.journalDays}d'),
              _StatTile(label: 'XP', value: '+${report.xpEarned}'),
              _StatTile(
                  label: 'Mood',
                  value: report.avgMood.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}

class _DomainBarsSection extends StatelessWidget {
  final Map<String, int> domains;

  const _DomainBarsSection({required this.domains});

  static const Map<String, Color> _domainColors = {
    'discipline': AppColors.domainDiscipline,
    'body': AppColors.domainBody,
    'mind': AppColors.domainMind,
    'wealth': AppColors.domainWealth,
  };

  static const Map<String, String> _domainEmojis = {
    'discipline': '⚡',
    'body': '💪',
    'mind': '🧠',
    'wealth': '💰',
  };

  @override
  Widget build(BuildContext context) {
    final maxXp = (domains.values.fold<int>(0, (a, b) => a > b ? a : b))
        .clamp(1, double.maxFinite.toInt());

    return Column(
      children: domains.entries.map((entry) {
        final color = _domainColors[entry.key] ?? AppColors.primaryGreen;
        final emoji = _domainEmojis[entry.key] ?? '⚡';
        final xp = entry.value;
        final progress = xp / maxXp;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '$xp XP',
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: AppColors.surfaceBright,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _InsightsSection extends StatelessWidget {
  const _InsightsSection();

  static const List<Map<String, String>> _insights = [
    {
      'emoji': '💡',
      'title': 'Consistency is your superpower',
      'text': 'Streaks are built day by day. Missing once doubles the chance of missing twice.',
    },
    {
      'emoji': '📈',
      'title': 'Journal entries boost mood',
      'text': 'Users who journal 3+ times a week report significantly higher average mood scores.',
    },
    {
      'emoji': '⚡',
      'title': 'Morning wins set the tone',
      'text': 'Completing 1 task before noon increases daily completion rate by 60%.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _insights.map((insight) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBright, width: 0.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(insight['emoji']!,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight['title']!,
                      style: const TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight['text']!,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
