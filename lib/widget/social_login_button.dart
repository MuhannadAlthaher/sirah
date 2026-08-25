import 'package:flutter/material.dart';

/// Full-width rounded button for a single sign-in provider (Apple,
/// Google, email, ...), styled via [backgroundColor]/[foregroundColor]/
/// [borderColor] so each provider can match its own brand convention.
///
/// Every size is a fraction of the button's own available width, so
/// it scales with the screen instead of relying on fixed pixel values.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

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
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: width * 0.045),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.1),
                side: borderColor == null
                    ? BorderSide.none
                    : BorderSide(color: borderColor!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foregroundColor, size: width * 0.055),
                SizedBox(width: width * 0.03),
                // Flexible + ellipsis so a long label can never overflow
                // the button, regardless of screen width or font metrics.
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
