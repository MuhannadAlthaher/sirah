import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_card_sizes.dart';
import 'package:sira/onboarding/previews/ats_scan_highlight_row.dart';
import 'package:sira/onboarding/widgets/placeholder_bar.dart';
import 'package:sira/theme/app_palette.dart';

/// Static "ATS scan" preview mockup: placeholder bars around a
/// highlighted scan row, shown inside [OnboardingFeatureCard].
class AtsScanPreview extends StatelessWidget {
  const AtsScanPreview({super.key, required this.sizes});

  final OnboardingCardSizes sizes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(sizes.previewPadding),
      decoration: BoxDecoration(
        color: AppPalette.previewBackground,
        borderRadius: BorderRadius.circular(sizes.previewRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: sizes.previewShadowBlur,
            offset: Offset(0, sizes.previewShadowOffset),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlaceholderBar(
            widthFactor: 0.5,
            height: sizes.titleBarHeight,
            color: AppPalette.titleBar,
          ),
          SizedBox(height: sizes.previewGap),
          PlaceholderBar(widthFactor: 1, height: sizes.barHeight),
          SizedBox(height: sizes.previewGap * 1.6),
          AtsScanHighlightRow(sizes: sizes),
          SizedBox(height: sizes.previewGap * 1.4),
          PlaceholderBar(widthFactor: 1, height: sizes.barHeight),
          SizedBox(height: sizes.previewGap * 0.6),
          PlaceholderBar(widthFactor: 1, height: sizes.barHeight),
          SizedBox(height: sizes.previewGap * 0.6),
          PlaceholderBar(widthFactor: 0.55, height: sizes.barHeight),
        ],
      ),
    );
  }
}
