import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// Shown under a collapsible dashboard section that has no items yet
/// (e.g. "My Cover Letters" before that feature exists).
///
/// Every size is a fraction of the placeholder's own available width,
/// so it scales with the screen instead of relying on fixed pixel
/// values.
class EmptySectionPlaceholder extends StatelessWidget {
  const EmptySectionPlaceholder({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

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
            color: Colors.white,
            border: Border.all(color: AppPalette.border),
            borderRadius: BorderRadius.circular(padding * 0.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: padding * 0.3),
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        );
      },
    );
  }
}
