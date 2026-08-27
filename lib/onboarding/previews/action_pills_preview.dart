import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_card_sizes.dart';
import 'package:sira/theme/app_palette.dart';

/// Row of workflow-step pills used by the "build your CV" onboarding
/// slide (e.g. Fill -> AI -> Template -> Download). The first
/// [activeCount] pills render as reached steps, the rest as upcoming.
class ActionPillsPreview extends StatelessWidget {
  const ActionPillsPreview({
    super.key,
    required this.sizes,
    required this.labels,
    required this.activeCount,
  });

  final OnboardingCardSizes sizes;
  final List<String> labels;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    // FittedBox guarantees the row can never overflow: if the pills'
    // natural width exceeds what's available, it scales the whole
    // row down instead of clipping or erroring.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i != 0) SizedBox(width: sizes.previewGap * 0.5),
            _Pill(sizes: sizes, label: labels[i], active: i < activeCount),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.sizes, required this.label, required this.active});

  final OnboardingCardSizes sizes;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.badgePaddingH * 0.8,
        vertical: sizes.previewGap * 0.35,
      ),
      decoration: BoxDecoration(
        color: active
            ? context.palette.scanRowBackground
            : context.palette.surface,
        border: Border.all(
          color: active ? context.palette.accent : context.palette.border,
          width: sizes.scanRowBorderWidth,
        ),
        borderRadius: BorderRadius.circular(sizes.scanRowRadius),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
