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
class DemoCv {
  const DemoCv({required this.id, required this.name, required this.subtitle});

  final String id;
  final String name;
  final String subtitle;
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
