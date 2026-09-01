import 'package:equatable/equatable.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/models/education.dart';
import 'package:sira/cv_builder/models/personal_info.dart';
import 'package:sira/cv_builder/models/work_experience.dart';

/// Events the CV Builder UI dispatches to [CvBuilderBloc].
sealed class CvBuilderEvent extends Equatable {
  const CvBuilderEvent();

  @override
  List<Object?> get props => [];
}

/// The linear per-section wizard (`CvBuilderPage`), pushed from the
/// Hub with its own separate [CvBuilderBloc] instance, popped back
/// with whatever it ended up at — the Hub's own bloc adopts that
/// wholesale rather than trying to replay individual field events.
class CvBuilderStateReplaced extends CvBuilderEvent {
  const CvBuilderStateReplaced(this.state);

  final CvBuilderState state;

  @override
  List<Object?> get props => [state];
}

/// The [PageView] settled on a new page, whether from a button or
/// (if ever re-enabled) a swipe.
class CvBuilderStepChanged extends CvBuilderEvent {
  const CvBuilderStepChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

/// A step's own "Continue"/"Skip" button asked to move forward.
class CvBuilderNextStepRequested extends CvBuilderEvent {
  const CvBuilderNextStepRequested();
}

/// The header's back arrow was tapped.
class CvBuilderPreviousStepRequested extends CvBuilderEvent {
  const CvBuilderPreviousStepRequested();
}

/// Any Step 1 field changed — dispatched continuously (on every
/// keystroke/selection, not deferred to a "Continue" press), so
/// [CvBuilderState.personalInfo] is always current and the "Continue"
/// button only needs to validate, not gather values.
class CvBuilderPersonalInfoChanged extends CvBuilderEvent {
  const CvBuilderPersonalInfoChanged(this.info);

  final PersonalInfo info;

  @override
  List<Object?> get props => [info];
}

/// The Step 2 summary text changed.
class CvBuilderSummaryChanged extends CvBuilderEvent {
  const CvBuilderSummaryChanged(this.summary);

  final String summary;

  @override
  List<Object?> get props => [summary];
}

/// The Step 3 "fresh graduate" toggle changed.
class CvBuilderFreshGraduateToggled extends CvBuilderEvent {
  const CvBuilderFreshGraduateToggled(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

/// A new experience entry was saved from [ExperienceEntryPage].
class CvBuilderExperienceAdded extends CvBuilderEvent {
  const CvBuilderExperienceAdded(this.experience);

  final WorkExperience experience;

  @override
  List<Object?> get props => [experience];
}

/// An existing experience entry was edited and saved.
class CvBuilderExperienceUpdated extends CvBuilderEvent {
  const CvBuilderExperienceUpdated(this.experience);

  final WorkExperience experience;

  @override
  List<Object?> get props => [experience];
}

/// An experience entry's Delete action was tapped.
class CvBuilderExperienceDeleted extends CvBuilderEvent {
  const CvBuilderExperienceDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// A new education entry was saved from `EducationEntryPage`.
class CvBuilderEducationAdded extends CvBuilderEvent {
  const CvBuilderEducationAdded(this.education);

  final Education education;

  @override
  List<Object?> get props => [education];
}

/// An existing education entry was edited and saved.
class CvBuilderEducationUpdated extends CvBuilderEvent {
  const CvBuilderEducationUpdated(this.education);

  final Education education;

  @override
  List<Object?> get props => [education];
}

/// An education entry's Delete action was tapped.
class CvBuilderEducationDeleted extends CvBuilderEvent {
  const CvBuilderEducationDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// A skill chip was tapped, toggling it selected/unselected.
class CvBuilderSkillToggled extends CvBuilderEvent {
  const CvBuilderSkillToggled(this.skill);

  final String skill;

  @override
  List<Object?> get props => [skill];
}

/// The user added their own skill to [category] via the "Add" chip.
/// Also selects it immediately — there'd be no point adding one just
/// to leave it unchecked.
class CvBuilderCustomSkillAdded extends CvBuilderEvent {
  const CvBuilderCustomSkillAdded({
    required this.category,
    required this.skill,
  });

  final String category;
  final String skill;

  @override
  List<Object?> get props => [category, skill];
}

/// A new certification/course entry was saved from
/// `CertificationEntryPage`.
class CvBuilderCertificationAdded extends CvBuilderEvent {
  const CvBuilderCertificationAdded(this.certification);

  final Certification certification;

  @override
  List<Object?> get props => [certification];
}

/// An existing certification entry was edited and saved.
class CvBuilderCertificationUpdated extends CvBuilderEvent {
  const CvBuilderCertificationUpdated(this.certification);

  final Certification certification;

  @override
  List<Object?> get props => [certification];
}

/// A certification entry's Delete action was tapped.
class CvBuilderCertificationDeleted extends CvBuilderEvent {
  const CvBuilderCertificationDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// The user finished the "Create a section" form — a new, empty
/// [CustomSection] joins the Hub's Optional list.
class CvBuilderCustomSectionAdded extends CvBuilderEvent {
  const CvBuilderCustomSectionAdded(this.section);

  final CustomSection section;

  @override
  List<Object?> get props => [section];
}

/// The user tapped "Delete section" — removes it and every entry in
/// it.
class CvBuilderCustomSectionDeleted extends CvBuilderEvent {
  const CvBuilderCustomSectionDeleted(this.sectionId);

  final String sectionId;

  @override
  List<Object?> get props => [sectionId];
}

/// A new entry was saved into one of the user's custom sections.
class CvBuilderCustomSectionEntryAdded extends CvBuilderEvent {
  const CvBuilderCustomSectionEntryAdded(this.sectionId, this.entry);

  final String sectionId;
  final CustomSectionEntry entry;

  @override
  List<Object?> get props => [sectionId, entry];
}

/// An existing custom-section entry was edited and saved.
class CvBuilderCustomSectionEntryUpdated extends CvBuilderEvent {
  const CvBuilderCustomSectionEntryUpdated(this.sectionId, this.entry);

  final String sectionId;
  final CustomSectionEntry entry;

  @override
  List<Object?> get props => [sectionId, entry];
}

/// A custom-section entry's Delete action was tapped.
class CvBuilderCustomSectionEntryDeleted extends CvBuilderEvent {
  const CvBuilderCustomSectionEntryDeleted(this.sectionId, this.entryId);

  final String sectionId;
  final String entryId;

  @override
  List<Object?> get props => [sectionId, entryId];
}

/// The user picked a different template — from the template picker or
/// from "Change Template" on the live preview.
class CvBuilderTemplateChanged extends CvBuilderEvent {
  const CvBuilderTemplateChanged(this.templateId);

  final CvTemplateId templateId;

  @override
  List<Object?> get props => [templateId];
}

/// The user dragged a section row (Experience/Education/Skills/
/// Certifications, or a custom section) to a new position on the
/// Hub — [order] is the complete new sequence of section keys. Only
/// these reorder the CV itself; Personal Info and Summary stay fixed
/// no matter where the Hub shows them.
class CvBuilderSectionOrderChanged extends CvBuilderEvent {
  const CvBuilderSectionOrderChanged(this.order);

  final List<String> order;

  @override
  List<Object?> get props => [order];
}

/// An optional section (Certifications, or a custom section) was
/// switched active/inactive from the Hub's overflow menu — inactive
/// means hidden from the CV without losing the data underneath.
class CvBuilderSectionActiveToggled extends CvBuilderEvent {
  const CvBuilderSectionActiveToggled(this.sectionKey);

  final String sectionKey;

  @override
  List<Object?> get props => [sectionKey];
}
