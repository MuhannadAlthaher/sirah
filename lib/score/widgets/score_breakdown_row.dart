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
    this.tip,
  });

  final String label;
  final int score;

  /// A short, actionable suggestion for raising this category's
  /// score. Null (or an empty string) hides the tip line entirely —
  /// callers only pass one in for categories that aren't already
  /// strong.
  final String? tip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final gap = width * 0.02;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: score / 100),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '${(value * 100).round()}%',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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
                        value: value,
                        minHeight: width * 0.018,
                        backgroundColor: context.palette.placeholder,
                        valueColor: AlwaysStoppedAnimation(
                          context.palette.accent,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (tip != null && tip!.isNotEmpty) ...[
              SizedBox(height: gap * 0.7),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: width * 0.045,
                    color: context.palette.textSecondary,
                  ),
                  SizedBox(width: gap * 0.6),
                  Expanded(
                    child: Text(
                      tip!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
