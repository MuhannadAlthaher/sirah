import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/l10n/bloc/app_locale_bloc.dart';
import 'package:sira/l10n/bloc/app_locale_event.dart';
import 'package:sira/l10n/bloc/app_locale_state.dart';
import 'package:sira/theme/app_palette.dart';

/// The "Language" row inside the settings list: a compact EN/AR
/// segmented toggle driven by [AppLocaleBloc] — switching writes an
/// explicit choice (never "device") straight from this row, no
/// separate picker screen needed.
class LanguageToggleRow extends StatelessWidget {
  const LanguageToggleRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // The toggle pill is a compact, roughly fixed-size control —
        // scaling its padding off the *row's* width (which can be up
        // to 480px) made it balloon on wide screens and overflow.
        // Basing it on the icon size instead keeps it visually
        // compact and bounded, while still responsive to the screen.
        final iconSize = width * 0.055;
        final l10n = context.l10n;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: width * 0.03),
          child: Row(
            children: [
              Icon(
                Icons.language_outlined,
                color: context.palette.accent,
                size: iconSize,
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                child: Text(
                  l10n.language,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(width: width * 0.02),
              BlocBuilder<AppLocaleBloc, AppLocaleState>(
                builder: (context, state) {
                  final effectiveLocale =
                      state.locale ?? Localizations.localeOf(context);
                  final isArabic = effectiveLocale.languageCode == 'ar';

                  return _LanguageSwitch(
                    unit: iconSize,
                    isArabic: isArabic,
                    onChanged: (arabic) => context.read<AppLocaleBloc>().add(
                      AppLocaleChanged(Locale(arabic ? 'ar' : 'en')),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch({
    required this.unit,
    required this.isArabic,
    required this.onChanged,
  });

  /// A small, roughly icon-sized reference unit — not the row's full
  /// width — so this stays a compact pill regardless of screen size.
  final double unit;
  final bool isArabic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    // FittedBox guarantees this can never overflow its row, even if
    // the unit-based sizing below is ever slightly too generous.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: EdgeInsets.all(unit * 0.08),
        decoration: BoxDecoration(
          color: context.palette.placeholder,
          borderRadius: BorderRadius.circular(unit * 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Segment(
              label: 'EN',
              unit: unit,
              selected: !isArabic,
              onTap: () => onChanged(false),
            ),
            _Segment(
              label: 'AR',
              unit: unit,
              selected: isArabic,
              onTap: () => onChanged(true),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.unit,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double unit;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(unit * 0.4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: unit * 0.6,
          vertical: unit * 0.3,
        ),
        decoration: BoxDecoration(
          color: selected ? context.palette.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(unit * 0.4),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: selected
                ? context.palette.onAccent
                : context.palette.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
