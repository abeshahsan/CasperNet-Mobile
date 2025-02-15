part of 'theme_bloc.dart';

class ThemeConfig {
  // Define a consistent seed color
  static const MaterialColor _seedColor = Colors.blue;

  // Light Theme
  static ThemeData lightTheme() => ThemeData(
        useMaterial3: true,
        fontFamily: 'GGSans',
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
  static ThemeData darkTheme() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'GGSans',
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
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          color:
              brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color:
              brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        bodyMedium: TextStyle(
          color:
              brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        displaySmall: TextStyle(
          color:
              brightness == Brightness.light ? Colors.black : Colors.white,
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
          textStyle: TextStyle(fontWeight: FontWeight.w600),
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
          textStyle: TextStyle(fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
}
