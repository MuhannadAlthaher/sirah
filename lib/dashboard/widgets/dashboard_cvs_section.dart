import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sira/cv_builder/open_cv_builder.dart';
import 'package:sira/cv_builder/preview/cv_plain_text.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/dashboard/widgets/collapsible_section_header.dart';
import 'package:sira/dashboard/widgets/cv_card.dart';
import 'package:sira/dashboard/widgets/delete_cv_dialog.dart';
import 'package:sira/dashboard/widgets/expand_collapse.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/l10n/app_localizations.dart';

/// The collapsible "My CVs" section: header + a 2-column grid of
/// [CvCard] tiles, both driven by [DashboardBloc]. Collapsing slides
/// the grid up and fades it out (and the reverse on expand) via
/// [ExpandCollapse].
class DashboardCvsSection extends StatelessWidget {
  const DashboardCvsSection({super.key, required this.width});

  final double width;

  void _handleEdit(BuildContext context, AppLocalizations l10n, DemoCv cv) {
    if (cv.builderState != null) {
      openCvBuilder(context, resumeFrom: cv.builderState, editingCvId: cv.id);
    } else {
      context.read<DashboardBloc>().add(
        DashboardPlaceholderActionRequested(l10n.editCv(cv.name)),
      );
    }
  }

  void _handleShare(BuildContext context, AppLocalizations l10n, DemoCv cv) {
    final builderState = cv.builderState;
    if (builderState != null) {
      SharePlus.instance.share(
        ShareParams(text: cvPlainText(l10n, builderState), subject: cv.name),
      );
    } else {
      context.read<DashboardBloc>().add(
        DashboardPlaceholderActionRequested(l10n.shareCv(cv.name)),
      );
    }
  }

  Future<void> _handleDelete(BuildContext context, DemoCv cv) async {
    final confirmed = await showDeleteCvDialog(context, cv.name);
    if (confirmed && context.mounted) {
      context.read<DashboardBloc>().add(DashboardCvDeleted(cv.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = width * 0.05;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocSelector<DashboardBloc, DashboardState, bool>(
          selector: (state) => state.cvsExpanded,
          builder: (context, expanded) => CollapsibleSectionHeader(
            title: l10n.myCvs,
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
                // The `width` prop is the section's nominal width before
                // the parent scroll view's horizontal padding is
                // subtracted, so tile sizing is measured here instead —
                // off the space actually available to the Wrap — rather
                // than off `width` directly, which would overshoot it.
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tileWidth =
                        (constraints.maxWidth - padding * 0.6) / 2;

                    return Wrap(
                      spacing: padding * 0.6,
                      runSpacing: padding * 0.6,
                      children: [
                        for (final cv in state.cvs)
                          SizedBox(
                            width: tileWidth,
                            child: CvCard(
                              cv: cv,
                              width: tileWidth,
                              onEdit: () => _handleEdit(context, l10n, cv),
                              onDownload: () =>
                                  context.read<DashboardBloc>().add(
                                    DashboardPlaceholderActionRequested(
                                      l10n.downloadCv(cv.name),
                                    ),
                                  ),
                              onShare: () => _handleShare(context, l10n, cv),
                              onDelete: () => _handleDelete(context, cv),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
