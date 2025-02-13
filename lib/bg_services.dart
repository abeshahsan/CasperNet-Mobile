import 'dart:convert';
import 'package:caspernet/accounts.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'iusers/get_usage.dart';
import 'notification_service.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "increment_counter") {
      await _updateInternetUsage();
    } else if (task == "notification_internet_usage") {
      List<UsageData> usageData = await _loadFromSharedPreferences();
      await _showNotification(usageData);
    }
    return Future.value(true);
  });
}

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
  await NotificationService().showNotification(data);
}
