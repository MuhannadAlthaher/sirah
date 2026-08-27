import 'package:flutter/material.dart';

/// Every color the app uses, as one [ThemeExtension] with a light and
/// a dark variant defined right here — this is the one file to edit
/// to change the app's colors, in either mode.
///
/// Widgets read colors via `context.palette.xxx` (see
/// [AppPaletteContext] below) instead of a static constant, so the
/// same widget automatically renders correctly in whichever mode is
/// active — there's no per-widget dark-mode branching.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.screenBackground,
    required this.surface,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.blob,
    required this.border,
    required this.placeholder,
    required this.titleBar,
    required this.previewBackground,
    required this.scanRowBackground,
    required this.scanRowInnerBar,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.danger,
  });

  /// The screen/scaffold background behind cards.
  final Color screenBackground;

  /// Card/sheet/button surfaces that sit above [screenBackground].
  final Color surface;

  /// The brand accent (buttons, links, highlights).
  final Color accent;

  /// A soft tint of [accent], used behind icons/badges.
  final Color accentSoft;

  /// Text/icon color placed on top of an [accent]-filled background.
  final Color onAccent;

  /// The decorative blob shape behind onboarding feature-card icons.
  final Color blob;

  /// Hairline borders/dividers.
  final Color border;

  /// Placeholder bars in mockup previews.
  final Color placeholder;

  /// The dark placeholder "title" bar in mockup previews.
  final Color titleBar;

  /// Background of the ATS-scan-style preview mockup.
  final Color previewBackground;

  /// Background of the highlighted scan row / active pill.
  final Color scanRowBackground;

  /// Inner bar color inside the highlighted scan row.
  final Color scanRowInnerBar;

  /// Primary body text.
  final Color textPrimary;

  /// Secondary/supporting text (subtitles, descriptions).
  final Color textSecondary;

  /// Muted text/icons (disabled-looking chrome, chevrons).
  final Color textMuted;

  /// Destructive actions (e.g. Log Out).
  final Color danger;

  static const light = AppPalette(
    screenBackground: Color(0xfff2f4f3),
    surface: Colors.white,
    accent: Color(0xff4caf50),
    accentSoft: Color(0xffe6f4ea),
    onAccent: Colors.white,
    blob: Color(0xffd7ecdf),
    border: Color(0xffe4ebe7),
    placeholder: Color(0xffe6eae8),
    titleBar: Color(0xff3f4744),
    previewBackground: Color(0xfff7f9f8),
    scanRowBackground: Color(0xffeef7f1),
    scanRowInnerBar: Color(0xffdcece1),
    textPrimary: Color(0xff1a1c1b),
    textSecondary: Color(0xff5c6360),
    textMuted: Color(0xff8b918e),
    danger: Color(0xffe53935),
  );

  static const dark = AppPalette(
    screenBackground: Color(0xff121412),
    surface: Color(0xff1c1f1e),
    accent: Color(0xff5fd066),
    accentSoft: Color(0xff23342a),
    onAccent: Colors.black,
    blob: Color(0xff223327),
    border: Color(0xff2f332f),
    placeholder: Color(0xff33403a),
    titleBar: Color(0xffe7ece9),
    previewBackground: Color(0xff23261f),
    scanRowBackground: Color(0xff203024),
    scanRowInnerBar: Color(0xff2c4034),
    textPrimary: Color(0xffedf1ee),
    textSecondary: Color(0xffabb2ae),
    textMuted: Color(0xff777d79),
    danger: Color(0xffef5350),
  );

  @override
  AppPalette copyWith({
    Color? screenBackground,
    Color? surface,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? blob,
    Color? border,
    Color? placeholder,
    Color? titleBar,
    Color? previewBackground,
    Color? scanRowBackground,
    Color? scanRowInnerBar,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? danger,
  }) {
    return AppPalette(
      screenBackground: screenBackground ?? this.screenBackground,
      surface: surface ?? this.surface,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      blob: blob ?? this.blob,
      border: border ?? this.border,
      placeholder: placeholder ?? this.placeholder,
      titleBar: titleBar ?? this.titleBar,
      previewBackground: previewBackground ?? this.previewBackground,
      scanRowBackground: scanRowBackground ?? this.scanRowBackground,
      scanRowInnerBar: scanRowInnerBar ?? this.scanRowInnerBar,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      screenBackground: Color.lerp(
        screenBackground,
        other.screenBackground,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      blob: Color.lerp(blob, other.blob, t)!,
      border: Color.lerp(border, other.border, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      titleBar: Color.lerp(titleBar, other.titleBar, t)!,
      previewBackground: Color.lerp(
        previewBackground,
        other.previewBackground,
        t,
      )!,
      scanRowBackground: Color.lerp(
        scanRowBackground,
        other.scanRowBackground,
        t,
      )!,
      scanRowInnerBar: Color.lerp(scanRowInnerBar, other.scanRowInnerBar, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

/// `context.palette.accent` instead of the more verbose
/// `Theme.of(context).extension<AppPalette>()!.accent`.
extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
