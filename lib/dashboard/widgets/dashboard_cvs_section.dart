import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/dashboard/widgets/collapsible_section_header.dart';
import 'package:sira/dashboard/widgets/cv_card.dart';
import 'package:sira/dashboard/widgets/expand_collapse.dart';

/// The collapsible "My CVs" section: header + list, both driven by
/// [DashboardBloc]. Collapsing slides the list up and fades it out
/// (and the reverse on expand) via [ExpandCollapse].
class DashboardCvsSection extends StatelessWidget {
  const DashboardCvsSection({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final padding = width * 0.05;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocSelector<DashboardBloc, DashboardState, bool>(
          selector: (state) => state.cvsExpanded,
          builder: (context, expanded) => CollapsibleSectionHeader(
            title: 'My CVs',
            expanded: expanded,
            onToggle: () => context.read<DashboardBloc>().add(
              const DashboardCvsSectionToggled(),
            ),
          ),
        ),
        BlocBuilder<DashboardBloc, DashboardState>(
          buildWhen: (previous, current) =>
              previous.cvsExpanded != current.cvsExpanded ||
              previous.cvs != current.cvs,
          builder: (context, state) {
            return ExpandCollapse(
              expanded: state.cvsExpanded,
              child: Padding(
                padding: EdgeInsets.only(top: padding * 0.6),
                child: Column(
                  children: [
                    for (var i = 0; i < state.cvs.length; i++) ...[
                      if (i != 0) SizedBox(height: padding * 0.6),
                      CvCard(
                        cv: state.cvs[i],
                        width: width,
                        onEdit: () => context.read<DashboardBloc>().add(
                          DashboardPlaceholderActionRequested(
                            'Edit "${state.cvs[i].name}"',
                          ),
                        ),
                        onDownload: () => context.read<DashboardBloc>().add(
                          DashboardPlaceholderActionRequested(
                            'Download "${state.cvs[i].name}"',
                          ),
                        ),
                        onShare: () => context.read<DashboardBloc>().add(
                          DashboardPlaceholderActionRequested(
                            'Share "${state.cvs[i].name}"',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
