import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/iusers/usage_table.dart';
import 'package:caspernet/pages/users_page.dart';
import 'package:caspernet/bloc/internet_usage/internet_usage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget _buildUsageData(List<UsageData> usageDataList) {
  return UsageTable(usageDataList);
}

class InternetUsagePage extends StatelessWidget {
  const InternetUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: BlocBuilder<InternetUsageBloc, InternetUsageState>(
            builder: (context, state) {
              if (state is InternetUsageLoading) {
                return _buildLoadingIndicator();
              } else if (state is InternetUsageError) {
                return Center(
                    child: Text('No data available: ${state.message}'));
              } else if (state is InternetUsageLoaded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: _buildUsageData(state.usageData),
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
                  builderContext,
                  MaterialPageRoute(builder: (context) => const UsersRoute()),
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
}
