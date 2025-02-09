import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mytheme {
  // Define a consistent seed color
  static const MaterialColor _seedColor = Colors.blue;

  // Light Theme
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey[50], // Light background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black, // For text and icons
          elevation: 0,
          centerTitle: true,
        ),

        textTheme: _textTheme(Brightness.light),
        elevatedButtonTheme: _elevatedButtonTheme(Brightness.light),
        outlinedButtonTheme: _outlinedButtonTheme(Brightness.light),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  // Dark Theme
  static ThemeData darkTheme(BuildContext context) => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.grey[900], // Dark background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white, // For text and icons
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: _textTheme(Brightness.dark),
        elevatedButtonTheme: _elevatedButtonTheme(Brightness.dark),
        outlinedButtonTheme: _outlinedButtonTheme(Brightness.dark),
        cardTheme: CardTheme(
          color: Colors.grey[800],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  // Shared Text Theme
  static TextTheme _textTheme(Brightness brightness) => TextTheme(
        displayLarge: GoogleFonts.oswald(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        titleLarge: GoogleFonts.oswald(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color:
              brightness == Brightness.light ? Colors.black87 : Colors.white70,
        ),
        bodyMedium: GoogleFonts.merriweather(
          fontSize: 16,
          color:
              brightness == Brightness.light ? Colors.black87 : Colors.white70,
        ),
        displaySmall: GoogleFonts.pacifico(
          fontSize: 18,
          color:
              brightness == Brightness.light ? Colors.black54 : Colors.white60,
        ),
      );

  // Elevated Button Theme
  static ElevatedButtonThemeData _elevatedButtonTheme(Brightness brightness) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor:
              brightness == Brightness.light ? Colors.white : Colors.black,
          backgroundColor: brightness == Brightness.light
              ? _seedColor.shade200
              : _seedColor.shade400, // Fixed issue with shade
          textStyle: GoogleFonts.oswald(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  // Outlined Button Theme
  static OutlinedButtonThemeData _outlinedButtonTheme(Brightness brightness) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              brightness == Brightness.light ? _seedColor : _seedColor.shade200,
          side: BorderSide(
            color: brightness == Brightness.light
                ? _seedColor
                : _seedColor.shade200,
          ),
          textStyle: GoogleFonts.oswald(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
}

class ThemeModeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode themeMode = ThemeMode.light;
  late SharedPreferences _prefs;

  ThemeModeProvider() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      _loadTheme();
    });
  }

  void _loadTheme() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme is! String) {
      themeMode = ThemeMode.system;
    } else {
      themeMode = _getThemeMode(savedTheme);
    }
    print('Theme loaded: $themeMode');
    notifyListeners();
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  void toggleTheme() async {
    try {
      if (themeMode == ThemeMode.light) {
        await _setTheme('dark');
      } else {
        await _setTheme('light');
      }
      notifyListeners();
    } catch (error) {
      print('Error toggling theme: $error');
    }
    print('Theme toggled: $themeMode');
  }

  Future<void> _setTheme(String theme) async {
    try {
      await _prefs.setString(_themeKey, theme);
      themeMode = _getThemeMode(theme);
    } catch (error) {
      throw Exception('Error setting theme: $error');
    }
  }
}
