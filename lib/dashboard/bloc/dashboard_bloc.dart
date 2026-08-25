import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/dashboard/bloc/dashboard_event.dart';
import 'package:sira/dashboard/bloc/dashboard_state.dart';

/// Owns all of the dashboard's UI state — section expand/collapse and
/// one-off "coming soon" feedback for features that don't exist yet —
/// so the page and its widgets stay a pure presentation layer with no
/// business logic of their own.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState.initial()) {
    on<DashboardCvsSectionToggled>(_onCvsSectionToggled);
    on<DashboardCoverLettersSectionToggled>(_onCoverLettersSectionToggled);
    on<DashboardPlaceholderActionRequested>(_onPlaceholderActionRequested);
    on<DashboardMessageShown>(_onMessageShown);
  }

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
    emit(state.copyWith(pendingMessage: '${event.feature} — coming soon'));
  }

  void _onMessageShown(
    DashboardMessageShown event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(clearPendingMessage: true));
  }
}
