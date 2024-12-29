import 'package:caspernet/app_global.dart';
import 'package:caspernet/providers/internet_usage_provider.dart';
import 'package:caspernet/providers/theme_provider.dart';
import 'package:caspernet/providers/xiaomi_router_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/theme_config.dart';
import 'package:caspernet/pages/internet_usage_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeModeProvider(prefs)),
    ChangeNotifierProvider(create: (_) => InternetUsageProvider()),
    ChangeNotifierProvider(create: (_) => XiaomiRouterSettingsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          appBar: const MyAppBar(
            title: 'Internet Usage',
          ),
          body: const InternetUsagePage(),
          floatingActionButton: Consumer<InternetUsageProvider>(
            builder: (context, internetUsageProvider, _) =>
                FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  internetUsageProvider.refreshData();
                },
                child: const Icon(Icons.refresh),
                ),
          ),
        ),
      );
    });
  }
}
