import 'package:sira/l10n/app_localizations.dart';

/// One entry in the CV Builder's Certifications & Courses step. A
/// single optional completion date, not a range — a course or
/// certificate is finished on one date, unlike a job or degree.
class Certification {
  const Certification({
    required this.id,
    this.name = '',
    this.issuer = '',
    this.month,
    this.year,
  });

  factory Certification.blank() =>
      Certification(id: DateTime.now().microsecondsSinceEpoch.toString());

  final String id;
  final String name;
  final String issuer;
  final int? month;
  final int? year;

  bool get isComplete => name.trim().isNotEmpty && issuer.trim().isNotEmpty;

  String dateLabel(AppLocalizations l10n) =>
      month == null || year == null ? '' : l10n.formatMonthYear(month!, year!);

  Certification copyWith({
    String? name,
    String? issuer,
    int? month,
    int? year,
  }) {
    return Certification(
      id: id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
