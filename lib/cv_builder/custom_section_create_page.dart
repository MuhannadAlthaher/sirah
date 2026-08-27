import 'package:flutter/material.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/widgets/form_field_label.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Full-screen form for building a brand-new [CustomSection]: a
/// name, plus which optional fields each of its entries should have
/// (a description, a start/end date range). Pushed from the Hub;
/// pops with the finished [CustomSection] once created, or `null` if
/// cancelled.
///
/// The in-progress draft lives in a [ValueNotifier] created once in
/// the constructor — safe here because this page is only ever reached
/// via `Navigator.push`, so the constructor runs exactly once for
/// this route's lifetime (same pattern as `ExperienceEntryPage`).
class CustomSectionCreatePage extends StatelessWidget {
  CustomSectionCreatePage({super.key})
    : draft = ValueNotifier(CustomSection.blank()),
      attemptedCreate = ValueNotifier(false);

  final ValueNotifier<CustomSection> draft;
  final ValueNotifier<bool> attemptedCreate;

  void _create(BuildContext context) {
    attemptedCreate.value = true;
    if (draft.value.title.trim().isEmpty) return;
    Navigator.of(context).pop(draft.value);
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
        title: Text(l10n.cvCustomSectionCreateTitle),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.cvCustomSectionCreateSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.palette.textSecondary,
                        ),
                      ),
                      SizedBox(height: padding),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(padding),
                        decoration: BoxDecoration(
                          color: context.palette.surface,
                          border: Border.all(color: context.palette.border),
                          borderRadius: BorderRadius.circular(padding * 0.6),
                        ),
                        child: AnimatedBuilder(
                          animation: Listenable.merge([draft, attemptedCreate]),
                          builder: (context, _) {
                            final value = draft.value;
                            final titleMissing =
                                attemptedCreate.value &&
                                value.title.trim().isEmpty;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormFieldLabel(
                                  label: l10n.cvCustomSectionNameLabel,
                                ),
                                SizedBox(height: padding * 0.3),
                                TextFormField(
                                  initialValue: value.title,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    hintText: l10n.cvCustomSectionNameHint,
                                  ),
                                  onChanged: (v) =>
                                      draft.value = value.copyWith(title: v),
                                ),
                                if (titleMissing) ...[
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
                                _FieldToggleRow(
                                  title: l10n.cvCustomSectionIncludeDescription,
                                  value: value.hasDescription,
                                  onChanged: (checked) => draft.value = value
                                      .copyWith(hasDescription: checked),
                                ),
                                Divider(
                                  height: padding,
                                  color: context.palette.border,
                                ),
                                _FieldToggleRow(
                                  title: l10n.cvCustomSectionIncludeDateRange,
                                  value: value.hasDateRange,
                                  onChanged: (checked) => draft.value = value
                                      .copyWith(hasDateRange: checked),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: padding * 1.2),
                      PrimaryCtaButton(
                        label: l10n.cvCustomSectionCreateAction,
                        onPressed: () => _create(context),
                      ),
                    ],
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

class _FieldToggleRow extends StatelessWidget {
  const _FieldToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
