import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A circular badge showing a percentage score, with an optional
/// caption under it — the ring shown on the Score tab, and (smaller,
/// without [label]) on the dashboard's "ATS Score" quick-action card.
///
/// Every size is a fraction of [size] (the ring's own diameter), so
/// it scales with whatever [size] its caller gives it instead of
/// relying on fixed pixel values.
class ScoreRing extends StatelessWidget {
  const ScoreRing({
    super.key,
    required this.score,
    required this.size,
    this.label,
  });

  final int score;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.palette.surface,
        border: Border.all(color: context.palette.accent, width: size * 0.0375),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score%',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: context.palette.accent,
            ),
          ),
          if (label != null)
            Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: size * 0.095,
                color: context.palette.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
