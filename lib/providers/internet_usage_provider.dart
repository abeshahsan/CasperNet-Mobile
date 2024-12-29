import 'package:caspernet/accounts.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:flutter/material.dart';

class InternetUsageProvider extends ChangeNotifier {
  List<Future<UsageData>> usageDataAll = [];
  List<List> accounts = getAccounts();

  InternetUsageProvider() {
    usageDataAll = accounts
        .map((account) => getUsageData(account[0], account[1]))
        .toList();
  }

  List<Future<UsageData>> get usageData => usageDataAll;

  List<List> get accountData => accounts;

  void refreshData() {
    usageDataAll = accounts
        .map((account) => getUsageData(account[0], account[1]))
        .toList();
    notifyListeners();
  }
}
