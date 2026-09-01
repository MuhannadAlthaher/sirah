import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/data/countries.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';

/// Formats a [CvBuilderState] as plain text — used for the share
/// sheet, where a native share target (email, messaging apps) needs
/// text rather than a rendered widget tree.
String cvPlainText(AppLocalizations l10n, CvBuilderState state) {
  final buffer = StringBuffer();
  final info = state.personalInfo;
  final name = '${info.firstName} ${info.lastName}'.trim();

  buffer.writeln(name.isEmpty ? l10n.cvPreviewYourName : name);

  final location = [
    info.city,
    if (info.country.trim().isNotEmpty) countryDisplayName(info.country, l10n),
  ].where((s) => s.trim().isNotEmpty).join(', ');
  final contact = [
    info.email,
    info.phone,
    location,
  ].where((s) => s.trim().isNotEmpty).join(' | ');
  if (contact.isNotEmpty) buffer.writeln(contact);

  if (state.isSummaryComplete) {
    buffer
      ..writeln()
      ..writeln(l10n.cvStepSummaryTitle.toUpperCase())
      ..writeln(state.summary.trim());
  }

  if (state.experiences.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln(l10n.cvStepExperienceTitle.toUpperCase());
    for (final experience in state.experiences) {
      buffer.writeln(
        '${experience.jobTitle} — ${experience.employer} '
        '(${experience.startLabel(l10n)} – ${experience.endLabel(l10n)})',
      );
      final description = RichTextField.plainTextOf(experience.description);
      for (final line in description.split('\n')) {
        if (line.trim().isNotEmpty) buffer.writeln('- ${line.trim()}');
      }
    }
  }

  if (state.educations.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln(l10n.cvStepEducationTitle.toUpperCase());
    for (final education in state.educations) {
      buffer.writeln(
        '${education.degree} — ${education.institution} '
        '(${education.startLabel(l10n)} – ${education.endLabel(l10n)})',
      );
    }
  }

  if (state.skills.selected.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln(l10n.cvStepSkillsTitle.toUpperCase())
      ..writeln(state.skills.selected.join(', '));
  }

  if (state.certifications.isNotEmpty) {
    buffer
      ..writeln()
      ..writeln(l10n.cvStepCertificationsTitle.toUpperCase());
    for (final certification in state.certifications) {
      buffer.writeln('${certification.name} — ${certification.issuer}');
    }
  }

  for (final custom in state.customSections) {
    if (custom.entries.isEmpty) continue;
    buffer
      ..writeln()
      ..writeln(custom.title.toUpperCase());
    for (final entry in custom.entries) {
      buffer.writeln(entry.title);
    }
  }

  return buffer.toString().trim();
}
