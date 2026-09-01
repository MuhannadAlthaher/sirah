import 'package:equatable/equatable.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/data/demo_data.dart';

/// Events the dashboard UI dispatches to [DashboardBloc]. The page
/// and its widgets never mutate state directly — they only describe
/// what happened.
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// The user saved-and-exited the CV Builder from some step without
/// finishing. [draft] replaces any previously-saved draft (there's
/// only ever one in-progress CV Builder session) and is kept
/// separate from "My CVs" — it isn't a real CV yet, just something
/// resumable.
class DashboardCvDraftSaved extends DashboardEvent {
  const DashboardCvDraftSaved(this.draft);

  final CvBuilderState draft;

  @override
  List<Object?> get props => [draft];
}

/// The user opened the draft banner to keep working on it — clears
/// [DashboardState.cvDraft] optimistically (it'll be re-saved via
/// another [DashboardCvDraftSaved] if they save again, or stay gone
/// if they discard).
class DashboardCvDraftResumed extends DashboardEvent {
  const DashboardCvDraftResumed();
}

/// The draft banner's dismiss action was tapped — the user doesn't
/// want to resume it, so it's gone for good (nothing was ever a real
/// CV to begin with).
class DashboardCvDraftDiscarded extends DashboardEvent {
  const DashboardCvDraftDiscarded();
}

/// The user reached the end of the CV Builder and tapped Finish —
/// [cv] is added to "My CVs" for real, and any in-progress draft is
/// cleared since it's no longer just a draft.
class DashboardCvCompleted extends DashboardEvent {
  const DashboardCvCompleted(this.cv);

  final DemoCv cv;

  @override
  List<Object?> get props => [cv];
}

/// The user finished editing an already-existing CV (via a CV card's
/// Edit action) — [cv] replaces the entry with the same id in place,
/// whether they tapped "Finish CV" or "Save & Exit" partway through;
/// either way the edit is real progress on a CV that already exists,
/// not a new draft.
class DashboardCvUpdated extends DashboardEvent {
  const DashboardCvUpdated(this.cv);

  final DemoCv cv;

  @override
  List<Object?> get props => [cv];
}

/// The user confirmed deleting a CV from "My CVs".
class DashboardCvDeleted extends DashboardEvent {
  const DashboardCvDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// The "My CVs" section header was tapped.
class DashboardCvsSectionToggled extends DashboardEvent {
  const DashboardCvsSectionToggled();
}

/// The "My Cover Letters" section header was tapped.
class DashboardCoverLettersSectionToggled extends DashboardEvent {
  const DashboardCoverLettersSectionToggled();
}

/// A feature without a real destination yet was tapped (Create CV,
/// a CV's Edit/Download/Share action, a Quick Action, ...). [feature]
/// names it for the resulting "coming soon" message.
class DashboardPlaceholderActionRequested extends DashboardEvent {
  const DashboardPlaceholderActionRequested(this.feature);

  final String feature;

  @override
  List<Object?> get props => [feature];
}

/// The UI finished showing [DashboardState.pendingMessage] (e.g. the
/// SnackBar was presented), so it can be cleared.
class DashboardMessageShown extends DashboardEvent {
  const DashboardMessageShown();
}

/// Dispatched once, from [DashboardBloc]'s own constructor, to load
/// whatever "My CVs" and in-progress draft were persisted from a
/// previous app run (see `CvStorage`). Not something the UI ever
/// dispatches itself.
class DashboardPersistedDataLoaded extends DashboardEvent {
  const DashboardPersistedDataLoaded(this.cvs, this.draft);

  final List<DemoCv> cvs;
  final CvBuilderState? draft;

  @override
  List<Object?> get props => [cvs, draft];
}
