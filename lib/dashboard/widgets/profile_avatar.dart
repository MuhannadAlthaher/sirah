import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A circular profile picture placeholder showing the user's
/// initials — stands in until real avatar images are wired up.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.name, required this.size});

  final String name;
  final double size;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0]).join();
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.accent,
      ),
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
