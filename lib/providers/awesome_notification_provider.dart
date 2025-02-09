import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationProvider with ChangeNotifier {
  final localNotifPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  LocalNotificationProvider() {
    initialize();
  }

  //INITIALIZE LOCAL NOTIFICATION PLUGIN

  Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isAndroid && await _requestAndroidPermissions()) {
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true);

      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);

      await localNotifPlugin.initialize(initializationSettings);

      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<bool> _requestAndroidPermissions() async {
    if (Platform.isAndroid && int.parse(Platform.operatingSystemVersion.split(' ')[0]) >= 33) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  //DETAILS OF THE NOTIFICATION
  NotificationDetails notificationDetails() {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'internet_usage_channel',
      'Internet Usage',
      channelDescription: 'Shows internet usage',
      importance: Importance.max,
      priority: Priority.high,
    );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    return NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
  }

  //SHOW  NOTIFICATION
  Future<void> showNotification() async {
    await localNotifPlugin.show(
      0,
      'Internet Usage',
      'You have used 1GB of data',
      notificationDetails(),
      payload: 'item x',
    );
    notifyListeners();
    print('Notification shown');
  }

  //ON NOTIFICATION CLICK
  void onNotificationClick(String payload) {
    print('Notification clicked');
  }
}
