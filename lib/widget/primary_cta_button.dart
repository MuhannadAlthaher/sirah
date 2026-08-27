import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// Full-width rounded accent button with a trailing icon, used as the
/// app's primary call-to-action (onboarding slides, "Create New CV",
/// ...).
///
/// Every size is a fraction of the button's own available width, so
/// it scales with the screen instead of relying on fixed pixel values.
class PrimaryCtaButton extends StatelessWidget {
  const PrimaryCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.palette.accent,
              foregroundColor: context.palette.onAccent,
              padding: EdgeInsets.symmetric(vertical: width * 0.045),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.palette.onAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Icon(icon, color: context.palette.onAccent),
              ],
            ),
          ),
        );
      },
    );
  }
}
