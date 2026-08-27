import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/widgets/skill_chip_group.dart';
import 'package:sira/cv_builder/widgets/step_bottom_bar.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/widgets/secondary_outline_button.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Skills: a handful of general-purpose categories with common
/// options the user can tap to add, plus a way to add their own —
/// suitable as a starting point for any profession, not just one
/// field. Certifications & Courses is its own separate step, not
/// folded in here.
///
/// A [StatefulWidget] only because the inline "Add a skill" field
/// needs a [GlobalKey] that stays the same instance across this
/// widget's whole lifetime (see `PersonalInfoStep` for the same
/// reasoning) — the field's own text isn't otherwise tracked as
/// state, it's just read from the key at Add-press time and reset.
class SkillsStep extends StatefulWidget {
  const SkillsStep({super.key});

  @override
  State<SkillsStep> createState() => _SkillsStepState();
}

class _SkillsStepState extends State<SkillsStep> {
  final _addFieldKey = GlobalKey<FormFieldState<String>>();

  // Stable, English, internal category keys — kept separate from the
  // localized labels shown in the UI (see `_labels`) so a category's
  // custom-added skills never get orphaned by a language switch.
  static const _categoryKeys = ['skills', 'tools', 'languages'];

  // dart format off
  static const _predefined = <String, List<String>>{
    'skills': [
      'Communication', 'Teamwork', 'Problem Solving', 'Leadership',
      'Time Management', 'Adaptability', 'Critical Thinking',
      'Project Management', 'Attention to Detail',
    ],
    'tools': [
      'Microsoft Office', 'Google Workspace', 'Excel', 'PowerPoint',
      'Slack', 'CRM Software',
    ],
    'languages': ['English', 'Arabic', 'French', 'Spanish', 'German'],
  };
  // dart format on

  Map<String, String> _labels(AppLocalizations l10n) => {
    'skills': l10n.cvSkillCategorySkills,
    'tools': l10n.cvSkillCategoryTools,
    'languages': l10n.cvSkillCategoryLanguages,
  };

  void _addSkill() {
    final value = (_addFieldKey.currentState?.value ?? '').trim();
    if (value.isEmpty) return;
    context.read<CvBuilderBloc>().add(
      CvBuilderCustomSkillAdded(category: _categoryKeys.first, skill: value),
    );
    _addFieldKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<CvBuilderBloc>();
    final labels = _labels(l10n);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;

        return BlocBuilder<CvBuilderBloc, CvBuilderState>(
          builder: (context, state) {
            final selected = state.skills.selected;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cvStepSkillsSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: context.palette.textSecondary),
                        ),
                        SizedBox(height: padding),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 0.6,
                            vertical: padding * 0.15,
                          ),
                          decoration: BoxDecoration(
                            color: context.palette.surface,
                            border: Border.all(color: context.palette.border),
                            borderRadius: BorderRadius.circular(padding * 2),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: _addFieldKey,
                                  initialValue: '',
                                  decoration: InputDecoration(
                                    hintText: l10n.cvAddSkillHint,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: padding * 0.5,
                                    ),
                                  ),
                                  onFieldSubmitted: (_) => _addSkill(),
                                ),
                              ),
                              TextButton(
                                onPressed: _addSkill,
                                style: TextButton.styleFrom(
                                  backgroundColor: context.palette.accentSoft,
                                  foregroundColor: context.palette.accent,
                                  shape: const StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: padding * 0.6,
                                    vertical: padding * 0.35,
                                  ),
                                ),
                                child: Text(l10n.cvAddSkill),
                              ),
                            ],
                          ),
                        ),
                        if (selected.isNotEmpty) ...[
                          SizedBox(height: padding * 1.2),
                          Text(
                            l10n.cvSkillsOnYourCv.toUpperCase(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: context.palette.textSecondary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          SizedBox(height: padding * 0.4),
                          Wrap(
                            spacing: padding * 0.3,
                            runSpacing: padding * 0.3,
                            children: [
                              for (final skill in selected)
                                InputChip(
                                  label: Text(skill),
                                  onDeleted: () =>
                                      bloc.add(CvBuilderSkillToggled(skill)),
                                  backgroundColor: context.palette.accent,
                                  deleteIconColor: context.palette.onAccent,
                                  shape: const StadiumBorder(),
                                  labelStyle: TextStyle(
                                    color: context.palette.onAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                        ],
                        SizedBox(height: padding * 1.2),
                        for (final category in _categoryKeys) ...[
                          SkillChipGroup(
                            label: labels[category]!,
                            options:
                                <String>[
                                      ..._predefined[category]!,
                                      ...?state.skills.customSkills[category],
                                    ]
                                    .where((skill) => !selected.contains(skill))
                                    .toList(),
                            onSelect: (skill) =>
                                bloc.add(CvBuilderSkillToggled(skill)),
                          ),
                          SizedBox(height: padding * 1.2),
                        ],
                      ],
                    ),
                  ),
                ),
                StepBottomBar(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryOutlineButton(
                            label: l10n.skip,
                            onPressed: () =>
                                bloc.add(const CvBuilderNextStepRequested()),
                          ),
                        ),
                        SizedBox(width: padding * 0.6),
                        Expanded(
                          child: PrimaryCtaButton(
                            label: l10n.continueLabel,
                            onPressed: () =>
                                bloc.add(const CvBuilderNextStepRequested()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
