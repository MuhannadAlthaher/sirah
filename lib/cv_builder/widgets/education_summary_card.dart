import 'package:flutter/material.dart';
import 'package:sira/cv_builder/models/education.dart';
import 'package:sira/cv_builder/widgets/initials_badge.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A completed [Education] entry shown as a clean summary card on
/// the Education step, with a preview of its description and
/// Edit/Delete actions.
///
/// Every size is a fraction of the card's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class EducationSummaryCard extends StatelessWidget {
  const EducationSummaryCard({
    super.key,
    required this.education,
    required this.onEdit,
    required this.onDelete,
  });

  final Education education;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;
        final l10n = context.l10n;
        final dateRange =
            '${education.startLabel(l10n)} – ${education.endLabel(l10n)}';
        final subtitle = education.fieldOfStudy.trim().isEmpty
            ? '${education.institution} · $dateRange'
            : '${education.fieldOfStudy} · '
                  '${education.institution} · $dateRange';
        final descriptionPreview = RichTextField.plainTextOf(
          education.description,
        );

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: context.palette.surface,
            border: Border.all(color: context.palette.border),
            borderRadius: BorderRadius.circular(padding * 0.6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InitialsBadge(
                    text: education.institution,
                    size: width * 0.13,
                  ),
                  SizedBox(width: padding * 0.7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          education.degree,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: padding * 0.15),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: context.palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (descriptionPreview.isNotEmpty) ...[
                SizedBox(height: padding * 0.5),
                Text(
                  descriptionPreview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.palette.textSecondary,
                  ),
                ),
              ],
              SizedBox(height: padding * 0.5),
              Divider(height: 1, color: context.palette.border),
              SizedBox(height: padding * 0.6),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.palette.textPrimary,
                      side: BorderSide(color: context.palette.border),
                      shape: const StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                        horizontal: padding * 0.7,
                        vertical: padding * 0.35,
                      ),
                    ),
                    child: Text(l10n.edit),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onDelete,
                    style: TextButton.styleFrom(
                      foregroundColor: context.palette.danger,
                    ),
                    child: Text(l10n.delete),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
