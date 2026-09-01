import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sira/cv_builder/bloc/cv_builder_event.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';

/// Owns the CV Builder flow's step position and every answer entered
/// so far, plus the [PageController] that drives its [PageView] —
/// same shape as `OnboardingBloc`, which this is modeled on.
///
/// Scoped to one visit of [CvBuilderPage] (created fresh each time,
/// like `OnboardingBloc`) rather than kept alive app-wide. There's no
/// persistence layer in this app to resume a draft across app
/// restarts, but a draft saved via "Save & Exit" can still be resumed
/// within the same app session — the dashboard hands the whole
/// [CvBuilderState] it was given back in as [initial], and
/// [pageController] starts on that state's own `currentStep` so the
/// user lands back where they left off.
class CvBuilderBloc extends Bloc<CvBuilderEvent, CvBuilderState> {
  CvBuilderBloc({CvBuilderState? initial})
    : pageController = PageController(initialPage: initial?.currentStep ?? 0),
      super(initial ?? CvBuilderState.initial()) {
    on<CvBuilderStateReplaced>(_onStateReplaced);
    on<CvBuilderStepChanged>(_onStepChanged);
    on<CvBuilderNextStepRequested>(_onNextStepRequested);
    on<CvBuilderPreviousStepRequested>(_onPreviousStepRequested);
    on<CvBuilderPersonalInfoChanged>(_onPersonalInfoChanged);
    on<CvBuilderSummaryChanged>(_onSummaryChanged);
    on<CvBuilderFreshGraduateToggled>(_onFreshGraduateToggled);
    on<CvBuilderExperienceAdded>(_onExperienceAdded);
    on<CvBuilderExperienceUpdated>(_onExperienceUpdated);
    on<CvBuilderExperienceDeleted>(_onExperienceDeleted);
    on<CvBuilderEducationAdded>(_onEducationAdded);
    on<CvBuilderEducationUpdated>(_onEducationUpdated);
    on<CvBuilderEducationDeleted>(_onEducationDeleted);
    on<CvBuilderSkillToggled>(_onSkillToggled);
    on<CvBuilderCustomSkillAdded>(_onCustomSkillAdded);
    on<CvBuilderCertificationAdded>(_onCertificationAdded);
    on<CvBuilderCertificationUpdated>(_onCertificationUpdated);
    on<CvBuilderCertificationDeleted>(_onCertificationDeleted);
    on<CvBuilderCustomSectionAdded>(_onCustomSectionAdded);
    on<CvBuilderCustomSectionDeleted>(_onCustomSectionDeleted);
    on<CvBuilderCustomSectionEntryAdded>(_onCustomSectionEntryAdded);
    on<CvBuilderCustomSectionEntryUpdated>(_onCustomSectionEntryUpdated);
    on<CvBuilderCustomSectionEntryDeleted>(_onCustomSectionEntryDeleted);
    on<CvBuilderTemplateChanged>(_onTemplateChanged);
    on<CvBuilderSectionOrderChanged>(_onSectionOrderChanged);
    on<CvBuilderSectionActiveToggled>(_onSectionActiveToggled);
  }

  final PageController pageController;

  void _onStateReplaced(
    CvBuilderStateReplaced event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(event.state);
  }

