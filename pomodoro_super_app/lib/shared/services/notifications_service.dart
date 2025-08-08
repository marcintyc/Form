import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  NotificationsService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
      await _plugin.initialize(initSettings);
      _initialized = true;
    } catch (e) {
      debugPrint('Notifications init failed: $e');
    }
  }

  static Future<void> showNow({required String title, required String body}) async {
    try {
      const android = AndroidNotificationDetails(
        'pomodoro_channel',
        'Pomodoro',
        importance: Importance.high,
        priority: Priority.high,
      );
      const ios = DarwinNotificationDetails();
      const details = NotificationDetails(android: android, iOS: ios);
      await _plugin.show(0, title, body, details);
    } catch (e) {
      debugPrint('Notification show failed: $e');
    }
  }
}