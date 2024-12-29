import 'package:caspernet/app_global.dart';
import 'package:caspernet/themeconfig.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/theme_config.dart';
import 'package:caspernet/pages/internet_usage_page.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'accounts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeModeProvider(prefs))
  ], child: const MyApp()));
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
    return Consumer<ThemeModeProvider>(builder: (themeProviderContext, _, __) {
      return MaterialApp(
        title: 'Internet Usage',
        theme: ThemeConfig.lightTheme(themeProviderContext),
        darkTheme: ThemeConfig.darkTheme(themeProviderContext),
        themeMode: themeProviderContext.watch<ThemeModeProvider>().themeMode,
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
                    return getUsagePage(builderContext, usageDataAll, accounts);
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
