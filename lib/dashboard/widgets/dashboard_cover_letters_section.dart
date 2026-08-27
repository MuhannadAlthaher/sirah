import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/dashboard/widgets/collapsible_section_header.dart';
import 'package:sira/dashboard/widgets/empty_section_placeholder.dart';
import 'package:sira/dashboard/widgets/expand_collapse.dart';
import 'package:sira/l10n/app_localizations.dart';

/// The collapsible "My Cover Letters" section. There's no cover
/// letter feature yet, so the expanded state is an honest empty
/// state rather than fabricated demo entries.
class DashboardCoverLettersSection extends StatelessWidget {
  const DashboardCoverLettersSection({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final padding = width * 0.05;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocSelector<DashboardBloc, DashboardState, bool>(
          selector: (state) => state.coverLettersExpanded,
          builder: (context, expanded) => CollapsibleSectionHeader(
            title: l10n.myCoverLetters,
            expanded: expanded,
            onToggle: () => context.read<DashboardBloc>().add(
              const DashboardCoverLettersSectionToggled(),
            ),
          ),
        ),
        BlocSelector<DashboardBloc, DashboardState, bool>(
          selector: (state) => state.coverLettersExpanded,
          builder: (context, expanded) => ExpandCollapse(
            expanded: expanded,
            child: Padding(
              padding: EdgeInsets.only(top: padding * 0.6),
              child: EmptySectionPlaceholder(
                title: l10n.noCoverLettersYet,
                message: l10n.coverLettersEmptyMessage,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
