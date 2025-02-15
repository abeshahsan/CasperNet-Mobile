import 'package:caspernet/bg_services.dart';
import 'package:caspernet/bloc/internet_usage/internet_usage_bloc.dart';
import 'package:caspernet/bloc/router/router_bloc.dart';
import 'package:caspernet/bloc/theme/theme_bloc.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/pages/internet_usage_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _requestNotificationPermissions();

  // Initialize WorkManager
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: kDebugMode || kProfileMode,
  );

  // Cancel any previously scheduled task
  await Workmanager().cancelByUniqueName("notification_internet_usage");
//   await Workmanager().cancelByUniqueName("update_internet_usage");

  // Start background task
  await Workmanager().registerPeriodicTask(
    "notification_internet_usage",
    "notification_internet_usage",
    frequency: const Duration(days: 2),
  );

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path));

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      BlocProvider<InternetUsageBloc>(create: (context) => InternetUsageBloc()),
      BlocProvider<RouterBloc>(create: (context) => RouterBloc()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return MaterialApp(
        title: 'Internet Usage',
        theme: ThemeConfig.lightTheme(),
        darkTheme: ThemeConfig.darkTheme(),
        themeMode: state.themeMode,
        home: Scaffold(
          appBar: const MyAppBar(
            title: 'Internet Usage',
          ),
          body: const InternetUsagePage(),
        ),
      );
    });
  }
}

Future<void> _requestNotificationPermissions() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}
