import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A tappable stat/action card used in the dashboard's "Quick
/// Actions" section (ATS score, create cover letter, ...) — pulled
/// out of [DashboardPage] so the two cards there share one
/// implementation instead of duplicating the same container twice.
///
/// Every size is a fraction of the card's own available width via
/// [LayoutBuilder], so it scales with whatever space its parent
/// (typically an [Expanded] in a [Row]) gives it.
class DashboardActionCard extends StatelessWidget {
  const DashboardActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.1;
        final iconSize = width * 0.22;
        final radius = width * 0.08;

        return Material(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                border: Border.all(color: context.palette.border),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                      icon,
                      color: context.palette.accent,
                      size: iconSize * 0.55,
                    ),
                  ),
                  SizedBox(height: padding * 0.7),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.palette.textSecondary,
                    ),
                  ),
                  SizedBox(height: padding * 0.2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
