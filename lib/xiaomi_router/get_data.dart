// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getToken() async {
  try {
    // Assuming you have a function to make the HTTP request
    final response = await http.post(
      Uri.parse('http://192.168.31.1/cgi-bin/luci/api/xqsystem/login'),
      body: <String, String>{
        'username': 'admin',
        'password': '517@sataamab',
      },
    );

    return jsonDecode(response.body)['token'];
  } catch (e) {
    throw Exception('$e');
  }
}

Future<String> getCurrentUSer(String token) async {
  try {
    final response = await http.get(
      Uri.parse(
          'http://192.168.31.1/cgi-bin/luci/;stok=$token/api/xqnetwork/wan_info'),
    );
    final Map<String, dynamic> data = jsonDecode(response.body);

    return data['info']['details']['username'];
  } catch (e) {
    throw Exception('$e');
  }
}

Future<void> changeCurrentUser(String token, List<dynamic> account) async {
  try {
    http.post(
        Uri.parse(
            'http://192.168.31.1/cgi-bin/luci/;stok=$token/api/xqnetwork/set_wan'),
        body: {
          "wanType": "pppoe",
          "pppoeName": account[0],
          "pppoePwd": account[1],
          "autoset": "0",
          "mtu": "1480",
          "special": "0",
          "dns1": "",
          "dns2": ""
        });
  } catch (e) {
    throw Exception('$e');
  }
}
