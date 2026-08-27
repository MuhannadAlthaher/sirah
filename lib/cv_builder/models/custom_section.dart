import 'package:sira/l10n/app_localizations.dart';

/// One entry inside a user-created [CustomSection]. Which fields are
/// actually shown/edited for it is driven entirely by that section's
/// [CustomSection.hasDescription]/[CustomSection.hasDateRange] flags
/// — this model just carries storage for all of them unconditionally,
/// same way [WorkExperience] always has a `location` even though it's
/// optional.
class CustomSectionEntry {
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
class CustomSection {
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
