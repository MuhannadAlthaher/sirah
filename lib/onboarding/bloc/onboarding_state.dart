import 'package:sira/onboarding/onboarding_slide_data.dart';
import 'package:sira/onboarding/onboarding_slides.dart';

/// The onboarding flow's current-page state.
class OnboardingState {
  const OnboardingState({required this.currentIndex});

  factory OnboardingState.initial() => const OnboardingState(currentIndex: 0);

  final int currentIndex;

  OnboardingSlideData get currentSlide => onboardingSlides[currentIndex];
  bool get isLastSlide => currentIndex == onboardingSlides.length - 1;

  OnboardingState copyWith({int? currentIndex}) =>
      OnboardingState(currentIndex: currentIndex ?? this.currentIndex);
}
