import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/data/demo_data.dart';

/// Everything the dashboard's widgets need to render: the user, their
/// CVs, an in-progress CV Builder draft (if any — never mixed into
/// [cvs], since it isn't a finished CV), whether each collapsible
/// section is expanded, and any one-off feedback message (e.g.
/// "coming soon") waiting to be shown.
class DashboardState {
  const DashboardState({
    required this.user,
    required this.cvs,
    required this.atsScore,
    required this.cvsExpanded,
    required this.coverLettersExpanded,
    this.cvDraft,
    this.pendingMessage,
  });

  factory DashboardState.initial({
    required DemoUser user,
    required List<DemoCv> cvs,
  }) => DashboardState(
    user: user,
    cvs: cvs,
    atsScore: demoAtsScore,
    cvsExpanded: true,
    coverLettersExpanded: true,
  );

  final DemoUser user;
  final List<DemoCv> cvs;
  final int atsScore;
  final bool cvsExpanded;
  final bool coverLettersExpanded;

  /// The CV Builder state as of the last "Save & Exit", if any is
  /// in progress. Resuming or discarding it clears this back to null.
  final CvBuilderState? cvDraft;

  final String? pendingMessage;

  DashboardState copyWith({
    List<DemoCv>? cvs,
    bool? cvsExpanded,
    bool? coverLettersExpanded,
    CvBuilderState? cvDraft,
    bool clearCvDraft = false,
    String? pendingMessage,
    bool clearPendingMessage = false,
  }) {
    return DashboardState(
      user: user,
      cvs: cvs ?? this.cvs,
      atsScore: atsScore,
      cvsExpanded: cvsExpanded ?? this.cvsExpanded,
      coverLettersExpanded: coverLettersExpanded ?? this.coverLettersExpanded,
      cvDraft: clearCvDraft ? null : (cvDraft ?? this.cvDraft),
      pendingMessage: clearPendingMessage
          ? null
          : (pendingMessage ?? this.pendingMessage),
    );
  }
}
