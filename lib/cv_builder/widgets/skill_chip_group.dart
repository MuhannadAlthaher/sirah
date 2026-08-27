import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// One suggested-skills category on the Skills step: a header and a
/// [Wrap] of "+ Skill" chips the user can tap to add to their CV.
/// Only ever shows *unselected* options — once picked, a skill moves
/// up to the "On Your CV" section instead (see `SkillsStep`).
///
/// Every size is a fraction of the group's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class SkillChipGroup extends StatelessWidget {
  const SkillChipGroup({
    super.key,
    required this.label,
    required this.options,
    required this.onSelect,
  });

  final String label;
  final List<String> options;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.03;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: context.palette.textSecondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: padding * 1.2),
            Wrap(
              spacing: padding,
              runSpacing: padding,
              children: [
                for (final option in options)
                  ActionChip(
                    label: Text('+ $option'),
                    backgroundColor: context.palette.surface,
                    side: BorderSide(color: context.palette.border),
                    shape: const StadiumBorder(),
                    labelStyle: TextStyle(
                      color: context.palette.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: () => onSelect(option),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
