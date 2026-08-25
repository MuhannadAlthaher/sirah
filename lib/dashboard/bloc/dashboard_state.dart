import 'package:sira/dashboard/dashboard_demo_data.dart';

/// Everything the dashboard's widgets need to render: the user, their
/// CVs, whether each collapsible section is expanded, and any
/// one-off feedback message (e.g. "coming soon") waiting to be shown.
class DashboardState {
  const DashboardState({
    required this.user,
    required this.cvs,
    required this.atsScore,
    required this.cvsExpanded,
    required this.coverLettersExpanded,
    this.pendingMessage,
  });

  factory DashboardState.initial() => const DashboardState(
    user: demoUser,
    cvs: demoCvs,
    atsScore: demoAtsScore,
    cvsExpanded: true,
    coverLettersExpanded: true,
  );

  final DemoUser user;
  final List<DemoCv> cvs;
  final int atsScore;
  final bool cvsExpanded;
  final bool coverLettersExpanded;
  final String? pendingMessage;

  DashboardState copyWith({
    bool? cvsExpanded,
    bool? coverLettersExpanded,
    String? pendingMessage,
    bool clearPendingMessage = false,
  }) {
    return DashboardState(
      user: user,
      cvs: cvs,
      atsScore: atsScore,
      cvsExpanded: cvsExpanded ?? this.cvsExpanded,
      coverLettersExpanded: coverLettersExpanded ?? this.coverLettersExpanded,
      pendingMessage: clearPendingMessage
          ? null
          : (pendingMessage ?? this.pendingMessage),
    );
  }
}
