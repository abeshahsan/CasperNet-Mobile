import 'package:caspernet/xiaomi_router/get_data.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/accounts.dart';

class UsersRoute extends StatefulWidget {
  const UsersRoute({super.key});

  @override
  State<UsersRoute> createState() => _UsersRouteState();
}

class _UsersRouteState extends State<UsersRoute> {
  late Future<String> currentUser;
  String token = "";
  bool selectUserOn = false;

  @override
  void initState() {
    super.initState();
    currentUser = Future.value("");
    getToken().then((value) => setState(() {
          token = value;
          currentUser = getCurrentUSer(token);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: PopScope(
        canPop: !selectUserOn,
        onPopInvokedWithResult: (didPop, result) => {
          setState(() {
            selectUserOn = false;
          })
        },
        child: FutureBuilder<String>(
          future: currentUser,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('An error occurred.'));
            } else {
              return Center(
                child: Column(
                  children: [
                    Expanded(
                      child: selectUserOn
                          ? _buildSelectUserList(snapshot)
                          : _buildUsersList(snapshot),
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
          },
        ),
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
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
            subtitle: isSelected
                ? const Text(
                    "Current User",
                    style: TextStyle(color: Colors.blueGrey),
                  )
                : null,
            leading: CircleAvatar(
              backgroundColor:
                  isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
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
            setState(() {
              changeCurrentUser(token, account).then((value) {
                currentUser = Future.value(account[0]);
                selectUserOn = false;
              });
            });
          },
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: isSelected
                  ? BorderSide(color: Colors.blue, width: 2.0)
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
