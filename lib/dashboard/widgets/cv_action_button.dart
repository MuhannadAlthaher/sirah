import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// One icon+label action on a [CvCard] (Edit, Preview, Download,
/// Share). Meant to be wrapped in [Expanded] by the caller so any
/// number of these divide the available width evenly and can never
/// overflow, regardless of screen size.
class CvActionButton extends StatelessWidget {
  const CvActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.width,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(width * 0.03),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: width * 0.05, color: AppPalette.accent),
            SizedBox(height: width * 0.005),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
