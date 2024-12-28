import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/iusers/usage_table.dart';
import 'package:caspernet/pages/users_page.dart';
import 'package:flutter/material.dart';

Widget _buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget _buildUsageData(List<UsageData> usageDataList) {
  return UsageTable(usageDataList);
}

Widget getUsagePage(BuildContext context, List<Future<UsageData>> usageDataAll,
    List<List> accounts) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: FutureBuilder<List<UsageData>>(
          future: Future.wait(usageDataAll).timeout(const Duration(seconds: 10)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('No data available'));
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: _buildUsageData(snapshot.data!),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (BuildContext builderContext) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                builderContext, // Use builderContext here
                MaterialPageRoute(builder: (context) => UsersRoute()),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text('See Users'),
          ),
        ),
      ),
    ],
  );
}
