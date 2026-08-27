import 'package:sira/shell/app_tab.dart';

/// Which bottom nav tab is currently showing.
class NavigationState {
  const NavigationState({required this.currentTab});

  factory NavigationState.initial() =>
      const NavigationState(currentTab: AppTab.home);

  final AppTab currentTab;

  NavigationState copyWith({AppTab? currentTab}) =>
      NavigationState(currentTab: currentTab ?? this.currentTab);
}
