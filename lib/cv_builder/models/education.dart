import 'package:sira/l10n/app_localizations.dart';

/// One entry in the CV Builder's Education step. Mirrors
/// [WorkExperience]'s shape (month/year start/end, an "is current"
/// flag) since it's edited the same way.
class Education {
  const Education({
    required this.id,
    this.institution = '',
    this.degree = '',
    this.fieldOfStudy = '',
    this.startMonth,
    this.startYear,
    this.endMonth,
    this.endYear,
    this.isCurrent = false,
    this.description = '',
  });

  factory Education.blank() =>
      Education(id: DateTime.now().microsecondsSinceEpoch.toString());

  final String id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final int? startMonth;
  final int? startYear;
  final int? endMonth;
  final int? endYear;
  final bool isCurrent;

  /// Rich-text description, same shape as
  /// [WorkExperience.description] (a JSON-encoded Quill delta).
  final String description;

  bool get isComplete =>
      institution.trim().isNotEmpty &&
      degree.trim().isNotEmpty &&
      startMonth != null &&
      startYear != null &&
      (isCurrent || (endMonth != null && endYear != null));

  String startLabel(AppLocalizations l10n) =>
      startMonth == null || startYear == null
      ? ''
      : l10n.formatMonthYear(startMonth!, startYear!);

  String endLabel(AppLocalizations l10n) {
    if (isCurrent) return l10n.cvPresent;
    if (endMonth == null || endYear == null) return '';
    return l10n.formatMonthYear(endMonth!, endYear!);
  }

  Education copyWith({
    String? institution,
    String? degree,
    String? fieldOfStudy,
    int? startMonth,
    int? startYear,
    int? endMonth,
    int? endYear,
    bool? isCurrent,
    String? description,
  }) {
    return Education(
      id: id,
      institution: institution ?? this.institution,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      endMonth: endMonth ?? this.endMonth,
      endYear: endYear ?? this.endYear,
      isCurrent: isCurrent ?? this.isCurrent,
      description: description ?? this.description,
    );
  }

  Education withCurrentToggled(bool value) {
    return Education(
      id: id,
      institution: institution,
      degree: degree,
      fieldOfStudy: fieldOfStudy,
      startMonth: startMonth,
      startYear: startYear,
      endMonth: value ? null : endMonth,
      endYear: value ? null : endYear,
      isCurrent: value,
      description: description,
    );
  }
}
