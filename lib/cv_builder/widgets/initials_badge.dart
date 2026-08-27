import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A small rounded-square badge showing up to two initials from
/// [text] (e.g. a company or school name) — used to give the
/// Experience/Education/Certification summary cards a quick visual
/// anchor instead of a wall of same-weight text.
class InitialsBadge extends StatelessWidget {
  const InitialsBadge({super.key, required this.text, required this.size});

  final String text;
  final double size;

  String get _initials {
    final words = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final letters = words.take(2).map((w) => w[0]).join();
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.palette.accentSoft,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Text(
        _initials,
        style: TextStyle(
          color: context.palette.accent,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
