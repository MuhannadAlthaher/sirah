import 'package:equatable/equatable.dart';

/// Events the onboarding UI dispatches to [OnboardingBloc]. The
/// screen never mutates its own page state — it only describes what
/// happened.
sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// The primary CTA was tapped, requesting the next slide.
class OnboardingNextSlideRequested extends OnboardingEvent {
  const OnboardingNextSlideRequested();
}

/// "Skip" was tapped, jumping straight to the last slide.
class OnboardingSkipRequested extends OnboardingEvent {
  const OnboardingSkipRequested();
}

/// The PageView settled on a new page, whether from a swipe or a
/// bloc-driven page change.
class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
