import 'package:sira/cv_builder/bloc/cv_builder_state.dart';

/// The stable keys for the sections a user can drag to reorder and,
/// for the optional ones, deactivate — every built-in section except
/// Personal Info and Summary, which always render in their fixed
/// spot (the header, and immediately after it) regardless of where
/// they sit in the Hub's list. A [CustomSection] uses its own [id] as
/// its key instead.
class CvSectionKeys {
  CvSectionKeys._();

  static const experience = 'experience';
  static const education = 'education';
  static const skills = 'skills';
  static const certifications = 'certifications';

  static const builtIn = [experience, education, skills, certifications];
}

/// The order [state]'s reorderable sections (Experience/Education/
/// Skills/Certifications, plus every custom section) should actually
/// render in — [state.sectionOrder] filtered down to keys that both
/// have real content and aren't deactivated, with any known key
/// missing from the stored order (an older draft, say) appended at
/// the end rather than silently dropped.
///
/// Summary is deliberately not part of this — it always renders
/// first, right after the header, no matter where the Hub shows it.
List<String> orderedRenderableSectionKeys(CvBuilderState state) {
  final customIds = state.customSections.map((s) => s.id);
  final known = {...CvSectionKeys.builtIn, ...customIds};

  final ordered = [
    for (final key in state.sectionOrder)
      if (known.contains(key)) key,
    for (final key in known)
      if (!state.sectionOrder.contains(key)) key,
  ];

  return ordered.where((key) => _hasContent(state, key)).toList();
}

/// The same reorderable keys as [orderedRenderableSectionKeys], but
/// for the Hub's own list: every known key (Experience/Education/
/// Skills/Certifications, every custom section) regardless of
/// whether it has content yet or is deactivated — the Hub needs to
/// show an empty or deactivated section too, so the user can tap into
/// it to fill it in or turn it back on.
List<String> orderedSectionKeysForHub(CvBuilderState state) {
  final customIds = state.customSections.map((s) => s.id);
  final known = {...CvSectionKeys.builtIn, ...customIds};

  return [
    for (final key in state.sectionOrder)
      if (known.contains(key)) key,
    for (final key in known)
      if (!state.sectionOrder.contains(key)) key,
  ];
}

bool _hasContent(CvBuilderState state, String key) {
  if (state.deactivatedSections.contains(key)) return false;

  switch (key) {
    case CvSectionKeys.experience:
      return state.experiences.isNotEmpty;
    case CvSectionKeys.education:
      return state.educations.isNotEmpty;
    case CvSectionKeys.skills:
      return state.skills.selected.isNotEmpty;
    case CvSectionKeys.certifications:
      return state.certifications.isNotEmpty;
    default:
      for (final section in state.customSections) {
        if (section.id == key) return section.entries.isNotEmpty;
      }
      return false;
  }
}
