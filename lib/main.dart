// import 'package:caspernet/get_usage.dart';
import 'package:caspernet/usage_data.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/get_usage.dart';

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

  @override
  void initState() {
    super.initState();
    usageDataAll = accounts
        .map((account) => getUsageData(account[0], account[1]))
        .toList();
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildUsageData(List<UsageData> usageDataList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: usageDataList.map((data) => Text(data.toString())).toList(),
    );
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
        body: FutureBuilder<List<UsageData>>(
          future: Future.wait(usageDataAll),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Center(
                  child: _buildUsageData(snapshot.data!),
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
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
      ),
    );
  }
}
