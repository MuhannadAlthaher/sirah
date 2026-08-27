import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// Where a CV section stands relative to the AI Builder's scripted
/// interview — mirrors the step-by-step [CvBuilderState]'s own
/// section ordering, just rendered as a horizontal chip row instead
/// of a linear wizard.
enum StepChipStatus { completed, current, upcoming }

/// One pill in the AI Builder's top step-progress row.
class StepProgressChip extends StatelessWidget {
  const StepProgressChip({
    super.key,
    required this.label,
    required this.status,
  });

  final String label;
  final StepChipStatus status;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (background, foreground, showCheck) = switch (status) {
      StepChipStatus.completed => (palette.accentSoft, palette.accent, true),
      StepChipStatus.current => (palette.accent, palette.onAccent, false),
      StepChipStatus.upcoming => (
        palette.surface,
        palette.textSecondary,
        false,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: status == StepChipStatus.upcoming
            ? Border.all(color: palette.border)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCheck) ...[
            Icon(Icons.check, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
