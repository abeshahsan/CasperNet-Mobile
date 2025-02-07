// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:change_case/change_case.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'config.dart';

Future<String> getCISession() async {
  try {
    // Assuming you have a function to make the HTTP request
    
    final response = await http.get(
      getLoginUrl(),
      headers: getHeaders(null),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.headers['set-cookie']!.split(';')[0];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to get ci-session. status: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
    throw Exception('$e');
  }
}

Future<UsageData> getUsageData(String username, String password) async {
  try {
    final ciSession = await getCISession();

    final loginResponse = await loginIusers(username, password, ciSession);

    if (loginResponse.statusCode == 200) {
      String htmlContent = loginResponse.body;

      var document = html.parse(htmlContent);

      var rows = document.querySelectorAll('table')[0].querySelectorAll('tr');
      Map<String, String> dataMap = {};
      for (var row in rows) {
        var cells = row.querySelectorAll('td');
        if (cells.isNotEmpty) {
          {
            String key = cells[0].text.toCamelCase().split(":")[0];
            var value = cells[1].text;
            if (key == 'totalUse' ||
                key == 'estimatedBill' ||
                key == 'extraUse') {
              value = value.split(' ')[0];
            }
            dataMap[key] = value;
          }
        }
      }

      return UsageData.fromMap(dataMap);
    } else {
      throw Exception('Failed to get usage data: ${loginResponse.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to get usage data: $e');
  }
}

Future<http.Response> loginIusers(String username, String password,
    [ciSession]) async {
  try {
    final response = await http.post(getLoginProcessUrl(),
        headers: getHeaders(ciSession),
        body: <String, String>{
          'username': username,
          'password': password,
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response;
    } else {
      throw Exception('Failed to login. status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}
