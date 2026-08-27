import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// The fixed bottom area holding a step's primary CTA (and, on some
/// steps, a secondary action above it) — kept easily reachable near
/// the bottom of the screen on every step, as its own bordered strip
/// so it stays visually distinct from the scrolling content above it.
///
/// Every size is a fraction of the bar's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class StepBottomBar extends StatelessWidget {
  const StepBottomBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: context.palette.screenBackground,
            border: Border(top: BorderSide(color: context.palette.border)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  if (i != 0) SizedBox(height: padding * 0.6),
                  children[i],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
