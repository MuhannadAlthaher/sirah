import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/score_ring.dart';

/// The "ATS Score" card in the dashboard's Quick Actions — shows the
/// same ring design as the Score tab (just smaller, no inner
/// caption) instead of the generic icon+title+value layout
/// [DashboardActionCard] uses, so it previews what tapping through to
/// Score looks like.
///
/// Every size is a fraction of the card's own available width via
/// [LayoutBuilder], so it scales with whatever space its parent (an
/// [Expanded] in a [Row]) gives it — same convention as
/// [DashboardActionCard].
class DashboardAtsScoreCard extends StatelessWidget {
  const DashboardAtsScoreCard({
    super.key,
    required this.score,
    required this.label,
    required this.onTap,
  });

  final int score;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.1;
        final radius = width * 0.08;

        return Material(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                border: Border.all(color: context.palette.border),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScoreRing(score: score, size: width * 0.46),
                  SizedBox(height: padding * 0.5),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
