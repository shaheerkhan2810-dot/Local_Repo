import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_setting.dart';
import '../services/notification_service.dart';
import '../services/hive_service.dart';

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSetting>(
        (ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettingsNotifier extends StateNotifier<NotificationSetting> {
  NotificationSettingsNotifier() : super(const NotificationSetting()) {
    _load();
  }

  void _load() {
    final data = HiveService.getSetting<Map>('notification_settings');
    if (data != null) {
      state = NotificationSetting.fromMap(Map<String, dynamic>.from(data));
    }
  }

  Future<void> update(NotificationSetting settings) async {
    state = settings;
    await HiveService.saveSetting('notification_settings', settings.toMap());
    await NotificationService.scheduleAll(settings);
  }

  Future<void> toggle({
    bool? morningEnabled,
    bool? eveningEnabled,
    bool? milestoneEnabled,
    bool? motivationEnabled,
  }) async {
    final updated = state.copyWith(
      morningReminderEnabled: morningEnabled,
      eveningCheckInEnabled: eveningEnabled,
      streakMilestoneAlerts: milestoneEnabled,
      dailyMotivationEnabled: motivationEnabled,
    );
    await update(updated);
  }
}
