// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:change_case/change_case.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

Future<String> getCISession() async {
  try {
    // Assuming you have a function to make the HTTP request
    final response = await http.get(
      Uri.parse('http://10.220.20.12/index.php/home/login'),
      headers: <String, String>{
        "Host": "10.220.20.12",
        "Cache-Control": "max-age=0",
        "Upgrade-Insecure-Requests": "1",
        "Origin": "http://10.220.20.12",
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.5195.102 Safari/537.36",
        "Accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      },
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
    throw Exception('$e');
  }
}

Future<UsageData> getUsageData(String username, String password) async {
  try {
    final ciSession = await getCISession();

    final loginResponse = await loginIusers(username, password, ciSession);

    if (loginResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

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
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get usage data: ${loginResponse.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to get usage data: $e');
  }
}

Future<http.Response> loginIusers(String username, String password,
    [ciSession]) async {
  try {
    final response = await http.post(
        Uri.parse('http://10.220.20.12/index.php/home/loginProcess'),
        headers: <String, String>{
          "Host": "10.220.20.12",
          "Cache-Control": "max-age=0",
          "Upgrade-Insecure-Requests": "1",
          "Origin": "http://10.220.20.12",
          "Content-Type": "application/x-www-form-urlencoded",
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.5195.102 Safari/537.36",
          "Accept":
              "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
          "Cookie": ciSession,
        },
        body: <String, String>{
          'username': username,
          'password': password,
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to login. status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}
