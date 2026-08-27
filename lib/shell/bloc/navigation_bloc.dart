import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/shell/app_tab.dart';
import 'package:sira/shell/bloc/navigation_event.dart';
import 'package:sira/shell/bloc/navigation_state.dart';

/// Owns which bottom nav tab is selected, so [AppShell] and
/// [AppBottomNavBar] stay pure presentation with no state of their
/// own.
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState.initial()) {
    on<NavigationTabSelected>(_onTabSelected);
  }

  void _onTabSelected(
    NavigationTabSelected event,
    Emitter<NavigationState> emit,
  ) {
    emit(state.copyWith(currentTab: AppTab.values[event.index]));
  }
}
