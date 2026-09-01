import 'package:equatable/equatable.dart';
import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
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
class CvBuilderState extends Equatable {
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
    this.templateId = CvTemplateId.modernClean,
    this.targetRole = '',
    this.sectionOrder = const [
      'experience',
      'education',
      'skills',
      'certifications',
    ],
    this.deactivatedSections = const {},
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
    templateId: CvTemplateId.modernClean,
    targetRole: '',
    sectionOrder: ['experience', 'education', 'skills', 'certifications'],
    deactivatedSections: {},
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

  /// Which of the 4 ATS-safe designs the live preview and the final
  /// export render with — chosen on `CvTemplatePickerPage`, changeable
  /// later from the preview's "Change Template" action.
  final CvTemplateId templateId;

  /// The job/role the user said they're targeting, captured on
  /// `CvTargetRolePage` before the wizard starts. Shown back on the
  /// Hub as context; not otherwise used yet (there's no AI tailoring
  /// in this app), but captured up front rather than lost.
  final String targetRole;

  /// The order Experience/Education/Skills/Certifications and every
  /// custom section actually render in on the CV — user-controlled by
  /// dragging rows on the Hub (see `CvBuilderSectionOrderChanged`).
  /// Personal Info and Summary are never part of this: they always
  /// render in their fixed spot regardless of where the Hub shows
  /// them. See `orderedRenderableSectionKeys`.
  final List<String> sectionOrder;

  /// Optional-category sections (Certifications, or a custom section)
  /// the user turned off — hidden from the CV without losing the data
  /// underneath, so turning one back on restores it exactly as it was.
  final Set<String> deactivatedSections;

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

  @override
  List<Object?> get props => [
    currentStep,
    personalInfo,
    experiences,
    isFreshGraduate,
    educations,
    skills,
    certifications,
    summary,
    customSections,
    templateId,
    targetRole,
    sectionOrder,
    deactivatedSections,
  ];

  Map<String, dynamic> toJson() => {
    'currentStep': currentStep,
    'personalInfo': personalInfo.toJson(),
    'experiences': experiences.map((e) => e.toJson()).toList(),
    'isFreshGraduate': isFreshGraduate,
    'educations': educations.map((e) => e.toJson()).toList(),
    'skills': skills.toJson(),
    'certifications': certifications.map((c) => c.toJson()).toList(),
    'summary': summary,
    'customSections': customSections.map((s) => s.toJson()).toList(),
    'templateId': templateId.name,
    'targetRole': targetRole,
    'sectionOrder': sectionOrder,
    'deactivatedSections': deactivatedSections.toList(),
  };

  factory CvBuilderState.fromJson(Map<String, dynamic> json) {
    return CvBuilderState(
      currentStep: json['currentStep'] as int? ?? 0,
      personalInfo: json['personalInfo'] == null
          ? const PersonalInfo()
          : PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>),
      experiences: ((json['experiences'] as List?) ?? const [])
          .map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFreshGraduate: json['isFreshGraduate'] as bool? ?? false,
      educations: ((json['educations'] as List?) ?? const [])
          .map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: json['skills'] == null
          ? const SkillsSelection()
          : SkillsSelection.fromJson(json['skills'] as Map<String, dynamic>),
      certifications: ((json['certifications'] as List?) ?? const [])
          .map((c) => Certification.fromJson(c as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String? ?? '',
      customSections: ((json['customSections'] as List?) ?? const [])
          .map((s) => CustomSection.fromJson(s as Map<String, dynamic>))
          .toList(),
      templateId: CvTemplateId.values.firstWhere(
        (t) => t.name == json['templateId'],
        orElse: () => CvTemplateId.modernClean,
      ),
      targetRole: json['targetRole'] as String? ?? '',
      sectionOrder: _sectionOrderFromJson(json['sectionOrder'] as List?),
      deactivatedSections: ((json['deactivatedSections'] as List?) ?? const [])
          .map((e) => e as String)
          .toSet(),
    );
  }

  static List<String> _sectionOrderFromJson(List? raw) {
    final order = (raw ?? const []).map((e) => e as String).toList();
    return order.isEmpty
        ? const ['experience', 'education', 'skills', 'certifications']
        : order;
  }

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
    CvTemplateId? templateId,
    String? targetRole,
    List<String>? sectionOrder,
    Set<String>? deactivatedSections,
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
      templateId: templateId ?? this.templateId,
      targetRole: targetRole ?? this.targetRole,
      sectionOrder: sectionOrder ?? this.sectionOrder,
      deactivatedSections: deactivatedSections ?? this.deactivatedSections,
    );
  }
}
