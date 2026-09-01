import 'dart:convert';
import 'dart:typed_data';

import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/data/countries.dart';
import 'package:sira/cv_builder/models/cv_section_order.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';

/// A real Word-openable `.doc` for [state] in [templateId]'s design,
/// as UTF-8 bytes ready to hand `share_plus` via `XFile.fromData` —
/// no temp-file I/O, which also keeps this working on web (`dart:io`
/// isn't available there). A `.doc` saved as styled HTML is a real
/// document Word (and Google Docs/LibreOffice) opens directly with
/// editable, selectable text and real headings — not a screenshot.
Uint8List buildCvWordBytes({
  required AppLocalizations l10n,
  required CvBuilderState state,
  required CvTemplateId templateId,
  required bool includeWatermark,
}) {
  final html = _buildCvWordHtml(
    l10n: l10n,
    state: state,
    templateId: templateId,
    includeWatermark: includeWatermark,
  );
  return Uint8List.fromList(utf8.encode(html));
}

String _buildCvWordHtml({
  required AppLocalizations l10n,
  required CvBuilderState state,
  required CvTemplateId templateId,
  required bool includeWatermark,
}) {
  final style = _htmlStyleFor(templateId);
  final info = state.personalInfo;
  final name = '${info.firstName} ${info.lastName}'.trim().isEmpty
      ? l10n.cvPreviewYourName
      : '${info.firstName} ${info.lastName}'.trim();
  final role = state.experiences.isNotEmpty
      ? state.experiences.first.jobTitle.trim()
      : '';
  final location = [
    info.city,
    if (info.country.trim().isNotEmpty) countryDisplayName(info.country, l10n),
  ].where((s) => s.trim().isNotEmpty).join(', ');
  final contact = [
    info.email,
    info.phone,
    location,
  ].where((s) => s.trim().isNotEmpty).join(style.contactSeparator);

  final buffer = StringBuffer()
    ..writeln(
      '<html xmlns:o="urn:schemas-microsoft-com:office:office" '
      'xmlns:w="urn:schemas-microsoft-com:office:word" '
      'xmlns="http://www.w3.org/TR/REC-html40">',
    )
    ..writeln('<head><meta charset="utf-8"><title>${_esc(name)}</title>')
    ..writeln('<style>')
    ..writeln(
      'body { font-family: ${style.bodyFont}; color: #1a1a1a; '
      'font-size: 11pt; line-height: 1.5; margin: 0.6in; }',
    )
    ..writeln(
      '.name { font-family: ${style.headingFont}; font-size: 22pt; '
      'font-weight: bold; color: #1a1a1a; ${style.nameExtra} }',
    )
    ..writeln('.role { font-size: 12pt; color: #444444; margin-top: 4px; }')
    ..writeln('.contact { font-size: 10pt; color: #555555; margin-top: 8px; }')
    ..writeln(
      '.section-heading { font-family: ${style.headingFont}; '
      'font-size: 12pt; font-weight: bold; color: ${style.headingColor}; '
      'letter-spacing: 1px; margin-top: 20px; margin-bottom: 6px; '
      'border-bottom: 1px solid #cccccc; padding-bottom: 4px; '
      '${style.headingExtra} }',
    )
    ..writeln(
      '.entry-title { font-weight: bold; font-size: 11pt; '
      'margin-top: 10px; }',
    )
    ..writeln(
      '.entry-meta { font-size: 9.5pt; color: #666666; '
      'font-style: italic; }',
    )
    ..writeln('ul { margin: 4px 0 0 0; padding-left: 20px; }')
    ..writeln('li { margin-bottom: 2px; }')
    ..writeln(
      '.watermark { text-align: center; color: #cccccc; '
      'font-size: 22pt; font-weight: bold; letter-spacing: 3px; '
      'margin-bottom: 24px; }',
    )
    ..writeln('</style></head><body>');

  if (includeWatermark) {
    buffer.writeln(
      '<div class="watermark">${_esc(l10n.cvWatermarkText)}</div>',
    );
  }

  buffer
    ..writeln(
      '<div style="${style.headerAlign}"><div class="name">${_esc(name)}</div>',
    )
    ..writeln(role.isEmpty ? '' : '<div class="role">${_esc(role)}</div>')
    ..writeln(
      contact.isEmpty ? '' : '<div class="contact">${_esc(contact)}</div>',
    )
    ..writeln('</div>');

  if (state.isSummaryComplete) {
    buffer
      ..writeln(_heading(l10n.cvStepSummaryTitle))
      ..writeln('<div>${_esc(state.summary.trim())}</div>');
  }

  for (final key in orderedRenderableSectionKeys(state)) {
    _writeSection(buffer, key, state, l10n);
  }

  buffer.writeln('</body></html>');
  return buffer.toString();
}

