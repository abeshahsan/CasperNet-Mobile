// import 'package:caspernet/get_usage.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildUsageData(List<UsageData> usageDataList) {
    return Column(
      children: usageDataList.map((data) => Text(data.toString())).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<List> accounts = getAccounts();
    usageDataAll =
        accounts.map((account) => loginIusers(account[0], account[1])).toList();

    return MaterialApp(
      title: 'Internet Usage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
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
      ),
    );
  }
}
