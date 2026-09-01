import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/preview/cv_preview_page.dart';
import 'package:sira/cv_builder/steps/certifications_step.dart';
import 'package:sira/cv_builder/steps/education_step.dart';
import 'package:sira/cv_builder/steps/experience_step.dart';
import 'package:sira/cv_builder/steps/personal_info_step.dart';
import 'package:sira/cv_builder/steps/skills_step.dart';
import 'package:sira/cv_builder/steps/summary_step.dart';
import 'package:sira/cv_builder/widgets/step_progress_header.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// The CV Builder's linear, mobile-first, per-section wizard
/// (Personal Info → Experience → Education → Skills → Certifications
/// & Courses → Summary). Summary is deliberately last: it's meant to
/// distill *everything* the user has entered — and for a fresh
/// graduate with no work experience, the only real material to draw
/// from is their education (their major). Asking for a summary before
/// any of that exists doesn't make sense, so it all comes first —
/// this ordering is also what eventually lets "Generate with AI" work
/// from real content instead of just a name.
///
/// Always reached from `CvBuilderHubPage` — never pushed directly
/// from the dashboard — starting on whichever section the user tapped
/// (via [initialState]'s `currentStep`). It owns its own
/// [CvBuilderBloc] instance (a fresh one every visit, so its
/// [PageController] always starts on the right page), and always pops
/// with the resulting [CvBuilderState] — plain, not wrapped in a
/// draft-vs-completed distinction, since crossing back into the Hub
/// never risks losing anything (every field already writes straight
/// to the bloc as it's typed) and "is this CV done" is the Hub's call
/// to make, not this screen's.
///
/// Swiping is disabled — only the header's back arrow and each step's
/// own buttons change pages — so each step's own validation can gate
/// moving forward. The header's close ("X") button, and reaching
/// Continue on the last step (Summary), both just pop back to the Hub
/// with the current state.
class CvBuilderPage extends StatelessWidget {
  const CvBuilderPage({super.key, required this.initialState});

  final CvBuilderState initialState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CvBuilderBloc(initial: initialState),
      child: const _CvBuilderView(),
    );
  }
}

class _CvBuilderView extends StatelessWidget {
  const _CvBuilderView();

  List<String> _titles(AppLocalizations l10n) => [
    l10n.cvStepPersonalInfoTitle,
    l10n.cvStepExperienceTitle,
    l10n.cvStepEducationTitle,
    l10n.cvStepSkillsTitle,
    l10n.cvStepCertificationsTitle,
    l10n.cvStepSummaryTitle,
  ];

  void _returnToHub(BuildContext context) {
    Navigator.of(context).pop(context.read<CvBuilderBloc>().state);
  }

  Future<void> _openPreview(BuildContext context) async {
    final bloc = context.read<CvBuilderBloc>();
    final result = await Navigator.of(context).push<CvPreviewResult>(
      MaterialPageRoute(
        builder: (_) =>
            CvPreviewPage(state: bloc.state, mode: CvPreviewMode.peek),
      ),
    );
    if (result != null && result.templateId != bloc.state.templateId) {
      bloc.add(CvBuilderTemplateChanged(result.templateId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CvBuilderBloc>();
    final l10n = context.l10n;
    final titles = _titles(l10n);

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Capped the same way every other screen caps its content
            // width — without it, the header (sized off its own raw
            // width) blows up into oversized icons and padding on
            // tablets/desktop/web.
            final width = constraints.maxWidth.clamp(0, 480).toDouble();

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    BlocSelector<CvBuilderBloc, CvBuilderState, int>(
                      selector: (state) => state.currentStep,
                      builder: (context, currentStep) => StepProgressHeader(
                        stepIndex: currentStep,
                        stepCount: CvBuilderState.stepCount,
                        title: titles[currentStep],
                        onClose: () => _returnToHub(context),
                        onBack: currentStep == 0
                            ? null
                            : () => bloc.add(
                                const CvBuilderPreviousStepRequested(),
                              ),
                        onPreview: () => _openPreview(context),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: bloc.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (index) =>
                            bloc.add(CvBuilderStepChanged(index)),
                        children: [
                          const PersonalInfoStep(),
                          const ExperienceStep(),
                          const EducationStep(),
                          const SkillsStep(),
                          const CertificationsStep(),
                          SummaryStep(onDone: () => _returnToHub(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
