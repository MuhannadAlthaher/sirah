import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/widgets/step_bottom_bar.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/widgets/secondary_outline_button.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// The last section of the wizard: an optional, skippable professional
/// summary, with an AI action whose wording depends on whether the
/// field is empty yet.
///
/// The text field writes straight to [CvBuilderBloc] on every change
/// (same reasoning as [PersonalInfoStep]), so no local state is
/// needed here at all. Being the last section, both Skip and Continue
/// call [onDone] (return to the Hub) instead of the
/// `CvBuilderNextStepRequested` the other steps use.
class SummaryStep extends StatelessWidget {
  const SummaryStep({super.key, required this.onDone});

  final VoidCallback onDone;

  void _showAiComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.cvAiComingSoon)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<CvBuilderBloc>();
    final initial = bloc.state.summary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.05;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cvSummarySubtitle,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child:
                                BlocSelector<
                                  CvBuilderBloc,
                                  CvBuilderState,
                                  bool
                                >(
                                  selector: (state) =>
                                      state.summary.trim().isEmpty,
                                  builder: (context, isEmpty) => TextButton(
                                    onPressed: () => _showAiComingSoon(context),
                                    child: Text(
                                      isEmpty
                                          ? l10n.cvGenerateWithAi
                                          : l10n.cvImproveWithAi,
                                      style: TextStyle(
                                        color: context.palette.accent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                          SizedBox(height: padding * 0.3),
                          TextFormField(
                            initialValue: initial,
                            minLines: 6,
                            maxLines: 10,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: l10n.cvSummaryPlaceholder,
                            ),
                            onChanged: (v) =>
                                bloc.add(CvBuilderSummaryChanged(v)),
                          ),
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
                        onPressed: onDone,
                      ),
                    ),
                    SizedBox(width: padding * 0.6),
                    Expanded(
                      child: PrimaryCtaButton(
                        label: l10n.continueLabel,
                        onPressed: onDone,
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
  }
}
