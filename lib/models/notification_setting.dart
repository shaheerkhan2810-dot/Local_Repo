class NotificationSetting {
  final bool morningReminderEnabled;
  final String morningReminderTime;
  final bool eveningCheckInEnabled;
  final String eveningCheckInTime;
  final bool streakMilestoneAlerts;
  final bool dailyMotivationEnabled;
  final int urgeAlertCooldownMinutes;

  const NotificationSetting({
    this.morningReminderEnabled = true,
    this.morningReminderTime = '07:00',
    this.eveningCheckInEnabled = true,
    this.eveningCheckInTime = '21:00',
    this.streakMilestoneAlerts = true,
    this.dailyMotivationEnabled = true,
    this.urgeAlertCooldownMinutes = 60,
  });

  factory NotificationSetting.fromMap(Map<String, dynamic> map) {
    return NotificationSetting(
      morningReminderEnabled: map['morningReminderEnabled'] as bool? ?? true,
      morningReminderTime: map['morningReminderTime'] as String? ?? '07:00',
      eveningCheckInEnabled: map['eveningCheckInEnabled'] as bool? ?? true,
      eveningCheckInTime: map['eveningCheckInTime'] as String? ?? '21:00',
      streakMilestoneAlerts: map['streakMilestoneAlerts'] as bool? ?? true,
      dailyMotivationEnabled: map['dailyMotivationEnabled'] as bool? ?? true,
      urgeAlertCooldownMinutes: map['urgeAlertCooldownMinutes'] as int? ?? 60,
    );
  }

  Map<String, dynamic> toMap() => {
        'morningReminderEnabled': morningReminderEnabled,
        'morningReminderTime': morningReminderTime,
        'eveningCheckInEnabled': eveningCheckInEnabled,
        'eveningCheckInTime': eveningCheckInTime,
        'streakMilestoneAlerts': streakMilestoneAlerts,
        'dailyMotivationEnabled': dailyMotivationEnabled,
        'urgeAlertCooldownMinutes': urgeAlertCooldownMinutes,
      };

  NotificationSetting copyWith({
    bool? morningReminderEnabled,
    String? morningReminderTime,
    bool? eveningCheckInEnabled,
    String? eveningCheckInTime,
    bool? streakMilestoneAlerts,
    bool? dailyMotivationEnabled,
    int? urgeAlertCooldownMinutes,
  }) {
    return NotificationSetting(
      morningReminderEnabled:
          morningReminderEnabled ?? this.morningReminderEnabled,
      morningReminderTime: morningReminderTime ?? this.morningReminderTime,
      eveningCheckInEnabled:
          eveningCheckInEnabled ?? this.eveningCheckInEnabled,
      eveningCheckInTime: eveningCheckInTime ?? this.eveningCheckInTime,
      streakMilestoneAlerts:
          streakMilestoneAlerts ?? this.streakMilestoneAlerts,
      dailyMotivationEnabled:
          dailyMotivationEnabled ?? this.dailyMotivationEnabled,
      urgeAlertCooldownMinutes:
          urgeAlertCooldownMinutes ?? this.urgeAlertCooldownMinutes,
    );
  }
}
