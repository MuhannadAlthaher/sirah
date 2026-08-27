import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// The app's two [ThemeData]s. Structure/typography live here;
/// colors live in [AppPalette] (attached below as a
/// [ThemeExtension]) — that's the one file to edit for color changes.
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light, AppPalette.light);
  static ThemeData get dark => _build(Brightness.dark, AppPalette.dark);

  static ThemeData _build(Brightness brightness, AppPalette palette) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    // Rounded, outlined, unfilled fields in the app's own border/accent
    // colors, rather than Material's generic default — this is a global
    // theme, built once independent of any screen's width, so (unlike
    // widget-level layout elsewhere in the app) these few measurements
    // are fixed rather than proportional, the same way text sizes
    // already are via `textTheme` below.
    const fieldRadius = 14.0;
    OutlineInputBorder border(Color color, [double width = 1.4]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: palette.screenBackground,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: palette.accent,
        onPrimary: palette.onAccent,
        surface: palette.surface,
        onSurface: palette.textPrimary,
        error: palette.danger,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: border(palette.border),
        enabledBorder: border(palette.border),
        focusedBorder: border(palette.accent, 2),
        errorBorder: border(palette.danger),
        focusedErrorBorder: border(palette.danger, 2),
        labelStyle: TextStyle(color: palette.textSecondary),
        floatingLabelStyle: TextStyle(color: palette.accent),
        hintStyle: TextStyle(color: palette.textMuted),
        errorStyle: TextStyle(color: palette.danger),
      ),
      extensions: [palette],
    );
  }
}
