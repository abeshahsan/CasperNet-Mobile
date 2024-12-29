import 'package:caspernet/components.dart';
import 'package:caspernet/providers/xiaomi_router_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/accounts.dart';
import 'package:provider/provider.dart';

class UsersRoute extends StatefulWidget {
  const UsersRoute({super.key});

  @override
  State<UsersRoute> createState() => _UsersRouteState();
}

class _UsersRouteState extends State<UsersRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Users',
      ),
      body: Consumer<XiaomiRouterSettingsProvider>(
          builder: (routerContext, rsProvider, _) {
        return PopScope(
          canPop: !rsProvider.selectUserOn,
          onPopInvokedWithResult: (didPop, result) =>
              rsProvider.selectUserOn = false,
          child: FutureBuilder<String>(
            future: rsProvider.currentUser,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  rsProvider.currentUser == Future.value("")) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return snapshotErrorWidget();
              } else {
                return Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: rsProvider.selectUserOn
                            ? _buildSelectUserList(snapshot)
                            : _buildUsersList(snapshot),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          rsProvider.selectUserOn = true;
                        },
                        child: const Text('Change User'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }

  Widget snapshotErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'An error occurred.',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(AsyncSnapshot<String> snapshot) {
    final accounts = getAccounts();

    return ListView.builder(
      itemCount: accounts.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        var account = accounts[index];
        bool isSelected = snapshot.data == account[0];

        return Card(
          elevation: isSelected ? 4.0 : 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(
              account[0],
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 18,
                color:
                    isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
            subtitle: isSelected
                ? const Text(
                    "Current User",
                    style: TextStyle(color: Colors.blueGrey),
                  )
                : null,
            leading: CircleAvatar(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.account_circle, color: Colors.blue),
            ),
            trailing: isSelected
                ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildSelectUserList(AsyncSnapshot<String> snapshot) {
    final accounts = getAccounts();

    return ListView.builder(
      itemCount: accounts.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        var account = accounts[index];
        bool isSelected = snapshot.data == account[0];

        return GestureDetector(
          onTap: () {
            context.read<XiaomiRouterSettingsProvider>().changeUser(account);
          },
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: isSelected
                  ? const BorderSide(color: Colors.blue, width: 2.0)
                  : BorderSide.none,
            ),
            child: ListTile(
              title: Text(
                account[0],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.account_circle, color: Colors.blue),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle,
                      color: Colors.green, size: 24)
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