  void _onStepChanged(
    CvBuilderStepChanged event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(currentStep: event.index));
  }

  void _onNextStepRequested(
    CvBuilderNextStepRequested event,
    Emitter<CvBuilderState> emit,
  ) {
    if (state.isLastStep) return;
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onPreviousStepRequested(
    CvBuilderPreviousStepRequested event,
    Emitter<CvBuilderState> emit,
  ) {
    if (state.currentStep == 0) return;
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onPersonalInfoChanged(
    CvBuilderPersonalInfoChanged event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(personalInfo: event.info));
  }

  void _onSummaryChanged(
    CvBuilderSummaryChanged event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(summary: event.summary));
  }

  void _onFreshGraduateToggled(
    CvBuilderFreshGraduateToggled event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(isFreshGraduate: event.value));
  }

  void _onExperienceAdded(
    CvBuilderExperienceAdded event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(experiences: [...state.experiences, event.experience]));
  }

  void _onExperienceUpdated(
    CvBuilderExperienceUpdated event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        experiences: [
          for (final experience in state.experiences)
            if (experience.id == event.experience.id)
              event.experience
            else
              experience,
        ],
      ),
    );
  }

  void _onExperienceDeleted(
    CvBuilderExperienceDeleted event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        experiences: [
          for (final experience in state.experiences)
            if (experience.id != event.id) experience,
        ],
      ),
    );
  }

  void _onEducationAdded(
    CvBuilderEducationAdded event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(educations: [...state.educations, event.education]));
  }

  void _onEducationUpdated(
    CvBuilderEducationUpdated event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        educations: [
          for (final education in state.educations)
            if (education.id == event.education.id)
              event.education
            else
              education,
        ],
      ),
    );
  }

  void _onEducationDeleted(
    CvBuilderEducationDeleted event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        educations: [
          for (final education in state.educations)
            if (education.id != event.id) education,
        ],
      ),
    );
  }

  void _onSkillToggled(
    CvBuilderSkillToggled event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(skills: state.skills.withToggled(event.skill)));
  }

  void _onCustomSkillAdded(
    CvBuilderCustomSkillAdded event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        skills: state.skills.withCustomAdded(event.category, event.skill),
      ),
    );
  }

  void _onCertificationAdded(
    CvBuilderCertificationAdded event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        certifications: [...state.certifications, event.certification],
      ),
    );
  }

  void _onCertificationUpdated(
    CvBuilderCertificationUpdated event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        certifications: [
          for (final certification in state.certifications)
            if (certification.id == event.certification.id)
              event.certification
            else
              certification,
        ],
      ),
    );
  }

  void _onCertificationDeleted(
    CvBuilderCertificationDeleted event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        certifications: [
          for (final certification in state.certifications)
            if (certification.id != event.id) certification,
        ],
      ),
    );
  }

  void _onCustomSectionAdded(
    CvBuilderCustomSectionAdded event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        customSections: [...state.customSections, event.section],
        // New sections join at the end of the render order — the
        // user can drag it wherever they like from there.
        sectionOrder: [...state.sectionOrder, event.section.id],
      ),
    );
  }

  void _onCustomSectionDeleted(
    CvBuilderCustomSectionDeleted event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        customSections: [
          for (final section in state.customSections)
            if (section.id != event.sectionId) section,
        ],
        sectionOrder: [
          for (final key in state.sectionOrder)
            if (key != event.sectionId) key,
        ],
        deactivatedSections: {
          for (final key in state.deactivatedSections)
            if (key != event.sectionId) key,
        },
      ),
    );
  }

  void _onCustomSectionEntryAdded(
    CvBuilderCustomSectionEntryAdded event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        customSections: [
          for (final section in state.customSections)
            if (section.id == event.sectionId)
              section.copyWith(entries: [...section.entries, event.entry])
            else
              section,
        ],
      ),
    );
  }

  void _onCustomSectionEntryUpdated(
    CvBuilderCustomSectionEntryUpdated event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        customSections: [
          for (final section in state.customSections)
            if (section.id == event.sectionId)
              section.copyWith(
                entries: [
                  for (final entry in section.entries)
                    if (entry.id == event.entry.id) event.entry else entry,
                ],
              )
            else
              section,
        ],
      ),
    );
  }

  void _onCustomSectionEntryDeleted(
    CvBuilderCustomSectionEntryDeleted event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(
      state.copyWith(
        customSections: [
          for (final section in state.customSections)
            if (section.id == event.sectionId)
              section.copyWith(
                entries: [
                  for (final entry in section.entries)
                    if (entry.id != event.entryId) entry,
                ],
              )
            else
              section,
        ],
      ),
    );
  }

  void _onTemplateChanged(
    CvBuilderTemplateChanged event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(templateId: event.templateId));
  }

  void _onSectionOrderChanged(
    CvBuilderSectionOrderChanged event,
    Emitter<CvBuilderState> emit,
  ) {
    emit(state.copyWith(sectionOrder: event.order));
  }

  void _onSectionActiveToggled(
    CvBuilderSectionActiveToggled event,
    Emitter<CvBuilderState> emit,
  ) {
    final next = Set<String>.of(state.deactivatedSections);
    if (!next.remove(event.sectionKey)) next.add(event.sectionKey);
    emit(state.copyWith(deactivatedSections: next));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
