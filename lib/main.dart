import 'package:caspernet/app_global.dart';
import 'package:caspernet/bloc/internet_usage/internet_usage_bloc.dart';
import 'package:caspernet/bloc/router/router_bloc.dart';
import 'package:caspernet/bloc/theme/theme_bloc.dart';
import 'package:caspernet/components.dart';
import 'package:caspernet/pages/internet_usage_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
    BlocProvider<InternetUsageBloc>(create: (context) => InternetUsageBloc()),
    BlocProvider<RouterBloc>(create: (context) => RouterBloc()),
  ], child: const MyApp()));
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
        navigatorKey: AppGlobal.navigatorKey,
        home: Scaffold(
          appBar: const MyAppBar(
            title: 'Internet Usage',
          ),
          body: const InternetUsagePage(),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  context
                      .read<InternetUsageBloc>()
                      .add(RefreshInternetUsageEvent());
                },
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }
}
