import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/profile_avatar.dart';

/// The profile picture with a small camera badge, tappable to change
/// the photo via [pickProfilePhoto].
///
/// Every size is a fraction of [size] (the avatar's own diameter), so
/// it scales with the screen instead of relying on fixed pixel
/// values.
class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    super.key,
    required this.name,
    required this.size,
    required this.imagePath,
    required this.onPicked,
  });

  final String name;
  final double size;
  final String? imagePath;
  final ValueChanged<String> onPicked;

  @override
  Widget build(BuildContext context) {
    final badgeSize = size * 0.32;

    return GestureDetector(
      onTap: () => pickProfilePhoto(context, onPicked: onPicked),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ProfileAvatar(name: name, size: size, imagePath: imagePath),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.palette.accent,
                border: Border.all(
                  color: context.palette.screenBackground,
                  width: badgeSize * 0.12,
                ),
              ),
              child: Icon(
                Icons.camera_alt,
                color: context.palette.onAccent,
                size: badgeSize * 0.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens a bottom sheet to pick Camera or Gallery, then launches
/// [ImagePicker], calling [onPicked] with the new image's path if the
/// user picked one (dismissing the sheet without choosing a source,
/// or cancelling the picker, does nothing).
Future<void> pickProfilePhoto(
  BuildContext context, {
  required ValueChanged<String> onPicked,
}) async {
  final l10n = context.l10n;

  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.takePhoto),
            onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.chooseFromGallery),
            onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null) return;

  final picked = await ImagePicker().pickImage(
    source: source,
    maxWidth: 1024,
    imageQuality: 85,
  );
  if (picked != null) {
    onPicked(picked.path);
  }
}
