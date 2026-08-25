import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_card_sizes.dart';
import 'package:sira/theme/app_palette.dart';

/// "BEFORE"/"AFTER" comparison mockup used by the AI-rewrite
/// onboarding slide.
class BeforeAfterPreview extends StatelessWidget {
  const BeforeAfterPreview({
    super.key,
    required this.sizes,
    required this.before,
    required this.after,
  });

  final OnboardingCardSizes sizes;
  final String before;
  final String after;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ComparisonBox(
          sizes: sizes,
          label: 'BEFORE',
          text: before,
          background: AppPalette.previewBackground,
          borderColor: Colors.transparent,
          labelColor: Colors.black45,
        ),
        SizedBox(height: sizes.previewGap),
        _ComparisonBox(
          sizes: sizes,
          label: 'AFTER',
          text: after,
          background: AppPalette.scanRowBackground,
          borderColor: AppPalette.accent,
          labelColor: AppPalette.accent,
        ),
      ],
    );
  }
}

class _ComparisonBox extends StatelessWidget {
  const _ComparisonBox({
    required this.sizes,
    required this.label,
    required this.text,
    required this.background,
    required this.borderColor,
    required this.labelColor,
  });

  final OnboardingCardSizes sizes;
  final String label;
  final String text;
  final Color background;
  final Color borderColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(sizes.previewPadding),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: borderColor, width: sizes.scanRowBorderWidth),
        borderRadius: BorderRadius.circular(sizes.previewRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sizes.previewGap * 0.5),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
