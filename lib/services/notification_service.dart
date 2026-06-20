import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../core/constants/app_constants.dart';
import '../models/notification_setting.dart';

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId = 'apexforge_main';
  static const _channelName = 'ApexForge Notifications';

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Route is handled by go_router via payload
  }

  static Future<void> scheduleAll(NotificationSetting settings) async {
    await cancelAll();

    if (settings.morningReminderEnabled) {
      await _scheduleDailyNotification(
        id: 1,
        title: 'Good morning, Warrior 🔥',
        body: 'Your discipline defines you. Make today count.',
        timeStr: settings.morningReminderTime,
        payload: '/home',
      );
    }

    if (settings.eveningCheckInEnabled) {
      await _scheduleDailyNotification(
        id: 2,
        title: 'Daily Debrief ✅',
        body: 'Log your wins before you sleep. Reflect. Improve.',
        timeStr: settings.eveningCheckInTime,
        payload: '/journal/new',
      );
    }

    if (settings.dailyMotivationEnabled) {
      final quote = AppConstants.motivationalQuotes[
          Random().nextInt(AppConstants.motivationalQuotes.length)];
      await _scheduleDailyNotification(
        id: 3,
        title: 'Daily Fuel ⚡',
        body: quote,
        timeStr: '09:00',
        payload: '/home',
      );
    }
  }

  static Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required String timeStr,
    String? payload,
  }) async {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  static Future<void> showMilestoneNotification(int streakDays) async {
    final label = AppConstants.milestoneLabels[streakDays] ?? '$streakDays days';
    await _plugin.show(
      100 + streakDays,
      '🏆 MILESTONE REACHED!',
      '$streakDays days clean. $label. You are unstoppable.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          enableLights: true,
          playSound: true,
          ledColor: const Color(0xFFFFD700),
          ledOnMs: 500,
          ledOffMs: 500,
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true),
      ),
      payload: '/streak',
    );
  }

  static Future<void> showUrgeNotification() async {
    await _plugin.show(
      200,
      'Stay strong 💪',
      'You\'ve logged an urge. Use a coping tool — you\'ve got this.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true),
      ),
      payload: '/streak',
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
