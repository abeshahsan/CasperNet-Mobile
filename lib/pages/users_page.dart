import 'package:caspernet/components.dart';
import 'package:caspernet/bloc/router/router_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caspernet/accounts.dart';

class UsersRoute extends StatefulWidget {
  const UsersRoute({super.key});

  @override
  State<UsersRoute> createState() => _UsersRouteState();
}

class _UsersRouteState extends State<UsersRoute> {
  bool selectUserOn = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04; // Adjust the multiplier as needed

    return Scaffold(
      appBar: const MyAppBar(
        title: 'Users',
      ),
      body: BlocBuilder<RouterBloc, RouterState>(
        builder: (context, state) {
          if (state is RouterLoggingIn || state is RouterDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RouterError) {
            return errorWidget(state.message);
          } else if (state is RouterLoggedIn) {
            context.read<RouterBloc>().add(RefreshDataEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is RouterDataLoaded) {
            return _mainContainer(state.data, fontSize);
          } else if (state is RouterDataSent) {
            return _mainContainer(state.data, fontSize);
          } else {
            return errorWidget('No data found');
          }
        },
      ),
    );
  }

  Widget _mainContainer(String currentUser, double fontSize) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: _buildUserList(currentUser, fontSize, selectUserOn),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectUserOn = !selectUserOn;
              });
            },
            child: const Text('Change User'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget errorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred: $message',
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context.read<RouterBloc>().add(SetupRouterEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(
      String currentUser, double fontSize, bool isSelectable) {
    final accounts = getAccounts();

    return ListView.builder(
      itemCount: accounts.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        var account = accounts[index];
        bool isSelected = currentUser == account[0];

        return GestureDetector(
          onTap: isSelectable
              ? () {
                  selectUserOn = false;
                  context.read<RouterBloc>().add(SendDataEvent({
                        'username': account[0],
                        'password': account[1],
                      }));
                }
              : null,
          child: Card(
            elevation: isSelected ? 4.0 : 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: isSelected
                  ? const BorderSide(color: Colors.blue, width: 2.0)
                  : BorderSide.none,
            ),
            child: ListTile(
              title: Text(
                account[0],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize,
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                child: const Icon(Icons.account_circle, color: Colors.blue),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle,
                      color: Colors.green, size: 24)
                  : isSelectable
                      ? const Icon(Icons.circle_outlined, color: Colors.grey)
                      : null,
            ),
          ),
        );
      },
    );
  }
}
