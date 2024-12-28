import 'package:caspernet/themeconfig.dart';
import 'package:flutter/material.dart';

class AppGlobal {
  AppGlobal._();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static late final ThemeModeManager themeManager;
}
