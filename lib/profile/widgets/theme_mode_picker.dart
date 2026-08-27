import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/theme/bloc/theme_bloc.dart';
import 'package:sira/theme/bloc/theme_event.dart';
import 'package:sira/theme/bloc/theme_state.dart';

/// The "Appearance" picker: Auto/Light/Dark as compact visual preview
/// cards (a mini mockup of each look, a label, and a radio indicator)
/// — design inspired by TikTok's Appearance screen — driven entirely
/// by [ThemeBloc].
class ThemeModePicker extends StatelessWidget {
  const ThemeModePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, outerConstraints) {
        // Inset the whole picker so the cards read as compact
        // thumbnails rather than filling the full list width.
        final inset = outerConstraints.maxWidth * 0.12;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: inset),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final gap = constraints.maxWidth * 0.04;

              return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: _ThemeModeCard(
                          label: l10n.themeModeAuto,
                          selected: state.mode == ThemeMode.system,
                          previewBuilder: (width, height) =>
                              _SplitPreview(width: width, height: height),
                          onTap: () => context.read<ThemeBloc>().add(
                            const ThemeModeChanged(ThemeMode.system),
                          ),
                        ),
                      ),
                      SizedBox(width: gap),
                      Expanded(
                        child: _ThemeModeCard(
                          label: l10n.themeModeLight,
                          selected: state.mode == ThemeMode.light,
                          previewBuilder: (width, height) => SizedBox(
                            width: width,
                            height: height,
                            child: _ModePreview(
                              scale: width,
                              palette: AppPalette.light,
                            ),
                          ),
                          onTap: () => context.read<ThemeBloc>().add(
                            const ThemeModeChanged(ThemeMode.light),
                          ),
                        ),
                      ),
                      SizedBox(width: gap),
                      Expanded(
                        child: _ThemeModeCard(
                          label: l10n.themeModeDark,
                          selected: state.mode == ThemeMode.dark,
                          previewBuilder: (width, height) => SizedBox(
                            width: width,
                            height: height,
                            child: _ModePreview(
                              scale: width,
                              palette: AppPalette.dark,
                            ),
                          ),
                          onTap: () => context.read<ThemeBloc>().add(
                            const ThemeModeChanged(ThemeMode.dark),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  const _ThemeModeCard({
    required this.label,
    required this.selected,
    required this.previewBuilder,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Widget Function(double width, double height) previewBuilder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Every card shares this same height — computed once, off the
        // full card width — so Auto/Light/Dark's boxes always line up
        // instead of Auto's (built from two half-width mini previews)
        // coming out shorter than the others.
        final height = width * 0.85;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(width * 0.12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.12),
                  border: Border.all(
                    color: selected
                        ? context.palette.accent
                        : context.palette.border,
                    width: selected ? width * 0.025 : width * 0.01,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: previewBuilder(width, height),
              ),
              SizedBox(height: width * 0.06),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: width * 0.04),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected
                    ? context.palette.accent
                    : context.palette.textMuted,
                size: width * 0.14,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A mini mockup of the app rendered in one fixed [palette],
/// regardless of the currently active theme — that's the whole point
/// of a preview: "Light" must always look light, "Dark" always dark.
///
/// Fills whatever box its caller gives it (a [SizedBox] or
/// [Expanded]) exactly — it never declares its own width/height —
/// and [scale] only drives internal proportions (icon size, padding,
/// bar widths). The gap between the icon and the mock content card
/// is a [Spacer], so if the given box is taller than this preview's
/// own minimum content, the extra room is absorbed there instead of
/// causing an overflow.
class _ModePreview extends StatelessWidget {
  const _ModePreview({required this.scale, required this.palette});

  final double scale;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: palette.screenBackground,
      padding: EdgeInsets.all(scale * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: scale * 0.22,
            height: scale * 0.22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.accentSoft,
            ),
            child: Icon(
              Icons.description_outlined,
              color: palette.accent,
              size: scale * 0.12,
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(scale * 0.06),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(scale * 0.06),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: scale * 0.045,
                  width: scale * 0.5,
                  decoration: BoxDecoration(
                    color: palette.titleBar,
                    borderRadius: BorderRadius.circular(scale * 0.02),
                  ),
                ),
                SizedBox(height: scale * 0.05),
                Container(
                  height: scale * 0.035,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: palette.placeholder,
                    borderRadius: BorderRadius.circular(scale * 0.02),
                  ),
                ),
                SizedBox(height: scale * 0.04),
                Container(
                  height: scale * 0.035,
                  width: scale * 0.65,
                  decoration: BoxDecoration(
                    color: palette.placeholder,
                    borderRadius: BorderRadius.circular(scale * 0.02),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Auto" card's preview: the light and dark mockups side by
/// side, showing at a glance that this option follows the device.
/// Each half fills exactly half of [width] via [Expanded] — a Row
/// bounded by an explicit [SizedBox] and split with [Expanded] can't
/// overflow, unlike matching two independently-computed half-widths
/// by hand.
class _SplitPreview extends StatelessWidget {
  const _SplitPreview({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        children: [
          Expanded(
            child: _ModePreview(scale: width / 2, palette: AppPalette.light),
          ),
          Expanded(
            child: _ModePreview(scale: width / 2, palette: AppPalette.dark),
          ),
        ],
      ),
    );
  }
}
