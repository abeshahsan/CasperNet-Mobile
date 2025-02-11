import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'theme_event.dart';
part 'theme_state.dart';
part 'theme_config.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial(themeMode: ThemeMode.light)) {
    on<ThemeToggleEvent>(_onThemeToggled);
  }

  void _onThemeToggled(ThemeToggleEvent event, Emitter<ThemeState> emit) {
    ThemeMode newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeInitial(themeMode: newThemeMode));
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    return ThemeInitial(themeMode: ThemeMode.values
        .firstWhere((element) => element.toString() == json['theme']));
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    return {'theme': state.themeMode.toString()};
  }
}
