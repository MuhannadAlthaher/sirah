import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// A small document-shaped placeholder thumbnail for a CV, standing
/// in until real rendered previews are available.
class CvThumbnail extends StatelessWidget {
  const CvThumbnail({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.3,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppPalette.accentSoft,
        borderRadius: BorderRadius.circular(size * 0.15),
        border: Border.all(color: AppPalette.border),
      ),
      child: Icon(
        Icons.description_outlined,
        color: AppPalette.accent,
        size: size * 0.5,
      ),
    );
  }
}
