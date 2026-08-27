import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/l10n/app_localizations.dart';

/// Owns all of the dashboard's UI state — section expand/collapse and
/// one-off "coming soon" feedback for features that don't exist yet —
/// so the page and its widgets stay a pure presentation layer with no
/// business logic of their own.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._l10n)
    : super(
        DashboardState.initial(
          user: demoUserFor(_l10n),
          cvs: demoCvsFor(_l10n),
        ),
      ) {
    on<DashboardCvsSectionToggled>(_onCvsSectionToggled);
    on<DashboardCoverLettersSectionToggled>(_onCoverLettersSectionToggled);
    on<DashboardPlaceholderActionRequested>(_onPlaceholderActionRequested);
    on<DashboardMessageShown>(_onMessageShown);
    on<DashboardCvDraftSaved>(_onCvDraftSaved);
    on<DashboardCvDraftResumed>(_onCvDraftResumed);
    on<DashboardCvDraftDiscarded>(_onCvDraftDiscarded);
    on<DashboardCvCompleted>(_onCvCompleted);
  }

  final AppLocalizations _l10n;

  void _onCvsSectionToggled(
    DashboardCvsSectionToggled event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(cvsExpanded: !state.cvsExpanded));
  }

  void _onCoverLettersSectionToggled(
    DashboardCoverLettersSectionToggled event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(coverLettersExpanded: !state.coverLettersExpanded));
  }

  void _onPlaceholderActionRequested(
    DashboardPlaceholderActionRequested event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(pendingMessage: _l10n.comingSoon(event.feature)));
  }

  void _onMessageShown(
    DashboardMessageShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(clearPendingMessage: true));
  }

  void _onCvDraftSaved(
    DashboardCvDraftSaved event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(cvDraft: event.draft));
  }

  void _onCvDraftResumed(
    DashboardCvDraftResumed event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(clearCvDraft: true));
  }

  void _onCvDraftDiscarded(
    DashboardCvDraftDiscarded event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(clearCvDraft: true));
  }

  void _onCvCompleted(
    DashboardCvCompleted event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(cvs: [event.cv, ...state.cvs], clearCvDraft: true));
  }
}
