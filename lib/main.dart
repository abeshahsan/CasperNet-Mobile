import 'package:caspernet/app_global.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/themeconfig.dart';
import 'package:caspernet/internet_usage_page.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accounts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear any previously saved SharedPreferences
    AppGlobal.themeManager = ThemeModeManager(prefs);
  } catch (e) {
    // Handle the error here, e.g., log it or show a message to the user
    print('Error initializing SharedPreferences: $e');
  }
  runApp(const MyApp());
}

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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppGlobal.themeManager.themeMode,
        builder: (context, ThemeMode themeMode, child) {
          return MaterialApp(
            title: 'Internet Usage',
            theme: Mytheme.lightTheme(context),
            darkTheme: Mytheme.darkTheme(context),
            themeMode: themeMode,
            navigatorKey: AppGlobal.navigatorKey,
            home: Scaffold(
              appBar: MyAppBar(
                title: 'Internet Usage',
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (BuildContext builderContext) {
                        return getUsagePage(
                            builderContext, usageDataAll, accounts);
                      },
                    ),
                  ),
                ],
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
        });
  }
}
