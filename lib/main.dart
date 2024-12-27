import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/internet_usage_page.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'accounts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Future<UsageData>> usageDataAll;
  List<List> accounts = getAccounts();
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    usageDataAll = accounts
        .map((account) => getUsageData(account[0], account[1]))
        .toList();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('themeMode') ?? 'system';
    setState(() {
      themeMode = _themeFromString(theme);
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', _themeToString(mode));
  }

  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  ThemeMode _themeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CasprNet',
      theme: Mytheme.lightTheme(context),
      darkTheme: Mytheme.darkTheme(context),
      themeMode: themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Internet Usage'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  themeMode = themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                });
                _saveThemeMode(themeMode);
              },
              icon: const Icon(Icons.brightness_4),
            ),
          ],
        ),
        body: Builder(
          builder: (BuildContext builderContext) {
            return getUsagePage(builderContext, usageDataAll, accounts);
          },
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
  }
}
