/// Events the app shell's UI dispatches to [NavigationBloc].
sealed class NavigationEvent {
  const NavigationEvent();
}

/// A bottom nav bar tab was tapped.
class NavigationTabSelected extends NavigationEvent {
  const NavigationTabSelected(this.index);

  final int index;
}
