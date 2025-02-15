import 'dart:convert';

import 'package:caspernet/accounts.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'iusers/get_usage.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == "notification_internet_usage") {
        // List<UsageData> usageData = await _loadFromSharedPreferences();
        await _showNotification(<UsageData>[]);
      }
      return Future.value(true);
    } catch (e) {
      debugPrint('Error executing task: $e');
      return Future.value(false);
    }
  });
}

// ignore: unused_element
Future<void> _updateInternetUsage() async {
  final prefs = await SharedPreferences.getInstance();

  try {
    List<List> accounts = getAccounts();
    List<UsageData> usageDataAll = await Future.wait(
      accounts.map((account) => getUsageData(account[0], account[1])).toList(),
    ).timeout(const Duration(seconds: 10), onTimeout: () {
      return <UsageData>[];
    });

    if (usageDataAll.isNotEmpty) {
      await prefs.setStringList(
        'usageData',
        usageDataAll.map((data) => jsonEncode(data.toJson())).toList(),
      );
    }

    await _saveToSharedPreferences(usageDataAll);
  } catch (e) {
    print(e);
  }
}

// ignore: unused_element
Future<List<UsageData>> _loadFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> jsonData = prefs.getStringList('usageData') ?? <String>[];
  List<UsageData> usageData =
      jsonData.map((data) => UsageData.fromJson(jsonDecode(data))).toList();
  return usageData;
}

Future<void> _saveToSharedPreferences(List<UsageData> usageData) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> jsonData =
      usageData.map((data) => jsonEncode(data.toJson())).toList();
  await prefs.setStringList('usageData', jsonData);
}

Future<void> _showNotification(List<UsageData> usageData) async {
  Map<String, dynamic> data = {
    'id': 0,
    'title': 'Internet Usage',
    'body': 'Check your internet usage',
  };
  try {
    NotificationService notificationService =
        await NotificationService.getInstance();
    notificationService.showNotification(data);
  } catch (e) {
    debugPrint('Failed to show notification: $e');
    throw Exception('Failed to show notification: $e');
  }
}
