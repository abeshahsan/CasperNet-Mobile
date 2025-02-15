import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  static Future<NotificationService> getInstance() async {
    if (!_instance._isInitialized) {
      await _instance._initialize();
    }
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final NotificationDetails platformChannelSpecifics;

  bool _isInitialized = false;

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

    _isInitialized = true;
  }



  Future<void> showNotification(Map<String, dynamic> data) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        data['id'],
        data['title'],
        data['body'],
        platformChannelSpecifics,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
