import 'package:flutter/material.dart';
import 'package:sira/cv_builder/models/work_experience.dart';
import 'package:sira/cv_builder/widgets/form_field_label.dart';
import 'package:sira/cv_builder/widgets/month_year_field.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// Full-screen add/edit form for one [WorkExperience], pushed from
/// [ExperienceStep]. Calls [onSave] with the completed entry when the
/// user taps Save (after validation), then pops.
///
/// The in-progress entry lives in a [ValueNotifier] created once in
/// the constructor — safe here because this page is only ever reached
/// via `Navigator.push(MaterialPageRoute(builder: (_) => ...))`, and a
/// route's builder runs exactly once for that route's lifetime (see
/// `EditDateOfBirthPage` in the Profile feature for the same pattern).
class ExperienceEntryPage extends StatelessWidget {
  ExperienceEntryPage({
    super.key,
    WorkExperience? initial,
    required this.onSave,
  }) : isNew = initial == null,
       draft = ValueNotifier(initial ?? WorkExperience.blank()),
       attemptedSave = ValueNotifier(false);

  final bool isNew;
  final ValueNotifier<WorkExperience> draft;
  final ValueNotifier<bool> attemptedSave;
  final ValueChanged<WorkExperience> onSave;
  final _formKey = GlobalKey<FormState>();

  void _showAiComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.cvAiComingSoon)));
  }

  void _save(BuildContext context) {
    attemptedSave.value = true;
    final value = draft.value;
    final datesValid =
        value.startMonth != null &&
        value.startYear != null &&
        (value.isCurrent || (value.endMonth != null && value.endYear != null));

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
          isNew ? l10n.cvAddExperienceTitle : l10n.cvEditExperienceTitle,
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
                              attempted && value.startMonth == null;
                          final endMissing =
                              attempted &&
                              !value.isCurrent &&
                              value.endMonth == null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormFieldLabel(label: l10n.cvEmployer),
                              SizedBox(height: padding * 0.3),
                              TextFormField(
                                initialValue: value.employer,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? l10n.fieldRequired
                                    : null,
                                onChanged: (v) => draft.value = draft.value
                                    .copyWith(employer: v),
                              ),
                              SizedBox(height: gap),
                              FormFieldLabel(label: l10n.cvJobTitle),
                              SizedBox(height: padding * 0.3),
                              TextFormField(
                                initialValue: value.jobTitle,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? l10n.fieldRequired
                                    : null,
                                onChanged: (v) => draft.value = draft.value
                                    .copyWith(jobTitle: v),
                              ),
                              SizedBox(height: gap),
                              FormFieldLabel(label: l10n.cvStartDate),
                              SizedBox(height: padding * 0.3),
                              MonthYearField(
                                label: l10n.cvStartDate,
                                month: value.startMonth,
                                year: value.startYear,
                                onSelected: (picked) =>
                                    draft.value = draft.value.copyWith(
                                      startMonth: picked.$1,
                                      startYear: picked.$2,
                                    ),
                              ),
                              if (startMissing) ...[
                                SizedBox(height: padding * 0.2),
                                Text(
                                  l10n.fieldRequired,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: context.palette.danger),
                                ),
                              ],
                              SizedBox(height: gap),
                              Row(
                                children: [
                                  Checkbox(
                                    value: value.isCurrent,
                                    onChanged: (checked) => draft.value = draft
                                        .value
                                        .withCurrentToggled(checked ?? false),
                                  ),
                                  Expanded(
                                    child: Text(
                                      l10n.cvCurrentlyWorkHere,
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
                                    draft.value = draft.value.copyWith(
                                      endMonth: picked.$1,
                                      endYear: picked.$2,
                                    ),
                              ),
                              if (endMissing) ...[
                                SizedBox(height: padding * 0.2),
                                Text(
                                  l10n.fieldRequired,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: context.palette.danger),
                                ),
                              ],
                              SizedBox(height: gap),
                              FormFieldLabel(
                                label: l10n.cvLocation,
                                isOptional: true,
                              ),
                              SizedBox(height: padding * 0.3),
                              TextFormField(
                                initialValue: value.location,
                                textCapitalization: TextCapitalization.words,
                                onChanged: (v) => draft.value = draft.value
                                    .copyWith(location: v),
                              ),
                              SizedBox(height: gap),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: padding * 0.2,
                                children: [
                                  FormFieldLabel(
                                    label: l10n.cvDescription,
                                    isOptional: true,
                                  ),
                                  TextButton(
                                    onPressed: () => _showAiComingSoon(context),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: padding * 0.3,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      l10n.cvImproveWithAi,
                                      style: TextStyle(
                                        color: context.palette.accent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: padding * 0.3),
                              RichTextField(
                                initialDeltaJson: value.description,
                                placeholder: l10n.cvDescriptionPlaceholder,
                                onChanged: (next) => draft.value = draft.value
                                    .copyWith(description: next),
                              ),
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
