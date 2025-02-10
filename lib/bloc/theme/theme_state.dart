part of 'theme_bloc.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({this.themeMode = ThemeMode.system});
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({required super.themeMode});
}

class ThemeToggled extends ThemeState {
  const ThemeToggled({required super.themeMode});
}
