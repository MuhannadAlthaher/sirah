import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A simple Yes/No segmented control for "Driving License". [value]
/// is null when unanswered — neither pill shows as selected.
///
/// Every size is a fraction of the control's own available width, so
/// it scales with the screen instead of relying on fixed pixel
/// values.
class DrivingLicenseToggle extends StatelessWidget {
  const DrivingLicenseToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final gap = width * 0.03;

        return Row(
          children: [
            Expanded(
              child: _Pill(
                label: l10n.yes,
                selected: value == true,
                onTap: () => onChanged(true),
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              child: _Pill(
                label: l10n.no,
                selected: value == false,
                onTap: () => onChanged(false),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final radius = width * 0.15;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: width * 0.18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? context.palette.accentSoft
                  : context.palette.surface,
              border: Border.all(
                color: selected
                    ? context.palette.accent
                    : context.palette.border,
                width: selected ? width * 0.008 : width * 0.004,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected
                    ? context.palette.accent
                    : context.palette.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
