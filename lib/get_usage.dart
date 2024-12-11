import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

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

Future<Album> loginIusers() async {
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
          'username': 'abeshahsan',
          'password': '[AbeshAhsan]',
        });

    Map<String, dynamic> json = {};

    json['userId'] = 1;
    json['id'] = 1;
    json['title'] = 'worked so far';

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      String htmlContent = response.body;

      json['title'] = response.body;

      var document = html.parse(htmlContent);

      var rows = document.querySelectorAll('table')[0].querySelectorAll('tr');
      List<String> dataList = [];
      for (var row in rows) {
        var cells = row.querySelectorAll('td');
        if (cells.isNotEmpty) {
          {
            String entry = cells[0].text.toLowerCase().split(":")[0];
            print(entry);
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

      json['title'] = dataList.join(', ');
      //   json['title'] = data[0];

      return Album.fromJson(json);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
