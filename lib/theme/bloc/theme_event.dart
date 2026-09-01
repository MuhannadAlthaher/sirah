import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Events the UI dispatches to [ThemeBloc].
sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// The user picked a theme mode from Settings (Auto/Light/Dark).
class ThemeModeChanged extends ThemeEvent {
  const ThemeModeChanged(this.mode);

  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];
}
