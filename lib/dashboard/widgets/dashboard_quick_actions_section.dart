import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/open_cv_builder.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/dashboard/widgets/dashboard_action_card.dart';
import 'package:sira/dashboard/widgets/dashboard_ats_score_card.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/shell/app_tab.dart';
import 'package:sira/shell/bloc/navigation_bloc.dart';
import 'package:sira/shell/bloc/navigation_event.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// The "Quick Actions" heading and panel (ATS score, create cover
/// letter). Reads the ATS score from [DashboardBloc] and dispatches
/// [DashboardPlaceholderActionRequested] when a card is tapped —
/// neither card decides for itself what happens on tap.
class DashboardQuickActionsSection extends StatelessWidget {
  const DashboardQuickActionsSection({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final padding = width * 0.05;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActions,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: padding * 0.6),
        Container(
          padding: EdgeInsets.all(padding * 0.8),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(padding * 0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: padding * 0.5,
                offset: Offset(0, padding * 0.2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocSelector<DashboardBloc, DashboardState, int>(
                      selector: (state) => state.atsScore,
                      builder: (context, atsScore) => DashboardAtsScoreCard(
                        score: atsScore,
                        label: l10n.atsScore,
                        onTap: () => context.read<NavigationBloc>().add(
                          NavigationTabSelected(AppTab.score.index),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: padding * 0.6),
                  Expanded(
                    child: DashboardActionCard(
                      icon: Icons.mail_outline,
                      title: l10n.coverLetter,
                      value: l10n.createNow,
                      onTap: () => context.read<DashboardBloc>().add(
                        DashboardPlaceholderActionRequested(
                          l10n.coverLetterBuilder,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding * 0.6),
              PrimaryCtaButton(
                label: l10n.createNewCv,
                icon: Icons.add,
                onPressed: () => openCvBuilder(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
