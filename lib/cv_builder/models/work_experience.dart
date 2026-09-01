import 'package:equatable/equatable.dart';
import 'package:sira/l10n/app_localizations.dart';

/// One entry in the CV Builder's Step 3 (Professional Experience)
/// list. Start/end are separate month/year ints rather than a
/// [DateTime] — the user only ever picks a month and a year, so
/// there's no real "day" to store or reason about.
class WorkExperience extends Equatable {
  const WorkExperience({
    required this.id,
    this.employer = '',
    this.jobTitle = '',
    this.startMonth,
    this.startYear,
    this.endMonth,
    this.endYear,
    this.isCurrent = false,
    this.location = '',
    this.description = '',
  });

  /// A new, empty entry — [id] only needs to be unique within this
  /// CV draft, so the current time is enough.
  factory WorkExperience.blank() =>
      WorkExperience(id: DateTime.now().microsecondsSinceEpoch.toString());

  final String id;
  final String employer;
  final String jobTitle;
  final int? startMonth;
  final int? startYear;
  final int? endMonth;
  final int? endYear;
  final bool isCurrent;
  final String location;

  /// Rich-text description, stored as a JSON-encoded Quill delta
  /// (see [RichTextField]) rather than plain text.
  final String description;

  bool get isComplete =>
      employer.trim().isNotEmpty &&
      jobTitle.trim().isNotEmpty &&
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

  @override
  List<Object?> get props => [
    id,
    employer,
    jobTitle,
    startMonth,
    startYear,
    endMonth,
    endYear,
    isCurrent,
    location,
    description,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'employer': employer,
    'jobTitle': jobTitle,
    'startMonth': startMonth,
    'startYear': startYear,
    'endMonth': endMonth,
    'endYear': endYear,
    'isCurrent': isCurrent,
    'location': location,
    'description': description,
  };

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as String,
      employer: json['employer'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      startMonth: json['startMonth'] as int?,
      startYear: json['startYear'] as int?,
      endMonth: json['endMonth'] as int?,
      endYear: json['endYear'] as int?,
      isCurrent: json['isCurrent'] as bool? ?? false,
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  WorkExperience copyWith({
    String? employer,
    String? jobTitle,
    int? startMonth,
    int? startYear,
    int? endMonth,
    int? endYear,
    bool? isCurrent,
    String? location,
    String? description,
  }) {
    return WorkExperience(
      id: id,
      employer: employer ?? this.employer,
      jobTitle: jobTitle ?? this.jobTitle,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      // endMonth/endYear are only ever nulled back out via
      // withCurrentToggled(true), not through here.
      endMonth: endMonth ?? this.endMonth,
      endYear: endYear ?? this.endYear,
      isCurrent: isCurrent ?? this.isCurrent,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }

  WorkExperience withCurrentToggled(bool value) {
    return WorkExperience(
      id: id,
      employer: employer,
      jobTitle: jobTitle,
      startMonth: startMonth,
      startYear: startYear,
      endMonth: value ? null : endMonth,
      endYear: value ? null : endYear,
      isCurrent: value,
      location: location,
      description: description,
    );
  }
}
