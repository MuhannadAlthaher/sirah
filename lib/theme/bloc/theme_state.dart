import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The app's current theme mode. [ThemeMode.system] ("Auto") follows
/// the device's own light/dark setting.
class ThemeState extends Equatable {
  const ThemeState({required this.mode});

  factory ThemeState.initial() => const ThemeState(mode: ThemeMode.system);

  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];

  ThemeState copyWith({ThemeMode? mode}) => ThemeState(mode: mode ?? this.mode);
}
