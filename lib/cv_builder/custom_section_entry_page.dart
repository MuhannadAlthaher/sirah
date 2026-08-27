import 'package:flutter/material.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/widgets/form_field_label.dart';
import 'package:sira/cv_builder/widgets/month_year_field.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// Full-screen add/edit form for one [CustomSectionEntry]. Which
/// fields appear is driven entirely by [section] — a title is always
/// shown, description and start/end date only when the section was
/// built to include them. Pushed from `CustomSectionEntriesPage`;
/// calls [onSave] with the completed entry when the user taps Save,
/// then pops.
///
/// Same [ValueNotifier]-in-constructor pattern as `ExperienceEntryPage`
/// — safe here for the same reason (only ever reached via
/// `Navigator.push`).
class CustomSectionEntryPage extends StatelessWidget {
  CustomSectionEntryPage({
    super.key,
    required this.section,
    CustomSectionEntry? initial,
    required this.onSave,
  }) : isNew = initial == null,
       draft = ValueNotifier(initial ?? CustomSectionEntry.blank()),
       attemptedSave = ValueNotifier(false);

  final CustomSection section;
  final bool isNew;
  final ValueNotifier<CustomSectionEntry> draft;
  final ValueNotifier<bool> attemptedSave;
  final ValueChanged<CustomSectionEntry> onSave;
  final _formKey = GlobalKey<FormState>();

  void _save(BuildContext context) {
    attemptedSave.value = true;
    final value = draft.value;
    final datesValid =
        !section.hasDateRange ||
        (value.startMonth != null &&
            value.startYear != null &&
            (value.isCurrent ||
                (value.endMonth != null && value.endYear != null)));

    if (_formKey.currentState!.validate() && datesValid) {
      onSave(value);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text(
          isNew
              ? l10n.cvCustomSectionAddEntryTitle(section.title)
              : l10n.cvCustomSectionEditEntryTitle(section.title),
        ),
        actions: [
          TextButton(onPressed: () => _save(context), child: Text(l10n.save)),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0, 480).toDouble();
            final padding = width * 0.05;
            final gap = padding * 0.9;

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: context.palette.surface,
                      border: Border.all(color: context.palette.border),
                      borderRadius: BorderRadius.circular(padding * 0.6),
                    ),
                    child: Form(
                      key: _formKey,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([draft, attemptedSave]),
                        builder: (context, _) {
                          final value = draft.value;
                          final attempted = attemptedSave.value;
                          final startMissing =
                              attempted &&
                              section.hasDateRange &&
                              value.startMonth == null;
                          final endMissing =
                              attempted &&
                              section.hasDateRange &&
                              !value.isCurrent &&
                              value.endMonth == null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormFieldLabel(
                                label: l10n.cvCustomSectionEntryTitleLabel,
                              ),
                              SizedBox(height: padding * 0.3),
                              TextFormField(
                                initialValue: value.title,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? l10n.fieldRequired
                                    : null,
                                onChanged: (v) =>
                                    draft.value = value.copyWith(title: v),
                              ),
                              if (section.hasDateRange) ...[
                                SizedBox(height: gap),
                                FormFieldLabel(label: l10n.cvStartDate),
                                SizedBox(height: padding * 0.3),
                                MonthYearField(
                                  label: l10n.cvStartDate,
                                  month: value.startMonth,
                                  year: value.startYear,
                                  onSelected: (picked) =>
                                      draft.value = value.copyWith(
                                        startMonth: picked.$1,
                                        startYear: picked.$2,
                                      ),
                                ),
                                if (startMissing) ...[
                                  SizedBox(height: padding * 0.2),
                                  Text(
                                    l10n.fieldRequired,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.palette.danger,
                                        ),
                                  ),
                                ],
                                SizedBox(height: gap),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: value.isCurrent,
                                      onChanged: (checked) => draft.value =
                                          value.withCurrentToggled(
                                            checked ?? false,
                                          ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        l10n.cvCurrentlyOngoing,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: gap * 0.4),
                                FormFieldLabel(label: l10n.cvEndDate),
                                SizedBox(height: padding * 0.3),
                                MonthYearField(
                                  label: l10n.cvEndDate,
                                  month: value.endMonth,
                                  year: value.endYear,
                                  enabled: !value.isCurrent,
                                  placeholder: value.isCurrent
                                      ? l10n.cvPresent
                                      : null,
                                  onSelected: (picked) =>
                                      draft.value = value.copyWith(
                                        endMonth: picked.$1,
                                        endYear: picked.$2,
                                      ),
                                ),
                                if (endMissing) ...[
                                  SizedBox(height: padding * 0.2),
                                  Text(
                                    l10n.fieldRequired,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.palette.danger,
                                        ),
                                  ),
                                ],
                              ],
                              if (section.hasDescription) ...[
                                SizedBox(height: gap),
                                FormFieldLabel(
                                  label: l10n.cvDescription,
                                  isOptional: true,
                                ),
                                SizedBox(height: padding * 0.3),
                                RichTextField(
                                  initialDeltaJson: value.description,
                                  placeholder: l10n.cvDescriptionPlaceholder,
                                  onChanged: (next) => draft.value = value
                                      .copyWith(description: next),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
