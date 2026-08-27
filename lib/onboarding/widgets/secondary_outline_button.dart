import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// Full-width outlined button used for secondary onboarding actions
/// (e.g. "I already have an account").
///
/// Every size is a fraction of the button's own available width, so
/// it scales with the screen instead of relying on fixed pixel values.
class SecondaryOutlineButton extends StatelessWidget {
  const SecondaryOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.palette.textPrimary,
              side: BorderSide(color: context.palette.border),
              padding: EdgeInsets.symmetric(vertical: width * 0.045),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.1),
              ),
            ),
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
