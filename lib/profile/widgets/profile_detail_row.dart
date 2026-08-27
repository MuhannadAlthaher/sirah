import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// One row of profile info: an icon, a label, its value, and a
/// trailing arrow — tapping anywhere on the row triggers [onTap]
/// (navigating to that field's own edit screen).
///
/// Every size is a fraction of the row's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(width * 0.03),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: width * 0.025),
            child: Row(
              children: [
                Icon(icon, color: context.palette.accent, size: width * 0.09),
                SizedBox(width: width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.palette.textSecondary,
                        ),
                      ),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.02),
                Icon(
                  isRtl ? Icons.chevron_left : Icons.chevron_right,
                  color: context.palette.textMuted,
                  size: width * 0.06,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
