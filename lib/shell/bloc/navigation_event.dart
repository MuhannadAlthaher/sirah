import 'package:equatable/equatable.dart';

/// Events the app shell's UI dispatches to [NavigationBloc].
sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

/// A bottom nav bar tab was tapped.
class NavigationTabSelected extends NavigationEvent {
  const NavigationTabSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
