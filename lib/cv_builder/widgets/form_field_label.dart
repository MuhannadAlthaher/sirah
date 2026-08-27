import 'package:flutter/material.dart';
import 'package:sira/cv_builder/widgets/optional_badge.dart';
import 'package:sira/theme/app_palette.dart';

/// A field's label, with an [OptionalBadge] alongside it when
/// [isOptional] — every CV Builder field is preceded by one of these
/// instead of relying on a bare `InputDecoration.labelText`, so
/// required vs. optional is unambiguous at a glance.
class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({
    super.key,
    required this.label,
    this.isOptional = false,
  });

  final String label;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: context.palette.textPrimary,
    );
    final gap = (style?.fontSize ?? 14) * 0.4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: Text(label, style: style)),
        if (isOptional) ...[SizedBox(width: gap), const OptionalBadge()],
      ],
    );
  }
}
