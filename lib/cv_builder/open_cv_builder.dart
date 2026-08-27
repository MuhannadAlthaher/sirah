import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/cv_builder_hub_page.dart';
import 'package:sira/dashboard/bloc/dashboard_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/l10n/app_localizations.dart';

/// Pushes [CvBuilderHubPage] — fresh, or resuming [resumeFrom] — and
/// turns whatever it pops with into the matching [DashboardBloc]
/// event, so the two places that open the builder (the "Create New
/// CV" button and the draft banner) don't duplicate this handling.
///
/// Only a [CvBuilderCompleted] result ever becomes a "My CVs" entry;
/// a [CvBuilderDraftSaved] result only ever updates the draft.
Future<void> openCvBuilder(
  BuildContext context, {
  CvBuilderState? resumeFrom,
}) async {
  final bloc = context.read<DashboardBloc>();
  final l10n = context.l10n;

  if (resumeFrom != null) {
    // Optimistic: a fresh Save & Exit (or Discard) from this visit
    // will decide what, if anything, replaces it.
    bloc.add(const DashboardCvDraftResumed());
  }

  final result = await Navigator.of(context).push<CvBuilderResult>(
    MaterialPageRoute(
      builder: (_) => CvBuilderHubPage(initialState: resumeFrom),
    ),
  );

  switch (result) {
    case CvBuilderDraftSaved(:final state):
      bloc.add(DashboardCvDraftSaved(state));
    case CvBuilderCompleted(:final state):
      bloc.add(
        DashboardCvCompleted(
          DemoCv(
            id: 'cv-${DateTime.now().microsecondsSinceEpoch}',
            name: state.draftName(l10n),
            subtitle: l10n.cvEditedJustNow,
          ),
        ),
      );
    case null:
      break;
  }
}
