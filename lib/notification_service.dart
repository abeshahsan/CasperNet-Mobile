import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final NotificationDetails platformChannelSpecifics;

  NotificationService() {
    _initialize();
  }

  Future<void> _initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'counter_channel',
      'Counter Updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    platformChannelSpecifics = const NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
  }

  Future<void> showNotification(Map<String, dynamic> data) async {
    await flutterLocalNotificationsPlugin.show(
      data['id'],
      data['title'],
      data['body'],
      platformChannelSpecifics,
    );
  }
}
