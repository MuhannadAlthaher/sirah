import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/models/education.dart';
import 'package:sira/cv_builder/models/personal_info.dart';
import 'package:sira/cv_builder/models/skills_selection.dart';
import 'package:sira/cv_builder/models/work_experience.dart';
import 'package:sira/l10n/app_localizations.dart';

/// The CV Builder flow's current step and all data entered so far.
///
/// Deliberately centralized here (rather than left in each step
/// widget's own local state) so navigating backward and forward
/// through the [PageView] never loses anything the user has typed.
class CvBuilderState {
  const CvBuilderState({
    required this.currentStep,
    required this.personalInfo,
    required this.experiences,
    required this.isFreshGraduate,
    required this.educations,
    required this.skills,
    required this.certifications,
    required this.summary,
    this.customSections = const [],
  });

  factory CvBuilderState.initial() => const CvBuilderState(
    currentStep: 0,
    personalInfo: PersonalInfo(),
    experiences: [],
    isFreshGraduate: false,
    educations: [],
    skills: SkillsSelection(),
    certifications: [],
    summary: '',
    customSections: [],
  );

  /// Personal Info, Experience, Education, Skills, Certifications,
  /// Summary — the six sections the linear wizard walks through.
  /// There's no separate "Review" step; the Hub overview page (see
  /// `CvBuilderHubPage`) *is* the review.
  static const stepCount = 6;

  final int currentStep;
  final PersonalInfo personalInfo;
  final List<WorkExperience> experiences;
  final bool isFreshGraduate;
  final List<Education> educations;
  final SkillsSelection skills;
  final List<Certification> certifications;
  final String summary;

  /// Sections the user built themselves (see `CustomSectionCreatePage`)
  /// — always optional, never counted in [essentialSectionsComplete].
  final List<CustomSection> customSections;

  bool get isLastStep => currentStep == stepCount - 1;

  /// Whether Experience counts as "done" for the Hub checklist — an
  /// explicit fresh-graduate opt-out counts, since the user made a
  /// real decision, not just skipped past it.
  bool get isExperienceComplete => experiences.isNotEmpty || isFreshGraduate;

  bool get isEducationComplete => educations.isNotEmpty;

  bool get isSkillsComplete => skills.selected.isNotEmpty;

  bool get isSummaryComplete => summary.trim().isNotEmpty;

  bool get isCertificationsComplete => certifications.isNotEmpty;

  /// The essential sections (shown as "needed to export" on the Hub);
  /// Certifications is optional and doesn't count toward this.
  int get essentialSectionsComplete => [
    personalInfo.isComplete,
    isExperienceComplete,
    isEducationComplete,
    isSkillsComplete,
    isSummaryComplete,
  ].where((done) => done).length;

  static const essentialSectionCount = 5;

  bool get isReadyToFinish =>
      essentialSectionsComplete == essentialSectionCount;

  /// All six sections, essential and optional alike — for the Hub's
  /// "N of 6 sections filled" summary line.
  int get completedSectionsCount => [
    personalInfo.isComplete,
    isExperienceComplete,
    isEducationComplete,
    isSkillsComplete,
    isCertificationsComplete,
    isSummaryComplete,
  ].where((done) => done).length;

  static const totalSectionCount = 6;

  /// Display name for this draft on the dashboard — the user's full
  /// name once they've entered it, or a generic placeholder before
  /// that.
  String draftName(AppLocalizations l10n) {
    final fullName = '${personalInfo.firstName} ${personalInfo.lastName}'
        .trim();
    return fullName.isEmpty ? l10n.cvUntitled : fullName;
  }

  /// "Draft • N of 5 essentials done", for the dashboard's draft
  /// banner.
  String draftProgressLabel(AppLocalizations l10n) =>
      l10n.cvDraftProgress(essentialSectionsComplete, essentialSectionCount);

  CvBuilderState copyWith({
    int? currentStep,
    PersonalInfo? personalInfo,
    List<WorkExperience>? experiences,
    bool? isFreshGraduate,
    List<Education>? educations,
    SkillsSelection? skills,
    List<Certification>? certifications,
    String? summary,
    List<CustomSection>? customSections,
  }) {
    return CvBuilderState(
      currentStep: currentStep ?? this.currentStep,
      personalInfo: personalInfo ?? this.personalInfo,
      experiences: experiences ?? this.experiences,
      isFreshGraduate: isFreshGraduate ?? this.isFreshGraduate,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      summary: summary ?? this.summary,
      customSections: customSections ?? this.customSections,
    );
  }
}
