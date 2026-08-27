import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// The CV Builder's shared header: a back arrow (hidden on the first
/// step) and a close button on the other side (shown on every step),
/// a "Step X of N" caption, the step's title, and a slim progress bar
/// — shown above the [PageView] on every step.
///
/// Every size is a fraction of the header's own available width, so
/// it scales with the screen instead of relying on fixed pixel
/// values.
class StepProgressHeader extends StatelessWidget {
  const StepProgressHeader({
    super.key,
    required this.stepIndex,
    required this.stepCount,
    required this.title,
    required this.onClose,
    this.onBack,
    this.onPreview,
  });

  /// 0-based.
  final int stepIndex;
  final int stepCount;
  final String title;

  /// The "X" button — always available, so the user can leave (and
  /// choose to save or discard) from any step.
  final VoidCallback onClose;

  /// Null on the first step, where there's nothing to go back to.
  final VoidCallback? onBack;

  /// The "peek at the CV" action — null hides the button entirely.
  final VoidCallback? onPreview;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;
        final l10n = context.l10n;
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        return Padding(
          padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: width * 0.11,
                child: Row(
                  children: [
                    if (onBack != null)
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onBack,
                        icon: Icon(
                          isRtl ? Icons.arrow_forward : Icons.arrow_back,
                          color: context.palette.textPrimary,
                        ),
                      ),
                    const Spacer(),
                    if (onPreview != null)
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onPreview,
                        tooltip: l10n.cvPreviewTitle,
                        icon: Icon(
                          Icons.visibility_outlined,
                          color: context.palette.textSecondary,
                        ),
                      ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onClose,
                      tooltip: l10n.close,
                      icon: Icon(
                        Icons.close,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.cvStepOf(stepIndex + 1, stepCount),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.palette.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: padding * 0.2),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: padding * 0.5),
              ClipRRect(
                borderRadius: BorderRadius.circular(padding),
                child: LinearProgressIndicator(
                  value: (stepIndex + 1) / stepCount,
                  minHeight: padding * 0.2,
                  backgroundColor: context.palette.placeholder,
                  color: context.palette.accent,
                ),
              ),
              SizedBox(height: padding * 0.6),
            ],
          ),
        );
      },
    );
  }
}
