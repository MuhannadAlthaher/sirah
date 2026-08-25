import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_card_sizes.dart';

/// Content for one onboarding slide: the feature card's icon and
/// preview mockup, the headline/body copy, the checklist below it,
/// and the label for the primary action button.
class OnboardingSlideData {
  const OnboardingSlideData({
    required this.icon,
    required this.previewBuilder,
    required this.title,
    required this.description,
    required this.bullets,
    required this.ctaLabel,
    this.showSecondaryAction = false,
  });

  final IconData icon;
  final Widget Function(OnboardingCardSizes sizes) previewBuilder;
  final String title;
  final String description;
  final List<String> bullets;
  final String ctaLabel;
  final bool showSecondaryAction;
}
