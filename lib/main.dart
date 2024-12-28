import 'package:caspernet/app_global.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/theme_config.dart';
import 'package:caspernet/pages/internet_usage_page.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accounts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  AppGlobal.themeManager = ThemeModeManager(prefs);
  
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
            theme: ThemeConfig.lightTheme(context),
            darkTheme: ThemeConfig.darkTheme(context),
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
