import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    //   Request permission for Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future showPeriodicNotifications(
      {required String title,
      required String body,
      required String payload}) async {
    const NotificationDetails platformChannelSpecific = NotificationDetails(
        android: AndroidNotificationDetails(
          'sober_journey_channel_id',
          'Sober Journey Notifications',
          channelDescription:
              'Notifications for sobriety reminders and updates',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: DarwinNotificationDetails());
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0, title, body, RepeatInterval.everyMinute, platformChannelSpecific,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }
}
