import 'package:sira/onboarding/onboarding_slides.dart';

/// The onboarding flow's current-page state.
class OnboardingState {
  const OnboardingState({required this.currentIndex});

  factory OnboardingState.initial() => const OnboardingState(currentIndex: 0);

  final int currentIndex;

  bool get isLastSlide => currentIndex == onboardingSlideCount - 1;

  OnboardingState copyWith({int? currentIndex}) =>
      OnboardingState(currentIndex: currentIndex ?? this.currentIndex);
}
