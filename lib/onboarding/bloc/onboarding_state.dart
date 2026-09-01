import 'package:equatable/equatable.dart';
import 'package:sira/onboarding/onboarding_slides.dart';

/// The onboarding flow's current-page state.
class OnboardingState extends Equatable {
  const OnboardingState({required this.currentIndex});

  factory OnboardingState.initial() => const OnboardingState(currentIndex: 0);

  final int currentIndex;

  bool get isLastSlide => currentIndex == onboardingSlideCount - 1;

  @override
  List<Object?> get props => [currentIndex];

  OnboardingState copyWith({int? currentIndex}) =>
      OnboardingState(currentIndex: currentIndex ?? this.currentIndex);
}
