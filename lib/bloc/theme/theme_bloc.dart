import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';
part 'theme_config.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial(themeMode: ThemeMode.system)) {
    on<ThemeEvent>((event, emit) async {
      if (event is ToggleThemeEvent) {
        await _toggleTheme();
        emit(ThemeToggled(themeMode: themeMode));
      }
    });

    _loadInitialTheme();
  }

  static ThemeMode themeMode = ThemeMode.system;

  Future<void> _loadInitialTheme() async {
    themeMode = await _loadTheme();
    add(InitialThemeLoadedEvent(themeMode: themeMode));
  }

  static Future<ThemeMode> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString("theme_mode");
    if (savedTheme is! String) {
      return ThemeMode.system;
    } else {
      return _getThemeMode(savedTheme);
    }
  }

  static ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  Future<void> _toggleTheme() async {
    try {
      if (themeMode == ThemeMode.light) {
        await _setTheme('dark');
      } else {
        await _setTheme('light');
      }
    } catch (error) {
      print('Error toggling theme: $error');
    }
  }

  Future<void> _setTheme(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("theme_mode", theme);
      themeMode = _getThemeMode(theme);
    } catch (error) {
      throw Exception('Error setting theme: $error');
    }
  }
}
