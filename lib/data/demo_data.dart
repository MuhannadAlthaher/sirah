import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/l10n/app_localizations.dart';

/// The signed-in user, shown across the dashboard/profile/score
/// screens. Demo data for now — swap for the real profile once auth
/// is wired up.
class DemoUser {
  const DemoUser({required this.name, required this.position});

  final String name;
  final String position;
}

/// One CV entry shown on the dashboard. Demo data for now — swap for
/// the user's real saved CVs once the builder/backend exists.
///
/// [builderState] is null for the seeded sample cards (there's no real
/// content behind them, so Edit/Preview/Share fall back to a "coming
/// soon" placeholder) and set for any CV actually produced by the CV
/// Builder — that's what lets Edit reopen it with its real answers,
/// and Preview/Share render its real content.
class DemoCv {
  const DemoCv({
    required this.id,
    required this.name,
    required this.subtitle,
    this.builderState,
  });

  final String id;
  final String name;
  final String subtitle;
  final CvBuilderState? builderState;

  DemoCv copyWith({
    String? name,
    String? subtitle,
    CvBuilderState? builderState,
  }) {
    return DemoCv(
      id: id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      builderState: builderState ?? this.builderState,
    );
  }
}

DemoUser demoUserFor(AppLocalizations l10n) =>
    DemoUser(name: l10n.demoUserName, position: l10n.demoUserPosition);

/// The user's average ATS match score across their CVs, out of 100.
/// Demo data for now — swap for the real computed score once ATS
/// scoring exists.
const demoAtsScore = 87;

List<DemoCv> demoCvsFor(AppLocalizations l10n) => [
  DemoCv(
    id: 'cv-1',
    name: l10n.demoCvOneName,
    subtitle: l10n.demoCvOneSubtitle,
  ),
  DemoCv(
    id: 'cv-2',
    name: l10n.demoCvTwoName,
    subtitle: l10n.demoCvTwoSubtitle,
  ),
  DemoCv(
    id: 'cv-3',
    name: l10n.demoCvThreeName,
    subtitle: l10n.demoCvThreeSubtitle,
  ),
];
