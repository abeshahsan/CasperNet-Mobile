import 'package:caspernet/app_global.dart';
import 'package:caspernet/providers/internet_usage_provider.dart';
import 'package:caspernet/providers/theme_provider.dart';
import 'package:caspernet/providers/xiaomi_router_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/theme_config.dart';
import 'package:caspernet/pages/internet_usage_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
    ChangeNotifierProvider(create: (_) => InternetUsageProvider()),
    ChangeNotifierProvider(create: (_) => XiaomiRouterSettingsProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeProvider>(builder: (themeProviderContext, themeProvider, __) {
      return MaterialApp(
        title: 'Internet Usage',
        theme: ThemeConfig.lightTheme(themeProviderContext),
        darkTheme: ThemeConfig.darkTheme(themeProviderContext),
        themeMode: themeProvider.themeMode,
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
