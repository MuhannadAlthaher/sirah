import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_slide_data.dart';
import 'package:sira/onboarding/widgets/feature_checklist.dart';
import 'package:sira/onboarding/widgets/onboarding_feature_card.dart';

/// Shared layout template for a single onboarding slide: a white,
/// bordered card holding the feature card, headline, description, and
/// checklist. Every slide reuses this template with its own
/// [OnboardingSlideData]; the white card is what visually separates
/// one slide from the next against the screen's gray background.
///
/// The slide is laid out once at a capped [_referenceWidth], then the
/// whole thing is scaled with [FittedBox] to fit whatever space the
/// page actually has. That keeps it non-scrolling (no nested vertical
/// scroll fighting the [PageView]'s horizontal drag, which is what
/// caused the janky swipes) and stops it from ballooning on wide
/// screens, while still shrinking to fit short/narrow ones.
class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({super.key, required this.data});

  final OnboardingSlideData data;

  static const _referenceWidth = 340.0;

  @override
  Widget build(BuildContext context) {
    final cardPadding = _referenceWidth * 0.05;
    final cardGap = _referenceWidth * 0.07;
    final textGap = _referenceWidth * 0.035;
    final listGap = _referenceWidth * 0.06;

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: _referenceWidth,
          child: Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
                width: cardPadding * 0.08,
              ),
              borderRadius: BorderRadius.circular(cardPadding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: cardPadding,
                  offset: Offset(0, cardPadding * 0.3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnboardingFeatureCard(
                  icon: data.icon,
                  previewBuilder: data.previewBuilder,
                ),
                SizedBox(height: cardGap),
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: textGap),
                Text(
                  data.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                ),
                SizedBox(height: listGap),
                FeatureChecklist(items: data.bullets),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
