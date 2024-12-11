// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

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

Future<UsageData> loginIusers(String username, String password) async {
  try {
    final ciSession = await getCISession();
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

      String htmlContent = response.body;

      var document = html.parse(htmlContent);

      var rows = document.querySelectorAll('table')[0].querySelectorAll('tr');
      List<String> dataList = [];
      for (var row in rows) {
        var cells = row.querySelectorAll('td');
        if (cells.isNotEmpty) {
          {
            String entry = cells[0].text.toLowerCase().split(":")[0];
            if (entry == 'username' ||
                entry == 'group' ||
                entry == 'free limit') {
              continue;
            } else if (entry == 'total use' ||
                entry == 'estimated bill' ||
                entry == 'extra use') {
              cells[1].text = cells[1].text.split(' ')[0];
            }
          }
          dataList.add(cells[1].text);
        }
      }

      return UsageData.fromArray(dataList);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  } catch (e) {
    throw Exception('Failed to load album');
  }
}

List<dynamic> getUsageData() {
  return [
    ['Abesh Ahsan', 'abeshahsan', 0, 0, 0],
    ['Rahiduzzaman', 'rahiduzzaman', 0, 0, 0],
    ['Rezwan Islam', 'rezwanislam', 0, 0, 0],
    ['Amit20', 'amit20', 0, 0, 0],
  ];
}

class UsageData {
  String fullName;
  String id;
  int usedMins;
  int billAmount;
  static final int totalMins = 13200;
  int exceededMins;

  UsageData({
    required this.fullName,
    required this.id,
    required this.usedMins,
    required this.billAmount,
    required this.exceededMins,
  });

  factory UsageData.fromArray(List<String> data) {
    return UsageData(
      fullName: data[0],
      id: data[1],
      usedMins: int.tryParse(data[2]) ?? 0,
      exceededMins: int.tryParse(data[3]) ?? 0,
      billAmount: int.tryParse(data[4]) ?? 0,
    );
  }

  @override
  String toString() {
    return 'Name: $fullName\nID: $id\nUsed Minutes: $usedMins\nBill Amount: $exceededMins\nExceeded Minutes: $billAmount';
  }
}
