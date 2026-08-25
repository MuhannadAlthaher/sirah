import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// Row of dots marking progress through a multi-page flow; the
/// active dot is wider and accent-colored.
///
/// Every size is a fraction of the row's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dotHeight = constraints.maxWidth * 0.02;
        final gap = constraints.maxWidth * 0.015;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i != 0) SizedBox(width: gap),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == currentIndex ? dotHeight * 3.2 : dotHeight,
                height: dotHeight,
                decoration: BoxDecoration(
                  color: i == currentIndex
                      ? AppPalette.accent
                      : AppPalette.placeholder,
                  borderRadius: BorderRadius.circular(dotHeight),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
