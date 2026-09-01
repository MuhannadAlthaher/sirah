import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// One row on the Hub's checklist: a leading circle (a checkmark once
/// complete, otherwise [displayNumber]), the section's title and
/// status subtitle, and a trailing arrow. Tapping it opens that
/// section in the wizard.
///
/// Every size is a fraction of the row's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class CvBuilderSectionRow extends StatelessWidget {
  const CvBuilderSectionRow({
    super.key,
    required this.displayNumber,
    required this.title,
    required this.subtitle,
    required this.isComplete,
    required this.onTap,
    this.isInactive = false,
    this.dragHandle,
    this.trailingAction,
  });

  final int displayNumber;
  final String title;
  final String subtitle;
  final bool isComplete;
  final VoidCallback onTap;

  /// Dimmed and labeled "inactive" instead of the usual complete/
  /// incomplete status — a deactivated optional section still has its
  /// data, it just won't render on the CV.
  final bool isInactive;

  /// A drag-handle icon wrapped in a `ReorderableDragStartListener` by
  /// the caller — null for rows that never reorder (Personal Info,
  /// Summary).
  final Widget? dragHandle;

  /// The "⋮" menu for optional sections (Deactivate/Activate, Remove)
  /// — replaces the trailing chevron when present.
  final Widget? trailingAction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.04;
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: padding),
            child: Row(
              children: [
                if (dragHandle != null) ...[
                  dragHandle!,
                  SizedBox(width: padding * 0.6),
                ],
                Opacity(
                  opacity: isInactive ? 0.45 : 1,
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.1,
                        height: width * 0.1,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isComplete
                              ? context.palette.accent
                              : context.palette.placeholder,
                        ),
                        child: isComplete
                            ? Icon(
                                Icons.check,
                                color: context.palette.onAccent,
                                size: width * 0.06,
                              )
                            : Text(
                                '$displayNumber',
                                style: TextStyle(
                                  color: context.palette.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      SizedBox(width: padding),
                    ],
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: isInactive ? 0.45 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: context.palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                if (trailingAction != null)
                  trailingAction!
                else
                  Icon(
                    isRtl ? Icons.chevron_left : Icons.chevron_right,
                    color: context.palette.textMuted,
                    size: width * 0.05,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
