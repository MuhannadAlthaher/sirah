import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/education_entry_page.dart';
import 'package:sira/cv_builder/models/education.dart';
import 'package:sira/cv_builder/widgets/education_summary_card.dart';
import 'package:sira/cv_builder/widgets/step_bottom_bar.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/widgets/secondary_outline_button.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Education: zero or more entries, each edited on its own screen —
/// same shape as `ExperienceStep`, minus the fresh-graduate opt-out
/// (there's no equivalent "I have no education" escape hatch here;
/// Continue always works with zero entries regardless).
class EducationStep extends StatelessWidget {
  const EducationStep({super.key});

  void _addOrEdit(BuildContext context, {Education? existing}) {
    final bloc = context.read<CvBuilderBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EducationEntryPage(
          initial: existing,
          onSave: (education) => bloc.add(
            existing == null
                ? CvBuilderEducationAdded(education)
                : CvBuilderEducationUpdated(education),
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
                          l10n.cvStepEducationSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: context.palette.textSecondary),
                        ),
                        SizedBox(height: padding),
                        for (final education in state.educations) ...[
                          EducationSummaryCard(
                            education: education,
                            onEdit: () =>
                                _addOrEdit(context, existing: education),
                            onDelete: () => bloc.add(
                              CvBuilderEducationDeleted(education.id),
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
                          child: Text('+ ${l10n.cvAddAnotherEducation}'),
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
