import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/auth/login_page.dart';
import 'package:sira/onboarding/bloc/onboarding_bloc.dart';
import 'package:sira/onboarding/bloc/onboarding_event.dart';
import 'package:sira/onboarding/bloc/onboarding_state.dart';
import 'package:sira/onboarding/onboarding_slide_view.dart';
import 'package:sira/onboarding/onboarding_slides.dart';
import 'package:sira/onboarding/widgets/onboarding_header.dart';
import 'package:sira/onboarding/widgets/page_indicator.dart';
import 'package:sira/onboarding/widgets/secondary_outline_button.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// The app's onboarding flow: a single screen paging through
/// [onboardingSlides] with a shared header, page indicator, and
/// action buttons. All page state lives in [OnboardingBloc], scoped
/// to just this screen since onboarding only ever runs once — there's
/// no reason to keep it (or its [PageController]) alive for the rest
/// of the app's session the way [DashboardBloc] is.
class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  void _openLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          onGuestContinue: () {
            // TODO: navigate to the app's home/CV builder once it exists.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Continuing as guest...')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OnboardingBloc>();

    return Scaffold(
      backgroundColor: AppPalette.screenBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth * 0.02;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                children: [
                  SizedBox(height: padding),
                  OnboardingHeader(
                    onSkip: () => bloc.add(const OnboardingSkipRequested()),
                  ),
                  Expanded(
                    child: PageView(
                      controller: bloc.pageController,
                      onPageChanged: (index) =>
                          bloc.add(OnboardingPageChanged(index)),
                      children: [
                        for (final slide in onboardingSlides)
                          OnboardingSlideView(data: slide),
                      ],
                    ),
                  ),
                  BlocSelector<OnboardingBloc, OnboardingState, int>(
                    selector: (state) => state.currentIndex,
                    builder: (context, currentIndex) => PageIndicator(
                      count: onboardingSlides.length,
                      currentIndex: currentIndex,
                    ),
                  ),
                  SizedBox(height: padding),
                  BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, state) => Column(
                      children: [
                        PrimaryCtaButton(
                          label: state.currentSlide.ctaLabel,
                          onPressed: () {
                            if (state.isLastSlide) {
                              _openLogin(context);
                            } else {
                              bloc.add(const OnboardingNextSlideRequested());
                            }
                          },
                        ),
                        if (state.currentSlide.showSecondaryAction) ...[
                          SizedBox(height: padding * 0.6),
                          SecondaryOutlineButton(
                            label: 'I already have an account',
                            onPressed: () => _openLogin(context),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: padding),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
