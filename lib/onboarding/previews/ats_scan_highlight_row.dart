import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/onboarding_card_sizes.dart';
import 'package:sira/theme/app_palette.dart';

/// The green-bordered highlighted row with the "ATS SCAN" badge,
/// used inside [AtsScanPreview].
class AtsScanHighlightRow extends StatelessWidget {
  const AtsScanHighlightRow({super.key, required this.sizes});

  final OnboardingCardSizes sizes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
              color: context.palette.accent,
              width: sizes.scanRowBorderWidth,
            ),
            borderRadius: BorderRadius.circular(sizes.scanRowRadius),
            color: context.palette.scanRowBackground,
          ),
          child: Container(
            height: sizes.scanRowInnerBarHeight,
            decoration: BoxDecoration(
              color: context.palette.scanRowInnerBar,
              borderRadius: BorderRadius.circular(sizes.scanRowInnerBarRadius),
            ),
          ),
        ),
        PositionedDirectional(
          top: -sizes.badgeOffset,
          end: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizes.badgePaddingH,
              vertical: sizes.badgePaddingV,
            ),
            decoration: BoxDecoration(
              color: context.palette.accent,
              borderRadius: BorderRadius.circular(sizes.badgeRadius),
            ),
            child: Text(
              l10n.onboardingAtsScan,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.palette.onAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
