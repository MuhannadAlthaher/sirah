import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_card_sizes.dart';
import 'package:sira/theme/app_palette.dart';

/// The icon-and-blob card shell shown at the top of every onboarding
/// slide. [previewBuilder] renders the slide-specific mockup inside
/// it, which overlaps the decorative blob because the header above it
/// is shorter than the blob's own bottom edge; it's a builder (not a
/// plain [Widget]) because the mockup needs the [OnboardingCardSizes]
/// this card computes from its own resolved width.
///
/// Every size is a fraction of that width via [LayoutBuilder], so the
/// card scales for any screen instead of relying on fixed pixels.
class OnboardingFeatureCard extends StatelessWidget {
  const OnboardingFeatureCard({
    super.key,
    required this.icon,
    required this.previewBuilder,
  });

  final IconData icon;
  final Widget Function(OnboardingCardSizes sizes) previewBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sizes = OnboardingCardSizes(constraints.maxWidth);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppPalette.border,
              width: sizes.cardBorderWidth,
            ),
            borderRadius: BorderRadius.circular(sizes.cardRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background layer: the blob sits behind everything else,
              // so the icon and preview box always paint above it.
              Positioned(
                top: -sizes.blobOffset,
                right: -sizes.blobOffset,
                child: Container(
                  width: sizes.blobSize,
                  height: sizes.blobSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppPalette.blob,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: sizes.headerHeight,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(sizes.iconInset),
                        child: Container(
                          width: sizes.iconSize,
                          height: sizes.iconSize,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(sizes.iconPadding),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPalette.accentSoft,
                          ),
                          child: Icon(icon, color: AppPalette.accent),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes.spacing,
                    ).copyWith(bottom: sizes.spacing * 0.5),
                    child: previewBuilder(sizes),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
