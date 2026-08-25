import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/dashboard/widgets/dashboard_action_card.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: padding * 0.6),
        Container(
          padding: EdgeInsets.all(padding * 0.8),
          decoration: BoxDecoration(
            color: Colors.white,
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
                      builder: (context, atsScore) => DashboardActionCard(
                        icon: Icons.speed_outlined,
                        title: 'ATS Score',
                        value: '$atsScore%',
                        onTap: () => context.read<DashboardBloc>().add(
                          const DashboardPlaceholderActionRequested(
                            'ATS score details',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: padding * 0.6),
                  Expanded(
                    child: DashboardActionCard(
                      icon: Icons.mail_outline,
                      title: 'Cover Letter',
                      value: 'Create now',
                      onTap: () => context.read<DashboardBloc>().add(
                        const DashboardPlaceholderActionRequested(
                          'Cover letter builder',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding * 0.6),
              PrimaryCtaButton(
                label: 'Create New CV',
                icon: Icons.add,
                onPressed: () => context.read<DashboardBloc>().add(
                  const DashboardPlaceholderActionRequested('Create New CV'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
