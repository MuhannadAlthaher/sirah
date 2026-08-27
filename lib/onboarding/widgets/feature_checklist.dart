import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A vertical list of checkmark bullet rows, shown under each
/// onboarding slide's description.
///
/// Every size is a fraction of the list's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class FeatureChecklist extends StatelessWidget {
  const FeatureChecklist({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final iconSize = width * 0.08;
        final gap = width * 0.03;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in items) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.palette.accentSoft,
                    ),
                    child: Icon(
                      Icons.check,
                      size: iconSize * 0.6,
                      color: context.palette.accent,
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap * 0.6),
            ],
          ],
        );
      },
    );
  }
}
