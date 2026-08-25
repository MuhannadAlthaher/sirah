import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// Top navigation row for the onboarding flow: a brand logo mark,
/// the "Resume"+"AI" wordmark, and a "Skip" action on the right.
///
/// Every size is a fraction of the row's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final logoSize = width * 0.10;
        final spacing = width * 0.03;

        return Row(
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              padding: EdgeInsets.all(logoSize * 0.22),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppPalette.accent,
                  width: logoSize * 0.02,
                ),
                borderRadius: BorderRadius.circular(logoSize * 0.28),
              ),
              child: FittedBox(
                child: Icon(Icons.edit_document, color: AppPalette.accent),
              ),
            ),
            SizedBox(width: spacing),
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(text: 'Resume'),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(color: AppPalette.accent),
                  ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ],
        );
      },
    );
  }
}
