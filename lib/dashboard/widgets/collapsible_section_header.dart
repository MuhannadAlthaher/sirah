import 'package:flutter/material.dart';

/// A section title (e.g. "My CVs") with a chevron that rotates and
/// toggles [expanded] via [onToggle] when tapped anywhere on the row.
///
/// Every size is a fraction of the header's own available width, so
/// it scales with the screen instead of relying on fixed pixel values.
class CollapsibleSectionHeader extends StatelessWidget {
  const CollapsibleSectionHeader({
    super.key,
    required this.title,
    required this.expanded,
    required this.onToggle,
  });

  final String title;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(width * 0.02),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: width * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more, size: width * 0.07),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
