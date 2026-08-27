import 'package:flutter/material.dart';
import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/widgets/form_field_label.dart';
import 'package:sira/cv_builder/widgets/month_year_field.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// Full-screen add/edit form for one [Certification] entry, pushed
/// from `CertificationsStep`. Calls [onSave] with the completed entry
/// when the user taps Save (after validation), then pops.
///
/// Same [ValueNotifier]-in-constructor pattern as
/// `ExperienceEntryPage` — safe here for the same reason (only ever
/// reached via `Navigator.push`).
class CertificationEntryPage extends StatelessWidget {
  CertificationEntryPage({
    super.key,
    Certification? initial,
    required this.onSave,
  }) : isNew = initial == null,
       draft = ValueNotifier(initial ?? Certification.blank());

  final bool isNew;
  final ValueNotifier<Certification> draft;
  final ValueChanged<Certification> onSave;
  final _formKey = GlobalKey<FormState>();

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      onSave(draft.value);
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
          isNew ? l10n.cvAddCertificationTitle : l10n.cvEditCertificationTitle,
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
                      child: ValueListenableBuilder<Certification>(
                        valueListenable: draft,
                        builder: (context, value, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormFieldLabel(label: l10n.cvCertificationName),
                              SizedBox(height: padding * 0.3),
                              TextFormField(
                                initialValue: value.name,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? l10n.fieldRequired
                                    : null,
                                onChanged: (v) =>
                                    draft.value = draft.value.copyWith(name: v),
                              ),
                              SizedBox(height: gap),
                              FormFieldLabel(label: l10n.cvCertificationIssuer),
                              SizedBox(height: padding * 0.3),
                              TextFormField(
                                initialValue: value.issuer,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? l10n.fieldRequired
                                    : null,
                                onChanged: (v) => draft.value = draft.value
                                    .copyWith(issuer: v),
                              ),
                              SizedBox(height: gap),
                              FormFieldLabel(
                                label: l10n.cvCertificationDate,
                                isOptional: true,
                              ),
                              SizedBox(height: padding * 0.3),
                              MonthYearField(
                                label: l10n.cvCertificationDate,
                                month: value.month,
                                year: value.year,
                                onSelected: (picked) =>
                                    draft.value = draft.value.copyWith(
                                      month: picked.$1,
                                      year: picked.$2,
                                    ),
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
