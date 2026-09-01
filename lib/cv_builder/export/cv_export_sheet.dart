import 'package:flutter/material.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/export/cv_export_actions.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// Lets the user pick PDF or Word before exporting [state] — used by
/// the CV card's "Download" action. `CvPreviewPage` shows both as
/// direct buttons instead, since there's already room for two there.
Future<void> showCvExportSheet(
  BuildContext context, {
  required CvBuilderState state,
  required CvTemplateId templateId,
}) {
  final l10n = context.l10n;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.cvExportChooseFormat,
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _ExportOptionTile(
                icon: Icons.picture_as_pdf_outlined,
                title: l10n.cvExportPdf,
                subtitle: l10n.cvExportPdfDescription,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  exportCvAsPdf(context, state: state, templateId: templateId);
                },
              ),
              _ExportOptionTile(
                icon: Icons.description_outlined,
                title: l10n.cvExportWord,
                subtitle: l10n.cvExportWordDescription,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  exportCvAsWord(context, state: state, templateId: templateId);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ExportOptionTile extends StatelessWidget {
  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: context.palette.accent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
