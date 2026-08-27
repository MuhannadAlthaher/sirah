import 'package:flutter/material.dart';
import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/widgets/initials_badge.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A completed [Certification] entry shown as a clean summary card on
/// the Certifications & Courses step, with Edit/Delete actions.
///
/// Every size is a fraction of the card's own available width, so it
/// scales with the screen instead of relying on fixed pixel values.
class CertificationSummaryCard extends StatelessWidget {
  const CertificationSummaryCard({
    super.key,
    required this.certification,
    required this.onEdit,
    required this.onDelete,
  });

  final Certification certification;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;
        final l10n = context.l10n;
        final dateLabel = certification.dateLabel(l10n);

        final subtitle = dateLabel.isEmpty
            ? certification.issuer
            : '${certification.issuer} · $dateLabel';

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
                  InitialsBadge(text: certification.issuer, size: width * 0.13),
                  SizedBox(width: padding * 0.7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          certification.name,
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
              SizedBox(height: padding * 0.6),
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
