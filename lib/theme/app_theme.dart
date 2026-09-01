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
      // One smooth, consistent push transition on every platform this
      // app ships to — Flutter's own per-platform defaults range from
      // a fairly abrupt zoom (Android) to a plain upward fade
      // (desktop/web), which reads as inconsistent when the same app
      // runs on both. Duration stays Flutter's own default (300ms),
      // matching the 300ms/easeOut already used for every in-screen
      // animation elsewhere (see CvBuilderBloc, OnboardingBloc).
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothPageTransitionsBuilder(),
          TargetPlatform.linux: _SmoothPageTransitionsBuilder(),
          TargetPlatform.macOS: _SmoothPageTransitionsBuilder(),
          TargetPlatform.windows: _SmoothPageTransitionsBuilder(),
          TargetPlatform.fuchsia: _SmoothPageTransitionsBuilder(),
        },
      ),
      extensions: [palette],
    );
  }
}

/// Slides the incoming screen in from the trailing edge while fading
/// it in, and gives the screen being covered a faint opposite drift —
/// the same "push" shape as a native transition, just toned down and
/// identical across platforms.
class _SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  const _SmoothPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final entering = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final leaving = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    // Mirror the drift for RTL (Arabic) so "forward" still reads as
    // the leading edge rather than always sliding from the right.
    final sign = Directionality.of(context) == TextDirection.rtl ? -1 : 1;

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(-0.04 * sign, 0),
      ).animate(leaving),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.06 * sign, 0),
          end: Offset.zero,
        ).animate(entering),
        child: FadeTransition(opacity: entering, child: child),
      ),
    );
  }
}
