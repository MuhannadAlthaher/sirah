import 'package:flutter/material.dart';
import 'package:sira/cv_builder/widgets/form_field_label.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// What [CvTargetRolePage] pops with: the target role/job title the
/// user typed, and which language they want the CV (and the rest of
/// the builder flow) in.
class CvTargetRoleAnswer {
  const CvTargetRoleAnswer({required this.targetRole, required this.locale});

  final String targetRole;
  final Locale locale;
}

class _TargetRoleDraft {
  const _TargetRoleDraft({required this.targetRole, required this.locale});

  final String targetRole;
  final Locale locale;

  _TargetRoleDraft copyWith({String? targetRole, Locale? locale}) {
    return _TargetRoleDraft(
      targetRole: targetRole ?? this.targetRole,
      locale: locale ?? this.locale,
    );
  }
}

/// The very first screen of "Create New CV" — asks the target
/// role/job title and which language to build the CV in, before the
/// template picker or the wizard itself. Pops with a
/// [CvTargetRoleAnswer], or `null` if cancelled (which aborts opening
/// the builder at all — see `openCvBuilder`).
///
/// The in-progress draft lives in a [ValueNotifier] created once in
/// the constructor — safe here because this page is only ever reached
/// via `Navigator.push`, so the constructor runs exactly once for
/// this route's lifetime (same pattern as `CustomSectionCreatePage`).
class CvTargetRolePage extends StatelessWidget {
  CvTargetRolePage({super.key})
    : _draft = ValueNotifier(
        _TargetRoleDraft(targetRole: '', locale: const Locale('en')),
      ),
      _attemptedContinue = ValueNotifier(false);

  final ValueNotifier<_TargetRoleDraft> _draft;
  final ValueNotifier<bool> _attemptedContinue;

  void _continue(BuildContext context) {
    _attemptedContinue.value = true;
    if (_draft.value.targetRole.trim().isEmpty) return;
    Navigator.of(context).pop(
      CvTargetRoleAnswer(
        targetRole: _draft.value.targetRole.trim(),
        locale: _draft.value.locale,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    _draft.value = _draft.value.copyWith(locale: l10n.locale);

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text(l10n.cvTargetRolePageTitle),
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
                        l10n.cvTargetRolePageSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.palette.textSecondary,
                        ),
                      ),
                      SizedBox(height: padding * 1.4),
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _draft,
                          _attemptedContinue,
                        ]),
                        builder: (context, _) {
                          final value = _draft.value;
                          final roleMissing =
                              _attemptedContinue.value &&
                              value.targetRole.trim().isEmpty;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormFieldLabel(label: l10n.cvTargetRoleLabel),
                              SizedBox(height: padding * 0.3),
                              TextFormField(
                                initialValue: value.targetRole,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  hintText: l10n.cvTargetRoleHint,
                                ),
                                onChanged: (v) => _draft.value = value.copyWith(
                                  targetRole: v,
                                ),
                              ),
                              if (roleMissing) ...[
                                SizedBox(height: padding * 0.2),
                                Text(
                                  l10n.fieldRequired,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: context.palette.danger),
                                ),
                              ],
                              SizedBox(height: gap * 1.2),
                              FormFieldLabel(label: l10n.cvLanguageQuestion),
                              SizedBox(height: padding * 0.5),
                              Row(
                                children: [
                                  Expanded(
                                    child: _LanguageOption(
                                      label: l10n.cvLanguageEnglish,
                                      selected:
                                          value.locale.languageCode == 'en',
                                      onTap: () => _draft.value = value
                                          .copyWith(locale: const Locale('en')),
                                    ),
                                  ),
                                  SizedBox(width: padding * 0.5),
                                  Expanded(
                                    child: _LanguageOption(
                                      label: l10n.cvLanguageArabic,
                                      selected:
                                          value.locale.languageCode == 'ar',
                                      onTap: () => _draft.value = value
                                          .copyWith(locale: const Locale('ar')),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: padding * 1.4),
                      PrimaryCtaButton(
                        label: l10n.continueLabel,
                        onPressed: () => _continue(context),
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? palette.accentSoft : palette.surface,
          border: Border.all(
            color: selected ? palette.accent : palette.border,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? palette.accent : palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
