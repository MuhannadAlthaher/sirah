import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A circular profile picture: the user's chosen photo if [imagePath]
/// is set, otherwise a placeholder showing their initials.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    required this.size,
    this.imagePath,
  });

  final String name;
  final double size;
  final String? imagePath;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0]).join();
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final path = imagePath;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.palette.accent,
        image: path == null
            ? null
            : DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
      ),
      child: path != null
          ? null
          : Text(
              _initials,
              style: TextStyle(
                color: context.palette.onAccent,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.38,
              ),
            ),
    );
  }
}
