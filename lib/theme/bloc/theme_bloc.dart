import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/theme/bloc/theme_event.dart';
import 'package:sira/theme/bloc/theme_state.dart';

/// Owns the app's [ThemeMode] (Auto/Light/Dark).
///
/// Provided at the true app root in main.dart, above [MaterialApp] —
/// unlike every other bloc in this app, [MaterialApp] itself needs
/// this one directly (its `themeMode` parameter), so app-root is the
/// correct scope here, not a shortcut.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeModeChanged>(
      (event, emit) => emit(state.copyWith(mode: event.mode)),
    );
  }
}
