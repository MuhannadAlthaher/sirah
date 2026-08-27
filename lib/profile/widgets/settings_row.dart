import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// One tappable row in the Settings list.
///
/// Every size is a fraction of the row's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: width * 0.035),
            child: Row(
              children: [
                Icon(icon, color: context.palette.accent, size: width * 0.055),
                SizedBox(width: width * 0.04),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
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
