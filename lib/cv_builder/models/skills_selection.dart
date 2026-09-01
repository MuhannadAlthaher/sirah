import 'package:equatable/equatable.dart';

/// The CV Builder's Skills step answers: which skills (predefined or
/// user-added) are selected, plus any custom skills the user has
/// added per category — [customSkills] keys are the stable, English,
/// internal category identifiers used throughout the Skills step
/// (not the localized display labels, so switching languages mid-
/// session never orphans a custom skill).
class SkillsSelection extends Equatable {
  const SkillsSelection({
    this.selected = const {},
    this.customSkills = const {},
  });

  final Set<String> selected;
  final Map<String, List<String>> customSkills;

  @override
  List<Object?> get props => [selected, customSkills];

  Map<String, dynamic> toJson() => {
    'selected': selected.toList(),
    'customSkills': customSkills,
  };

  factory SkillsSelection.fromJson(Map<String, dynamic> json) {
    return SkillsSelection(
      selected: ((json['selected'] as List?) ?? const [])
          .cast<String>()
          .toSet(),
      customSkills: ((json['customSkills'] as Map?) ?? const {}).map(
        (key, value) => MapEntry(key as String, (value as List).cast<String>()),
      ),
    );
  }

  SkillsSelection withToggled(String skill) {
    final next = Set<String>.of(selected);
    if (!next.remove(skill)) next.add(skill);
    return SkillsSelection(selected: next, customSkills: customSkills);
  }

  SkillsSelection withCustomAdded(String category, String skill) {
    final existing = customSkills[category] ?? const <String>[];
    if (existing.contains(skill)) {
      return SkillsSelection(
        selected: {...selected, skill},
        customSkills: customSkills,
      );
    }
    return SkillsSelection(
      selected: {...selected, skill},
      customSkills: {
        ...customSkills,
        category: [...existing, skill],
      },
    );
  }
}
