import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/cv_builder_hub_page.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/template_picker/cv_template_picker_page.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/l10n/app_localizations.dart';

/// Pushes [CvBuilderHubPage] — fresh, resuming [resumeFrom], or
/// editing the already-existing CV named by [editingCvId] — and turns
/// whatever it pops with into the matching [DashboardBloc] event, so
/// the places that open the builder (the "Create New CV" button, the
/// draft banner, and a CV card's Edit action) don't duplicate this
/// handling.
///
/// A brand-new CV starts with `CvTemplatePickerPage` — canceling it
/// (back/close) aborts opening the builder at all, so declining a
/// template never leaves a stray empty draft behind. Resuming a draft
/// or editing an existing CV both skip the picker: either already
/// carries the template it was started with.
///
/// [editingCvId] set means [resumeFrom] is an already-completed CV's
/// data, not the singular in-progress draft — so both a finish and a
/// "Save & Exit" here update that same "My CVs" entry in place
/// ([DashboardCvUpdated]) rather than touching the draft banner or
/// adding a new entry.
Future<void> openCvBuilder(
  BuildContext context, {
  CvBuilderState? resumeFrom,
  String? editingCvId,
}) async {
  final bloc = context.read<DashboardBloc>();
  final l10n = context.l10n;

  CvBuilderState? initialState = resumeFrom;

  if (resumeFrom != null) {
    if (editingCvId == null) {
      // Optimistic: a fresh Save & Exit (or Discard) from this visit
      // will decide what, if anything, replaces it.
      bloc.add(const DashboardCvDraftResumed());
    }
  } else {
    final templateId = await Navigator.of(context).push<CvTemplateId>(
      MaterialPageRoute(builder: (_) => const CvTemplatePickerPage()),
    );
    if (templateId == null || !context.mounted) return;
    initialState = CvBuilderState.initial().copyWith(templateId: templateId);
  }

  final result = await Navigator.of(context).push<CvBuilderResult>(
    MaterialPageRoute(
      builder: (_) => CvBuilderHubPage(initialState: initialState),
    ),
  );

  if (result == null) return;

  final state = result.state;
  if (editingCvId != null) {
    bloc.add(
      DashboardCvUpdated(
        DemoCv(
          id: editingCvId,
          name: state.draftName(l10n),
          subtitle: l10n.cvEditedJustNow,
          builderState: state,
        ),
      ),
    );
    return;
  }

  switch (result) {
    case CvBuilderDraftSaved():
      bloc.add(DashboardCvDraftSaved(state));
    case CvBuilderCompleted():
      bloc.add(
        DashboardCvCompleted(
          DemoCv(
            id: 'cv-${DateTime.now().microsecondsSinceEpoch}',
            name: state.draftName(l10n),
            subtitle: l10n.cvEditedJustNow,
            builderState: state,
          ),
        ),
      );
  }
}
