/// The signed-in user shown on the dashboard. Demo data for now —
/// swap for the real profile once auth is wired up.
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

const demoUser = DemoUser(name: 'Alex Morgan', position: 'Project Manager');

/// The user's average ATS match score across their CVs, out of 100.
/// Demo data for now — swap for the real computed score once ATS
/// scoring exists.
const demoAtsScore = 87;

const demoCvs = [
  DemoCv(
    id: 'cv-1',
    name: 'Product Manager Resume',
    subtitle: 'Edited 2 days ago',
  ),
  DemoCv(
    id: 'cv-2',
    name: 'Software Engineer CV',
    subtitle: 'Edited 1 week ago',
  ),
  DemoCv(
    id: 'cv-3',
    name: 'Marketing Specialist Resume',
    subtitle: 'Edited 3 weeks ago',
  ),
];
