import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/iusers/usage_table.dart';
import 'package:caspernet/pages/users_page.dart';
import 'package:caspernet/bloc/internet_usage/internet_usage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _buildUsageData(List<UsageData>? usageDataList) {
  if (usageDataList == null) {
    return const Text('No data available');
  }
  return UsageTable(usageDataList);
}

class InternetUsagePage extends StatelessWidget {
  const InternetUsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // a refresh button with proper messages
        BlocBuilder<InternetUsageBloc, InternetUsageState>(
          builder: (context, state) {
            String message;
            if (state is InternetUsageLoading) {
              message = "Fetching data...";
            } else if (state is InternetUsageError) {
              message = "Error. Try again";
            } else if (state is InternetUsageLoaded) {
              message = "Data fetched";
            } else {
              message = "Messages will appear here";
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (state is InternetUsageLoading) {
                      return;
                    }
                    context
                        .read<InternetUsageBloc>()
                        .add(RefreshInternetUsageEvent());
                  },
                  icon: state is InternetUsageLoading
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child:
                              const CircularProgressIndicator(strokeWidth: 1.5),
                        )
                      : const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                ),
              ],
            );
          },
        ),
        Expanded(
          child: BlocBuilder<InternetUsageBloc, InternetUsageState>(
            // buildWhen: (previous, current) => current is InternetUsageLoaded,
            builder: (context, state) {
              if (state is InternetUsageLoading ||
                  state is InternetUsageLoaded ||
                  state is InternetUsageError ||
                  state is InternetUsageTimeout) {
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
