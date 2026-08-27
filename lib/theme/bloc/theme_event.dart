import 'package:flutter/material.dart';

/// Events the UI dispatches to [ThemeBloc].
sealed class ThemeEvent {
  const ThemeEvent();
}

/// The user picked a theme mode from Settings (Auto/Light/Dark).
class ThemeModeChanged extends ThemeEvent {
  const ThemeModeChanged(this.mode);

  final ThemeMode mode;
}
