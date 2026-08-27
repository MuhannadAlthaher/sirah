import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

enum _CvMenuAction { edit, preview, download, share, delete }

/// The "⋮" menu on a [CvCard]'s bottom-right, offering Edit/Preview/
/// Download/Share/Delete without needing five separate buttons on the
/// tile.
///
/// Every size is a fraction of [width] (the card's own width), so it
/// scales with the screen instead of relying on fixed pixel values.
class CvOverflowMenuButton extends StatelessWidget {
  const CvOverflowMenuButton({
    super.key,
    required this.width,
    required this.onEdit,
    required this.onPreview,
    required this.onDownload,
    required this.onShare,
    required this.onDelete,
  });

  final double width;
  final VoidCallback onEdit;
  final VoidCallback onPreview;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = width * 0.06;

    return PopupMenuButton<_CvMenuAction>(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_vert,
        color: context.palette.textSecondary,
        size: width * 0.07,
      ),
      color: context.palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: context.palette.border),
      ),
      onSelected: (action) => switch (action) {
        _CvMenuAction.edit => onEdit(),
        _CvMenuAction.preview => onPreview(),
        _CvMenuAction.download => onDownload(),
        _CvMenuAction.share => onShare(),
        _CvMenuAction.delete => onDelete(),
      },
      itemBuilder: (context) => [
        _item(context, _CvMenuAction.edit, Icons.edit_outlined, l10n.edit),
        _item(
          context,
          _CvMenuAction.preview,
          Icons.visibility_outlined,
          l10n.preview,
        ),
        _item(
          context,
          _CvMenuAction.download,
          Icons.download_outlined,
          l10n.download,
        ),
        _item(context, _CvMenuAction.share, Icons.share_outlined, l10n.share),
        _item(
          context,
          _CvMenuAction.delete,
          Icons.delete_outline,
          l10n.delete,
          color: context.palette.danger,
        ),
      ],
    );
  }

  PopupMenuItem<_CvMenuAction> _item(
    BuildContext context,
    _CvMenuAction action,
    IconData icon,
    String label, {
    Color? color,
  }) {
    return PopupMenuItem(
      value: action,
      child: Row(
        children: [
          Icon(
            icon,
            color: color ?? context.palette.accent,
            size: width * 0.055,
          ),
          SizedBox(width: width * 0.03),
          Text(label, style: color == null ? null : TextStyle(color: color)),
        ],
      ),
    );
  }
}
