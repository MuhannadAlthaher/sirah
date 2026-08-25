/// Events the dashboard UI dispatches to [DashboardBloc]. The page
/// and its widgets never mutate state directly — they only describe
/// what happened.
sealed class DashboardEvent {
  const DashboardEvent();
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
}

/// The UI finished showing [DashboardState.pendingMessage] (e.g. the
/// SnackBar was presented), so it can be cleared.
class DashboardMessageShown extends DashboardEvent {
  const DashboardMessageShown();
}
