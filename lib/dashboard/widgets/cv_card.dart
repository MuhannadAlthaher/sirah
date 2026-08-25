import 'package:flutter/material.dart';
import 'package:sira/dashboard/cv_view_page.dart';
import 'package:sira/dashboard/dashboard_demo_data.dart';
import 'package:sira/dashboard/widgets/cv_action_button.dart';
import 'package:sira/dashboard/widgets/cv_thumbnail.dart';
import 'package:sira/theme/app_palette.dart';

/// One CV entry: thumbnail, name + subtitle, and Edit/Preview/
/// Download/Share actions. Tapping the card (outside the action row)
/// opens the same preview as the Preview action.
///
/// Purely presentational: [onEdit], [onDownload], and [onShare] are
/// supplied by the caller (typically dispatching a Bloc event) rather
/// than decided here — this widget doesn't know what "coming soon"
/// means or how feedback is shown.
class CvCard extends StatelessWidget {
  const CvCard({
    super.key,
    required this.cv,
    required this.width,
    required this.onEdit,
    required this.onDownload,
    required this.onShare,
  });

  final DemoCv cv;
  final double width;
  final VoidCallback onEdit;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final padding = width * 0.04;
    final thumbSize = width * 0.13;
    final radius = width * 0.04;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: () => _openPreview(context),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(color: AppPalette.border),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CvThumbnail(size: thumbSize),
                  SizedBox(width: padding * 0.8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cv.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: padding * 0.2),
                        Text(
                          cv.subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding * 0.6),
              Row(
                children: [
                  Expanded(
                    child: CvActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      width: width,
                      onTap: onEdit,
                    ),
                  ),
                  Expanded(
                    child: CvActionButton(
                      icon: Icons.visibility_outlined,
                      label: 'Preview',
                      width: width,
                      onTap: () => _openPreview(context),
                    ),
                  ),
                  Expanded(
                    child: CvActionButton(
                      icon: Icons.download_outlined,
                      label: 'Download',
                      width: width,
                      onTap: onDownload,
                    ),
                  ),
                  Expanded(
                    child: CvActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      width: width,
                      onTap: onShare,
                    ),
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
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CvViewPage(cv: cv)));
  }
}
