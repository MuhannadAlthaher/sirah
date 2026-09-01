import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A circular badge showing a percentage score, with an optional
/// caption under it — the ring shown on the Score tab, and (smaller,
/// without [label]) on the dashboard's "ATS Score" quick-action card.
///
/// The ring itself is a real progress arc (not just a colored
/// outline), and animates — counting the number up and sweeping the
/// arc from wherever it currently sits to the new [score] — every
/// time [score] changes, including the very first time it appears.
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
    final palette = context.palette;
    final hasLabel = label != null;
    final strokeWidth = size * 0.0375;
    final innerPadding = strokeWidth * (hasLabel ? 2.8 : 3.6);
    final innerDiameter = size - (innerPadding * 2);
    final scoreFontSize = size * (hasLabel ? 0.2 : 0.17);
    final labelFontSize = size * 0.09;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score / 100),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.surface,
                ),
              ),
              CircularProgressIndicator(
                value: 1,
                strokeWidth: strokeWidth,
                valueColor: AlwaysStoppedAnimation(palette.placeholder),
              ),
              CircularProgressIndicator(
                value: value.clamp(0.0, 1.0),
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation(palette.accent),
              ),
              MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.noScaling),
                child: SizedBox(
                  width: innerDiameter,
                  height: innerDiameter,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(value * 100).round()}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: scoreFontSize,
                            fontWeight: FontWeight.bold,
                            height: 1,
                            letterSpacing: -scoreFontSize * 0.03,
                            color: palette.accent,
                          ),
                        ),
                        if (label != null) ...[
                          SizedBox(height: size * 0.02),
                          Text(
                            label!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: labelFontSize,
                              height: 1,
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
