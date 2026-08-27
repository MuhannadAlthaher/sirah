import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/certification_entry_page.dart';
import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/widgets/certification_summary_card.dart';
import 'package:sira/cv_builder/widgets/step_bottom_bar.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/widgets/secondary_outline_button.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Certifications & Courses: zero or more entries, each edited on its
/// own screen — same shape as `ExperienceStep`/`EducationStep`, fully
/// optional (Continue always works with zero entries).
class CertificationsStep extends StatelessWidget {
  const CertificationsStep({super.key});

  void _addOrEdit(BuildContext context, {Certification? existing}) {
    final bloc = context.read<CvBuilderBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CertificationEntryPage(
          initial: existing,
          onSave: (certification) => bloc.add(
            existing == null
                ? CvBuilderCertificationAdded(certification)
                : CvBuilderCertificationUpdated(certification),
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
                          l10n.cvStepCertificationsSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: context.palette.textSecondary),
                        ),
                        SizedBox(height: padding),
                        for (final certification in state.certifications) ...[
                          CertificationSummaryCard(
                            certification: certification,
                            onEdit: () =>
                                _addOrEdit(context, existing: certification),
                            onDelete: () => bloc.add(
                              CvBuilderCertificationDeleted(certification.id),
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
                          child: Text('+ ${l10n.cvAddAnotherCertification}'),
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
