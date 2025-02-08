import 'package:caspernet/routers/base_router/base_router.dart';
import 'package:caspernet/routers/xiaomi_router/xiaomi_router.dart';
import 'package:flutter/material.dart';

class RouterProvider with ChangeNotifier {
  Future<String> _currentUser = Future.value("");
  RoomRouter router = XiaomiRouter('admin', '517@sataamab');

  RouterProvider() {
    _setupRouting();
  }

  Future<void> _setupRouting() async {
    try {
      await router.login();
      //   print('Login Success');
      _currentUser = router.getUserInfo();
      notifyListeners();
    } catch (e) {
      print('Failed to initialize XiaomiRouter: $e');
    }
  }

  Future<void> refreshData() async {
    _currentUser = router.getUserInfo();
    notifyListeners();
  }

  Future<String> get currentUser => _currentUser;

  Future<void> changeUser(List<dynamic> user) async {
    try {
      await router.setUserInfo(user[0], user[1]);
      _currentUser = Future.value(user[0]);
      notifyListeners();
    } catch (e) {
      _currentUser = Future.value("");
    }
  }
}
