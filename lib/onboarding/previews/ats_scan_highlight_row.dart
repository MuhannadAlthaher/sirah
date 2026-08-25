import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_card_sizes.dart';
import 'package:sira/theme/app_palette.dart';

/// The green-bordered highlighted row with the "ATS SCAN" badge,
/// used inside [AtsScanPreview].
class AtsScanHighlightRow extends StatelessWidget {
  const AtsScanHighlightRow({super.key, required this.sizes});

  final OnboardingCardSizes sizes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: sizes.scanRowPaddingH,
            vertical: sizes.scanRowPaddingV,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppPalette.accent,
              width: sizes.scanRowBorderWidth,
            ),
            borderRadius: BorderRadius.circular(sizes.scanRowRadius),
            color: AppPalette.scanRowBackground,
          ),
          child: Container(
            height: sizes.scanRowInnerBarHeight,
            decoration: BoxDecoration(
              color: AppPalette.scanRowInnerBar,
              borderRadius: BorderRadius.circular(sizes.scanRowInnerBarRadius),
            ),
          ),
        ),
        Positioned(
          top: -sizes.badgeOffset,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizes.badgePaddingH,
              vertical: sizes.badgePaddingV,
            ),
            decoration: BoxDecoration(
              color: AppPalette.accent,
              borderRadius: BorderRadius.circular(sizes.badgeRadius),
            ),
            child: Text(
              'ATS SCAN',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
