import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A rounded placeholder line, [widthFactor] of its parent's width.
class PlaceholderBar extends StatelessWidget {
  const PlaceholderBar({
    super.key,
    required this.widthFactor,
    required this.height,
    this.color = AppPalette.placeholder,
  });

  final double widthFactor;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }
}
