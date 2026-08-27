import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// One row in the ATS score breakdown: a label, a progress bar, and
/// the percentage value.
///
/// Every size is a fraction of the row's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class ScoreBreakdownRow extends StatelessWidget {
  const ScoreBreakdownRow({
    super.key,
    required this.label,
    required this.score,
  });

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final gap = width * 0.02;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '$score%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.palette.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: gap * 0.6),
            ClipRRect(
              borderRadius: BorderRadius.circular(width * 0.02),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: width * 0.018,
                backgroundColor: context.palette.placeholder,
                valueColor: AlwaysStoppedAnimation(context.palette.accent),
              ),
            ),
          ],
        );
      },
    );
  }
}
