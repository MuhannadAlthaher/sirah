import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/onboarding/bloc/onboarding_event.dart';
import 'package:sira/onboarding/bloc/onboarding_state.dart';
import 'package:sira/onboarding/onboarding_slides.dart';

/// Owns the onboarding flow's current-page state and the
/// [PageController] that drives it, so the onboarding screen itself
/// stays a pure presentation layer with no state of its own.
///
/// The [PageController] lives here rather than being passed in,
/// because it needs disposing — [close] (the Bloc equivalent of a
/// [State.dispose]) is the correct place for that once this bloc
/// stops being provided.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState.initial()) {
    on<OnboardingNextSlideRequested>(_onNextSlideRequested);
    on<OnboardingSkipRequested>(_onSkipRequested);
    on<OnboardingPageChanged>(_onPageChanged);
  }

  final PageController pageController = PageController();

  void _onNextSlideRequested(
    OnboardingNextSlideRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.isLastSlide) return;
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onSkipRequested(
    OnboardingSkipRequested event,
    Emitter<OnboardingState> emit,
  ) {
    pageController.animateToPage(
      onboardingSlideCount - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
