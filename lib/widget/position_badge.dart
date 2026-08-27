import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A small pill showing the user's job title (e.g. "Project
/// Manager"), sized off the passed-in [width] rather than measuring
/// itself, since it's a child of a [Row] that gives it loose/
/// unbounded constraints.
class PositionBadge extends StatelessWidget {
  const PositionBadge({super.key, required this.position, required this.width});

  final String position;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.012,
      ),
      decoration: BoxDecoration(
        color: context.palette.accentSoft,
        borderRadius: BorderRadius.circular(width * 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.work_outline,
            size: width * 0.035,
            color: context.palette.accent,
          ),
          SizedBox(width: width * 0.015),
          Text(
            position,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.palette.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
