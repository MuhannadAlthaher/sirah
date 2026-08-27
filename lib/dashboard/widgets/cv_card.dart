import 'package:flutter/material.dart';
import 'package:sira/cv_builder/preview/cv_preview_page.dart';
import 'package:sira/dashboard/cv_view_page.dart';
import 'package:sira/data/demo_data.dart';
import 'package:sira/dashboard/widgets/cv_overflow_menu.dart';
import 'package:sira/theme/app_palette.dart';

/// One CV tile in the CVs grid: icon on top, name and last-edited
/// label at the bottom, with a "⋮" menu (Edit/Preview/Download/
/// Share/Delete) on the bottom-right. Tapping the tile itself
/// (outside the menu) opens the same preview as the menu's Preview
/// action — the real rendered CV when [cv] carries [DemoCv
/// .builderState], the old placeholder otherwise (the seeded sample
/// cards have no real content behind them).
///
/// Mostly presentational: [onEdit], [onDownload], [onShare], and
/// [onDelete] are supplied by the caller (typically dispatching a Bloc
/// event) rather than decided here — this widget doesn't know what
/// "coming soon" means, how a delete gets confirmed, or how feedback
/// is shown. Which page Preview opens is the one exception, same as
/// it always has been for this tile.
class CvCard extends StatelessWidget {
  const CvCard({
    super.key,
    required this.cv,
    required this.width,
    required this.onEdit,
    required this.onDownload,
    required this.onShare,
    required this.onDelete,
  });

  final DemoCv cv;
  final double width;
  final VoidCallback onEdit;
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final padding = width * 0.08;
    final iconBoxSize = width * 0.34;
    final radius = width * 0.08;

    return Material(
      color: context.palette.surface,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: () => _openPreview(context),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(color: context.palette.border),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.palette.accentSoft,
                    borderRadius: BorderRadius.circular(iconBoxSize * 0.25),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: context.palette.accent,
                    size: iconBoxSize * 0.5,
                  ),
                ),
              ),
              SizedBox(height: padding * 0.9),
              Text(
                cv.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: padding * 0.4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cv.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ),
                  CvOverflowMenuButton(
                    width: width,
                    onEdit: onEdit,
                    onPreview: () => _openPreview(context),
                    onDownload: onDownload,
                    onShare: onShare,
                    onDelete: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    final builderState = cv.builderState;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => builderState == null
            ? CvViewPage(cv: cv)
            : CvPreviewPage(state: builderState, mode: CvPreviewMode.peek),
      ),
    );
  }
}
