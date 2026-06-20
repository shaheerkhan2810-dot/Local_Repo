import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/notification_provider.dart';

class NotificationSettingsTile extends ConsumerWidget {
  const NotificationSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBright, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGold,
                letterSpacing: 2,
              ),
            ),
          ),
          _ToggleTile(
            title: 'Morning Reminder',
            subtitle: settings.morningReminderTime,
            value: settings.morningReminderEnabled,
            onChanged: (val) => ref
                .read(notificationSettingsProvider.notifier)
                .update(settings.copyWith(morningReminderEnabled: val)),
          ),
          const Divider(height: 1, indent: 16, color: AppColors.surfaceBright),
          _ToggleTile(
            title: 'Evening Check-In',
            subtitle: settings.eveningCheckInTime,
            value: settings.eveningCheckInEnabled,
            onChanged: (val) => ref
                .read(notificationSettingsProvider.notifier)
                .update(settings.copyWith(eveningCheckInEnabled: val)),
          ),
          const Divider(height: 1, indent: 16, color: AppColors.surfaceBright),
          _ToggleTile(
            title: 'Milestone Alerts',
            subtitle: 'Celebrate streak milestones',
            value: settings.streakMilestoneAlerts,
            onChanged: (val) => ref
                .read(notificationSettingsProvider.notifier)
                .update(settings.copyWith(streakMilestoneAlerts: val)),
          ),
          const Divider(height: 1, indent: 16, color: AppColors.surfaceBright),
          _ToggleTile(
            title: 'Daily Motivation',
            subtitle: 'Motivational quote at 9:00 AM',
            value: settings.dailyMotivationEnabled,
            onChanged: (val) => ref
                .read(notificationSettingsProvider.notifier)
                .update(settings.copyWith(dailyMotivationEnabled: val)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          color: AppColors.textHint,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGreen,
        inactiveThumbColor: AppColors.textSecondary,
        inactiveTrackColor: AppColors.surfaceBright,
      ),
    );
  }
}
