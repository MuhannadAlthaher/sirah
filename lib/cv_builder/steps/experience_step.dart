import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/experience_entry_page.dart';
import 'package:sira/cv_builder/models/work_experience.dart';
import 'package:sira/cv_builder/widgets/experience_summary_card.dart';
import 'package:sira/cv_builder/widgets/step_bottom_bar.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/widgets/secondary_outline_button.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Step 3: zero or more work experience entries, plus an explicit
/// "fresh graduate" opt-out (marks the section complete on the Hub
/// even with no entries) and a Skip button (leaves it incomplete,
/// resumable later) — both are always available side by side.
///
/// Purely driven by [CvBuilderBloc] — [ExperienceEntryPage] is the
/// only place experience data is actually edited, reached by pushing
/// a route (with an `onSave` callback dispatching back to this
/// bloc), same pattern as the Profile feature's edit screens.
class ExperienceStep extends StatelessWidget {
  const ExperienceStep({super.key});

  void _addOrEdit(BuildContext context, {WorkExperience? existing}) {
    final bloc = context.read<CvBuilderBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExperienceEntryPage(
          initial: existing,
          onSave: (experience) => bloc.add(
            existing == null
                ? CvBuilderExperienceAdded(experience)
                : CvBuilderExperienceUpdated(experience),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<CvBuilderBloc>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;

        return BlocBuilder<CvBuilderBloc, CvBuilderState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cvStepExperienceSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: context.palette.textSecondary),
                        ),
                        SizedBox(height: padding),
                        if (!state.isFreshGraduate) ...[
                          for (final experience in state.experiences) ...[
                            ExperienceSummaryCard(
                              experience: experience,
                              onEdit: () =>
                                  _addOrEdit(context, existing: experience),
                              onDelete: () => bloc.add(
                                CvBuilderExperienceDeleted(experience.id),
                              ),
                            ),
                            SizedBox(height: padding * 0.6),
                          ],
                          OutlinedButton(
                            onPressed: () => _addOrEdit(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: context.palette.accent,
                              side: BorderSide(color: context.palette.border),
                              padding: EdgeInsets.symmetric(
                                vertical: padding * 0.6,
                              ),
                              minimumSize: const Size.fromHeight(0),
                              shape: const StadiumBorder(),
                            ),
                            child: Text('+ ${l10n.cvAddAnotherExperience}'),
                          ),
                          SizedBox(height: padding * 1.2),
                        ],
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(padding * 0.8),
                          decoration: BoxDecoration(
                            color: context.palette.surface,
                            border: Border.all(color: context.palette.border),
                            borderRadius: BorderRadius.circular(padding * 0.6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => bloc.add(
                                  CvBuilderFreshGraduateToggled(
                                    !state.isFreshGraduate,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(
                                  padding * 0.3,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: state.isFreshGraduate,
                                      onChanged: (checked) => bloc.add(
                                        CvBuilderFreshGraduateToggled(
                                          checked ?? false,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: padding * 0.28,
                                        ),
                                        child: Text(
                                          l10n.cvFreshGraduatePrompt,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (state.isFreshGraduate) ...[
                                SizedBox(height: padding * 0.4),
                                Text(
                                  l10n.cvFreshGraduateSupport,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: context.palette.textSecondary,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
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
