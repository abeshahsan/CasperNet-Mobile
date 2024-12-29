import 'package:caspernet/xiaomi_router/get_data.dart';
import 'package:flutter/material.dart';

class XiaomiRouterSettingsProvider with ChangeNotifier {
  Future<String> _currentUser = Future.value("");
  String token = "";

  XiaomiRouterSettingsProvider() {
    getToken().then((value) {
      token = value;
      _currentUser = getCurrentUSer(token);
      notifyListeners();
    });
  }

  Future<void> refreshData() async {
    _currentUser = getCurrentUSer(token);
    notifyListeners();
  }

  Future<String> get currentUser => _currentUser;

  String get currentToken => token;

  Future<void> changeUser(List<dynamic> user) async {
    try {
      await changeCurrentUser(token, user);
      _currentUser = Future.value(user[0]);
      notifyListeners();
    } catch (e) {
      _currentUser = Future.value("");
    }
  }
}
