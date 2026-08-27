import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A small "Optional" pill placed next to a field's label, so users
/// never have to guess which fields they can skip.
class OptionalBadge extends StatelessWidget {
  const OptionalBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // This sits inline next to a Text, so there's no meaningful "own
    // width" to size off of (no LayoutBuilder) — instead it scales
    // off the ambient font size, which tracks the user's text-scale
    // accessibility settings rather than just screen width.
    final fontSize = Theme.of(context).textTheme.bodySmall?.fontSize ?? 12;
    final hPad = fontSize * 0.5;
    final vPad = fontSize * 0.15;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: context.palette.placeholder,
        borderRadius: BorderRadius.circular(fontSize),
      ),
      child: Text(
        context.l10n.optional,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: context.palette.textSecondary),
      ),
    );
  }
}
