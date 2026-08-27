import 'package:flutter/material.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/score/score_demo_data.dart';
import 'package:sira/score/widgets/score_breakdown_row.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/score_ring.dart';

/// The "Score" tab: the user's overall ATS match score and a
/// breakdown by category. Demo data for now — swap for the real
/// computed score once ATS scoring exists.
class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final breakdown = demoScoreBreakdownFor(l10n);

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0, 480).toDouble();
            final padding = width * 0.05;

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.atsScore,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: padding * 0.3),
                      Text(
                        l10n.scoreDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.palette.textSecondary,
                        ),
                      ),
                      SizedBox(height: padding * 1.4),
                      Center(
                        child: ScoreRing(
                          score: demoAtsScore,
                          size: width * 0.4,
                          label: l10n.overall,
                        ),
                      ),
                      SizedBox(height: padding * 1.4),
                      Text(
                        l10n.breakdown,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: padding * 0.6),
                      for (var i = 0; i < breakdown.length; i++) ...[
                        if (i != 0) SizedBox(height: padding * 0.7),
                        ScoreBreakdownRow(
                          label: breakdown[i].label,
                          score: breakdown[i].score,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
