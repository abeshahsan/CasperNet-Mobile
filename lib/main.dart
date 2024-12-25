// import 'package:caspernet/get_usage.dart';
import 'package:caspernet/internet_usage_page.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/iusers/get_usage.dart';

import 'accounts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Future<UsageData>> usageDataAll;
  List<List> accounts = getAccounts();

  String route = 'users';

  @override
  void initState() {
    super.initState();
    usageDataAll = accounts
        .map((account) => getUsageData(account[0], account[1]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CasprNet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Internet Usage'),
          ),
          body: Builder(
            builder: (BuildContext builderContext) {
              return getUsagePage(builderContext, usageDataAll, accounts);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                usageDataAll = accounts
                    .map((account) => getUsageData(account[0], account[1]))
                    .toList();
              });
            },
            child: const Icon(Icons.refresh),
          ),
        ));
  }
}
