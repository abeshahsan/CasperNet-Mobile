// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:caspernet/routers/base_router/base_router.dart';
import 'package:http/http.dart' as http;

class XiaomiRouter extends RoomRouter {
  XiaomiRouter(super.adminUsername, super.adminPassword) {
    login();
  }

  late String token;
  static const String _baseUrl = 'http://192.168.31.1/cgi-bin/luci';
  static const String _loginEndpoint = '/api/xqsystem/login';
  String get _userInfoEndpoint => '/;stok=$token/api/xqnetwork/wan_info';
  String get _changeUserEndpoint => '/;stok=$token/api/xqnetwork/set_wan';

  @override
  Future<void> login() async {
    try {
      final response = await _postLogin();
      if (response.statusCode == 200) {
        token = jsonDecode(response.body)['token'];
      } else {
        throw Exception('Failed to login: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Login Failed: $e');
      throw Exception('Login Failed');
    }
  }

  @override
  Future<String> getUserInfo() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$_userInfoEndpoint'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['info']['details']['username'];
      } else {
        throw Exception('Failed to get user info: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> setUserInfo(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_changeUserEndpoint'),
        body: {
          "wanType": "pppoe",
          "pppoeName": username,
          "pppoePwd": password,
          "autoset": "0",
          "mtu": "1480",
          "special": "0",
          "dns1": "",
          "dns2": ""
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to set user info: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<http.Response> _postLogin() async {
    return await http.post(
      Uri.parse('$_baseUrl$_loginEndpoint'),
      body: <String, String>{
        'username': super.adminUsername,
        'password': super.adminPassword
      },
    );
  }
}
