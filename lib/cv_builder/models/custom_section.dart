import 'package:equatable/equatable.dart';
import 'package:sira/l10n/app_localizations.dart';

/// One entry inside a user-created [CustomSection]. Which fields are
/// actually shown/edited for it is driven entirely by that section's
/// [CustomSection.hasDescription]/[CustomSection.hasDateRange] flags
/// — this model just carries storage for all of them unconditionally,
/// same way [WorkExperience] always has a `location` even though it's
/// optional.
class CustomSectionEntry extends Equatable {
  const CustomSectionEntry({
    required this.id,
    this.title = '',
    this.description = '',
    this.startMonth,
    this.startYear,
    this.endMonth,
    this.endYear,
    this.isCurrent = false,
  });

  factory CustomSectionEntry.blank() =>
      CustomSectionEntry(id: DateTime.now().microsecondsSinceEpoch.toString());

  final String id;
  final String title;

  /// Rich-text description, same shape as [WorkExperience.description]
  /// (a JSON-encoded Quill delta) — only meaningful when the owning
  /// section has `hasDescription`.
  final String description;
  final int? startMonth;
  final int? startYear;
  final int? endMonth;
  final int? endYear;
  final bool isCurrent;

  bool get isComplete => title.trim().isNotEmpty;

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
    title,
    description,
    startMonth,
    startYear,
    endMonth,
    endYear,
    isCurrent,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'startMonth': startMonth,
    'startYear': startYear,
    'endMonth': endMonth,
    'endYear': endYear,
    'isCurrent': isCurrent,
  };

  factory CustomSectionEntry.fromJson(Map<String, dynamic> json) {
    return CustomSectionEntry(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startMonth: json['startMonth'] as int?,
      startYear: json['startYear'] as int?,
      endMonth: json['endMonth'] as int?,
      endYear: json['endYear'] as int?,
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }

  CustomSectionEntry copyWith({
    String? title,
    String? description,
    int? startMonth,
    int? startYear,
    int? endMonth,
    int? endYear,
    bool? isCurrent,
  }) {
    return CustomSectionEntry(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      endMonth: endMonth ?? this.endMonth,
      endYear: endYear ?? this.endYear,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  CustomSectionEntry withCurrentToggled(bool value) {
    return CustomSectionEntry(
      id: id,
      title: title,
      description: description,
      startMonth: startMonth,
      startYear: startYear,
      endMonth: value ? null : endMonth,
      endYear: value ? null : endYear,
      isCurrent: value,
    );
  }
}

/// A section the user built themselves — a name plus a chosen shape
/// (does each entry have a description? a start/end date range?).
/// Always optional: it never counts toward the Hub's "essential"
/// percentage, only toward "sections that strengthen your CV".
class CustomSection extends Equatable {
  const CustomSection({
    required this.id,
    this.title = '',
    this.hasDescription = false,
    this.hasDateRange = false,
    this.entries = const [],
  });

  factory CustomSection.blank() =>
      CustomSection(id: DateTime.now().microsecondsSinceEpoch.toString());

  final String id;
  final String title;
  final bool hasDescription;
  final bool hasDateRange;
  final List<CustomSectionEntry> entries;

  bool get isComplete => entries.isNotEmpty;

  @override
  List<Object?> get props => [id, title, hasDescription, hasDateRange, entries];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'hasDescription': hasDescription,
    'hasDateRange': hasDateRange,
    'entries': entries.map((e) => e.toJson()).toList(),
  };

  factory CustomSection.fromJson(Map<String, dynamic> json) {
    return CustomSection(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      hasDescription: json['hasDescription'] as bool? ?? false,
      hasDateRange: json['hasDateRange'] as bool? ?? false,
      entries: ((json['entries'] as List?) ?? const [])
          .map((e) => CustomSectionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CustomSection copyWith({
    String? title,
    bool? hasDescription,
    bool? hasDateRange,
    List<CustomSectionEntry>? entries,
  }) {
    return CustomSection(
      id: id,
      title: title ?? this.title,
      hasDescription: hasDescription ?? this.hasDescription,
      hasDateRange: hasDateRange ?? this.hasDateRange,
      entries: entries ?? this.entries,
    );
  }
}