void _writeSection(
  StringBuffer buffer,
  String key,
  CvBuilderState state,
  AppLocalizations l10n,
) {
  switch (key) {
    case CvSectionKeys.experience:
      buffer.writeln(_heading(l10n.cvStepExperienceTitle));
      for (final experience in state.experiences) {
        final dateRange =
            '${experience.startLabel(l10n)} - '
            '${experience.endLabel(l10n)}';
        final title = experience.location.trim().isEmpty
            ? '${experience.jobTitle} - ${experience.employer}'
            : '${experience.jobTitle} - ${experience.employer}, '
                  '${experience.location}';
        buffer
          ..writeln('<div class="entry-title">${_esc(title)}</div>')
          ..writeln('<div class="entry-meta">${_esc(dateRange)}</div>')
          ..writeln(_bulletList(experience.description));
      }

    case CvSectionKeys.education:
      buffer.writeln(_heading(l10n.cvStepEducationTitle));
      for (final education in state.educations) {
        final dateRange =
            '${education.startLabel(l10n)} - '
            '${education.endLabel(l10n)}';
        final degreeLine = education.fieldOfStudy.trim().isEmpty
            ? '${education.degree} - ${education.institution}'
            : '${education.degree} in ${education.fieldOfStudy} - '
                  '${education.institution}';
        buffer
          ..writeln('<div class="entry-title">${_esc(degreeLine)}</div>')
          ..writeln('<div class="entry-meta">${_esc(dateRange)}</div>');
      }

    case CvSectionKeys.skills:
      buffer
        ..writeln(_heading(l10n.cvStepSkillsTitle))
        ..writeln('<div>${_esc(state.skills.selected.join(', '))}</div>');

    case CvSectionKeys.certifications:
      buffer.writeln(_heading(l10n.cvStepCertificationsTitle));
      for (final certification in state.certifications) {
        buffer
          ..writeln(
            '<div class="entry-title">'
            '${_esc('${certification.name} - ${certification.issuer}')}'
            '</div>',
          )
          ..writeln(
            '<div class="entry-meta">'
            '${_esc(certification.dateLabel(l10n))}</div>',
          );
      }

    default:
      final custom = state.customSections.firstWhere((s) => s.id == key);
      buffer.writeln(_heading(custom.title));
      for (final entry in custom.entries) {
        final dateRange = custom.hasDateRange
            ? '${entry.startLabel(l10n)} - ${entry.endLabel(l10n)}'
            : '';
        buffer
          ..writeln('<div class="entry-title">${_esc(entry.title)}</div>')
          ..writeln(
            dateRange.isEmpty
                ? ''
                : '<div class="entry-meta">${_esc(dateRange)}</div>',
          )
          ..writeln(
            custom.hasDescription ? _bulletList(entry.description) : '',
          );
      }
  }
}

String _heading(String text) =>
    '<div class="section-heading">${_esc(text)}</div>';

String _bulletList(String deltaJson) {
  final lines = RichTextField.plainTextOf(deltaJson)
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  if (lines.isEmpty) return '';
  final items = lines.map((line) => '<li>${_esc(line)}</li>').join();
  return '<ul>$items</ul>';
}

String _esc(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

class _HtmlStyle {
  const _HtmlStyle({
    required this.bodyFont,
    required this.headingFont,
    required this.headingColor,
    required this.headingExtra,
    required this.nameExtra,
    required this.headerAlign,
    required this.contactSeparator,
  });

  final String bodyFont;
  final String headingFont;
  final String headingColor;
  final String headingExtra;
  final String nameExtra;
  final String headerAlign;
  final String contactSeparator;
}

_HtmlStyle _htmlStyleFor(CvTemplateId templateId) {
  const serif = "Georgia, 'Times New Roman', Times, serif";
  const sans = "Arial, Helvetica, sans-serif";
  const mono = "'Courier New', Courier, monospace";
  const accent = '#2e7d32';

  switch (templateId) {
    case CvTemplateId.minimalClassic:
      return const _HtmlStyle(
        bodyFont: serif,
        headingFont: serif,
        headingColor: '#1a1a1a',
        headingExtra: '',
        nameExtra: '',
        headerAlign: 'text-align:center;',
        contactSeparator: '  |  ',
      );
    case CvTemplateId.modernClean:
      return const _HtmlStyle(
        bodyFont: sans,
        headingFont: sans,
        headingColor: accent,
        headingExtra: 'text-transform: uppercase;',
        nameExtra: '',
        headerAlign: 'text-align:left;',
        contactSeparator: '  ·  ',
      );
    case CvTemplateId.compactTechnical:
      return const _HtmlStyle(
        bodyFont: sans,
        headingFont: mono,
        headingColor: '#1a1a1a',
        headingExtra: 'text-transform: uppercase;',
        nameExtra: 'font-family: $mono;',
        headerAlign: 'text-align:left;',
        contactSeparator: '  |  ',
      );
    case CvTemplateId.professionalExecutive:
      return const _HtmlStyle(
        bodyFont: sans,
        headingFont: sans,
        headingColor: '#1a1a1a',
        headingExtra: 'text-transform: uppercase; letter-spacing: 2px;',
        nameExtra: 'text-transform: uppercase; letter-spacing: 2px;',
        headerAlign: 'text-align:left;',
        contactSeparator: '  •  ',
      );
    case CvTemplateId.pureMinimal:
      return const _HtmlStyle(
        bodyFont: sans,
        headingFont: sans,
        headingColor: '#1a1a1a',
        headingExtra: 'text-transform: uppercase; border-bottom: none;',
        nameExtra: '',
        headerAlign: 'text-align:left;',
        contactSeparator: '  ·  ',
      );
    case CvTemplateId.corporateFormal:
      return const _HtmlStyle(
        bodyFont: serif,
        headingFont: serif,
        headingColor: '#1a1a1a',
        headingExtra: 'text-align:center; text-transform: uppercase;',
        nameExtra: 'text-transform: uppercase; letter-spacing: 3px;',
        headerAlign: 'text-align:center;',
        contactSeparator: '  |  ',
      );
  }
}
