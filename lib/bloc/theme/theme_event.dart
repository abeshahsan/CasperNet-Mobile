part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class ThemeToggledEvent extends ThemeEvent {}

class InitialThemeLoadedEvent extends ThemeEvent {
  final ThemeMode themeMode;

  InitialThemeLoadedEvent({required this.themeMode});
}
