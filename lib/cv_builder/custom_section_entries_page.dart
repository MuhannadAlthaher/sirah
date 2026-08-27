import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/custom_section_entry_page.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/widgets/custom_section_entry_summary_card.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// Entries list for one of the user's own [CustomSection]s — the
/// generic equivalent of `ExperienceStep`/`EducationStep`, but for a
/// section whose shape (title only, or title + description, or
/// title + dates too) was chosen by the user at creation time
/// instead of being fixed in code.
///
/// Reads [CvBuilderBloc] from the Hub that pushed it (not its own
/// provider) since a custom section's entries live in the same
/// top-level [CvBuilderState] as everything else. "Delete section"
/// pops back to the Hub immediately, since there's nothing left here
/// to look at once it's gone.
class CustomSectionEntriesPage extends StatelessWidget {
  const CustomSectionEntriesPage({super.key, required this.sectionId});

  final String sectionId;

  void _addOrEdit(
    BuildContext context,
    CustomSection section, {
    CustomSectionEntry? existing,
  }) {
    final bloc = context.read<CvBuilderBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CustomSectionEntryPage(
          section: section,
          initial: existing,
          onSave: (entry) => bloc.add(
            existing == null
                ? CvBuilderCustomSectionEntryAdded(sectionId, entry)
                : CvBuilderCustomSectionEntryUpdated(sectionId, entry),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteSection(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cvCustomSectionDeleteConfirmTitle),
        content: Text(l10n.cvCustomSectionDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: dialogContext.palette.danger,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CvBuilderBloc>().add(
        CvBuilderCustomSectionDeleted(sectionId),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      body: SafeArea(
        child: BlocBuilder<CvBuilderBloc, CvBuilderState>(
          builder: (context, state) {
            // Deleting the section pops this page, but the pop
            // doesn't finish synchronously — this can still rebuild
            // once more with the section already gone from state
            // while that's in flight.
            final matches = state.customSections.where(
              (s) => s.id == sectionId,
            );
            if (matches.isEmpty) return const SizedBox.shrink();
            final section = matches.first;

            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth.clamp(0, 480).toDouble();
                final padding = width * 0.05;

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: width,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: context.palette.textSecondary,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  section.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _deleteSection(context),
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: context.palette.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final entry in section.entries) ...[
                                  CustomSectionEntrySummaryCard(
                                    entry: entry,
                                    showDateRange: section.hasDateRange,
                                    onEdit: () => _addOrEdit(
                                      context,
                                      section,
                                      existing: entry,
                                    ),
                                    onDelete: () =>
                                        context.read<CvBuilderBloc>().add(
                                          CvBuilderCustomSectionEntryDeleted(
                                            sectionId,
                                            entry.id,
                                          ),
                                        ),
                                  ),
                                  SizedBox(height: padding * 0.6),
                                ],
                                OutlinedButton(
                                  onPressed: () => _addOrEdit(context, section),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: context.palette.accent,
                                    side: BorderSide(
                                      color: context.palette.border,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: padding * 0.6,
                                    ),
                                    minimumSize: const Size.fromHeight(0),
                                    shape: const StadiumBorder(),
                                  ),
                                  child: Text(
                                    '+ ${l10n.cvCustomSectionAddEntry}',
                                  ),
                                ),
                                SizedBox(height: padding),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
