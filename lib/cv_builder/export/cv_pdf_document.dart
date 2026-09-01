import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/data/countries.dart';
import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/models/cv_section_order.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/models/education.dart';
import 'package:sira/cv_builder/models/work_experience.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';

/// Builds a real, selectable-text PDF of [state] in [templateId]'s
/// design — not a screenshot of the on-screen preview. ATS parsers
/// read the text layer of a PDF, so this mirrors `CvRenderer`'s
/// layout using `pdf` widgets and the standard 14 PDF fonts
/// (Helvetica/Times/Courier) directly, rather than rasterizing the
/// Flutter widget tree, which would bake the CV into a single opaque
/// image with no extractable text.
Future<Uint8List> buildCvPdfBytes({
  required AppLocalizations l10n,
  required CvBuilderState state,
  required CvTemplateId templateId,
  required bool includeWatermark,
}) async {
  final writer = _CvPdfWriter(l10n: l10n, state: state);
  final style = _styleFor(templateId);

  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.letter,
        margin: style.pagePadding,
        buildForeground: includeWatermark
            ? (context) => pw.Watermark.text(
                l10n.cvWatermarkText,
                angle: -0.4,
                style: pw.TextStyle(
                  color: PdfColors.grey300,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 34,
                ),
              )
            : null,
      ),
      build: (context) => writer.build(templateId, style),
    ),
  );

  return doc.save();
}

class _CvPdfWriter {
  _CvPdfWriter({required this.l10n, required this.state});

  final AppLocalizations l10n;
  final CvBuilderState state;

  List<pw.Widget> build(CvTemplateId templateId, _PdfStyle style) {
    return [
      _header(templateId, style),
      if (templateId == CvTemplateId.minimalClassic) ...[
        pw.SizedBox(height: style.sectionGap * 0.8),
        pw.Divider(color: PdfColors.grey400, thickness: 0.5),
      ],
      pw.SizedBox(height: style.sectionGap),
      ..._sections(style),
    ];
  }

  String _fullName() {
    final full =
        '${state.personalInfo.firstName} '
                '${state.personalInfo.lastName}'
            .trim();
    return full.isEmpty ? l10n.cvPreviewYourName : full;
  }

  String _contactLine(String separator) {
    final info = state.personalInfo;
    final location = [
      info.city,
      if (info.country.trim().isNotEmpty)
        countryDisplayName(info.country, l10n),
    ].where((s) => s.trim().isNotEmpty).join(', ');
    final parts = [
      info.email,
      info.phone,
      location,
    ].where((s) => s.trim().isNotEmpty).toList();
    return parts.join(separator);
  }

  String _roleTitle() => state.experiences.isNotEmpty
      ? state.experiences.first.jobTitle.trim()
      : '';

  pw.Widget _header(CvTemplateId templateId, _PdfStyle style) {
    final name = _fullName();
    final contact = _contactLine(style.contactSeparator);
    final role = _roleTitle();

    switch (templateId) {
      case CvTemplateId.minimalClassic:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              name,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                font: style.fontBold,
                fontSize: 22,
                color: style.textColor,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Container(width: 50, height: 1.5, color: style.accentColor),
            if (role.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              pw.Text(
                role,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: style.fontItalic,
                  fontSize: 11.5,
                  color: style.metaColor,
                ),
              ),
            ],
            if (contact.isNotEmpty) ...[
              pw.SizedBox(height: 6),
              pw.Text(
                contact,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: style.fontRegular,
                  fontSize: 9.5,
                  color: style.metaColor,
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.modernClean:
        return pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromInt(0xffe6f4ea),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                name,
                style: pw.TextStyle(
                  font: style.fontBold,
                  fontSize: 21,
                  color: style.textColor,
                ),
              ),
              if (role.isNotEmpty) ...[
                pw.SizedBox(height: 3),
                pw.Text(
                  role,
                  style: pw.TextStyle(
                    font: style.fontBold,
                    fontSize: 11.5,
                    color: style.accentColor,
                  ),
                ),
              ],
              if (contact.isNotEmpty) ...[
                pw.SizedBox(height: 7),
                pw.Text(
                  contact,
                  style: pw.TextStyle(
                    font: style.fontRegular,
                    fontSize: 9.5,
                    color: style.metaColor,
                  ),
                ),
              ],
            ],
          ),
        );

      case CvTemplateId.compactTechnical:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              name,
              style: pw.TextStyle(
                font: style.fontBold,
                fontSize: 16,
                color: style.textColor,
              ),
            ),
            if (role.isNotEmpty) ...[
              pw.SizedBox(height: 2),
              pw.Text(
                role,
                style: pw.TextStyle(
                  font: style.fontRegular,
                  fontSize: 9.5,
                  color: style.metaColor,
                ),
              ),
            ],
            if (contact.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                contact,
                style: pw.TextStyle(
                  font: style.fontRegular,
                  fontSize: 8.5,
                  color: style.metaColor,
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.professionalExecutive:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              name.toUpperCase(),
              style: pw.TextStyle(
                font: style.fontBold,
                fontSize: 27,
                letterSpacing: 1.5,
                color: style.textColor,
              ),
            ),
            if (role.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                role.toUpperCase(),
                style: pw.TextStyle(
                  font: style.fontBold,
                  fontSize: 10.5,
                  letterSpacing: 0.8,
                  color: style.metaColor,
                ),
              ),
            ],
            pw.SizedBox(height: 10),
            pw.Container(height: 3.5, color: style.accentColor),
            if (contact.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              pw.Text(
                contact,
                style: pw.TextStyle(
                  font: style.fontRegular,
                  fontSize: 9.5,
                  color: style.metaColor,
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.pureMinimal:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              name,
              style: pw.TextStyle(
                font: style.fontBold,
                fontSize: 18,
                color: style.textColor,
              ),
            ),
            if (role.isNotEmpty) ...[
              pw.SizedBox(height: 3),
              pw.Text(
                role,
                style: pw.TextStyle(
                  font: style.fontRegular,
                  fontSize: 10,
                  color: style.metaColor,
                ),
              ),
            ],
            if (contact.isNotEmpty) ...[
              pw.SizedBox(height: 7),
              pw.Text(
                contact,
                style: pw.TextStyle(
                  font: style.fontRegular,
                  fontSize: 9,
                  color: PdfColor.fromInt(0xff888888),
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.corporateFormal:
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              name.toUpperCase(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                font: style.fontBold,
                fontSize: 18,
                letterSpacing: 2.2,
                color: style.textColor,
              ),
            ),
            if (role.isNotEmpty) ...[
              pw.SizedBox(height: 5),
              pw.Text(
                role,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: style.fontItalic,
                  fontSize: 10,
                  color: style.metaColor,
                ),
              ),
            ],
            pw.SizedBox(height: 10),
            pw.Container(width: 48, height: 1.5, color: style.accentColor),
            pw.SizedBox(height: 10),
            if (contact.isNotEmpty) ...[
              pw.Divider(color: PdfColors.grey400, thickness: 0.5),
              pw.SizedBox(height: 6),
              pw.Text(
                contact,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: style.fontRegular,
                  fontSize: 9.5,
                  color: style.metaColor,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Divider(color: PdfColors.grey400, thickness: 0.5),
            ],
          ],
        );
    }
  }

  List<pw.Widget> _sections(_PdfStyle style) {
    final sections = <pw.Widget>[];

    if (state.isSummaryComplete) {
      sections.add(
        _section(
          style: style,
          heading: l10n.cvStepSummaryTitle,
          child: pw.Text(state.summary.trim(), style: style.bodyStyle),
        ),
      );
    }

    for (final key in orderedRenderableSectionKeys(state)) {
      sections.add(_sectionFor(key, style));
    }

    return [
      for (final section in sections) ...[
        section,
        pw.SizedBox(height: style.sectionGap),
      ],
    ];
  }

  pw.Widget _sectionFor(String key, _PdfStyle style) {
    switch (key) {
      case CvSectionKeys.experience:
        return _section(
          style: style,
          heading: l10n.cvStepExperienceTitle,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < state.experiences.length; i++) ...[
                _experienceEntry(style, state.experiences[i]),
                if (i != state.experiences.length - 1)
                  pw.SizedBox(height: style.entryGap),
              ],
            ],
          ),
        );

      case CvSectionKeys.education:
        return _section(
          style: style,
          heading: l10n.cvStepEducationTitle,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < state.educations.length; i++) ...[
                _educationEntry(style, state.educations[i]),
                if (i != state.educations.length - 1)
                  pw.SizedBox(height: style.entryGap),
              ],
            ],
          ),
        );

      case CvSectionKeys.skills:
        return _section(
          style: style,
          heading: l10n.cvStepSkillsTitle,
          child: style.skillsAsChips
              ? pw.Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (final skill in state.skills.selected)
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.grey400,
                            width: 0.5,
                          ),
                          borderRadius: pw.BorderRadius.circular(3),
                          color: PdfColors.grey100,
                        ),
                        child: pw.Text(
                          skill,
                          style: pw.TextStyle(
                            font: style.fontRegular,
                            fontSize: 8.5,
                            color: style.textColor,
                          ),
                        ),
                      ),
                  ],
                )
              : pw.Text(
                  state.skills.selected.join(', '),
                  style: style.bodyStyle,
                ),
        );

      case CvSectionKeys.certifications:
        return _section(
          style: style,
          heading: l10n.cvStepCertificationsTitle,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < state.certifications.length; i++) ...[
                _certificationEntry(style, state.certifications[i]),
                if (i != state.certifications.length - 1)
                  pw.SizedBox(height: style.entryGap * 0.6),
              ],
            ],
          ),
        );

      default:
        final custom = state.customSections.firstWhere((s) => s.id == key);
        return _section(
          style: style,
          heading: custom.title,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < custom.entries.length; i++) ...[
                _customEntry(style, custom, custom.entries[i]),
                if (i != custom.entries.length - 1)
                  pw.SizedBox(height: style.entryGap),
              ],
            ],
          ),
        );
    }
  }

  pw.Widget _section({
    required _PdfStyle style,
    required String heading,
    required pw.Widget child,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [_sectionHeading(heading, style), child],
    );
  }

  pw.Widget _sectionHeading(String text, _PdfStyle style) {
    final label = style.headingUppercase ? text.toUpperCase() : text;
    final heading = pw.Text(label, style: style.headingStyle);

    if (style.centeredHeadingRules) {
      return pw.Padding(
        padding: pw.EdgeInsets.only(bottom: style.headingBottomGap),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Expanded(
              child: pw.Divider(color: PdfColors.grey400, thickness: 0.5),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8),
              child: heading,
            ),
            pw.Expanded(
              child: pw.Divider(color: PdfColors.grey400, thickness: 0.5),
            ),
          ],
        ),
      );
    }

    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: style.headingBottomGap),
      child: style.headingUnderlineColor == null
          ? heading
          : pw.Container(
              padding: pw.EdgeInsets.only(bottom: style.headingBottomGap * 0.5),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: style.headingUnderlineColor!,
                    width: 1,
                  ),
                ),
              ),
              child: heading,
            ),
    );
  }

  pw.Widget _bullets(_PdfStyle style, String deltaJson) {
    final lines = RichTextField.plainTextOf(deltaJson)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.isEmpty) return pw.SizedBox();

    return pw.Padding(
      padding: pw.EdgeInsets.only(top: style.bulletTopGap),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (final line in lines)
            pw.Padding(
              padding: pw.EdgeInsets.only(bottom: style.bulletGap),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 5),
                    child: pw.Text(style.bulletChar, style: style.bodyStyle),
                  ),
                  pw.Expanded(child: pw.Text(line, style: style.bodyStyle)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _entryHeaderRow(_PdfStyle style, String title, String meta) {
    return style.stackedEntryHeader
        ? pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title, style: style.entryTitleStyle),
              pw.SizedBox(height: 1.5),
              pw.Text(meta, style: style.entryMetaStyle),
            ],
          )
        : pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: pw.Text(title, style: style.entryTitleStyle)),
              pw.Text(meta, style: style.entryMetaStyle),
            ],
          );
  }

  pw.Widget _experienceEntry(_PdfStyle style, WorkExperience experience) {
    final dateRange =
        '${experience.startLabel(l10n)} - '
        '${experience.endLabel(l10n)}';
    final title = experience.location.trim().isEmpty
        ? '${experience.jobTitle} - ${experience.employer}'
        : '${experience.jobTitle} - ${experience.employer}, '
              '${experience.location}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _entryHeaderRow(style, title, dateRange),
        _bullets(style, experience.description),
      ],
    );
  }

  pw.Widget _educationEntry(_PdfStyle style, Education education) {
    final dateRange =
        '${education.startLabel(l10n)} - '
        '${education.endLabel(l10n)}';
    final degreeLine = education.fieldOfStudy.trim().isEmpty
        ? '${education.degree} - ${education.institution}'
        : '${education.degree} in ${education.fieldOfStudy} - '
              '${education.institution}';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _entryHeaderRow(style, degreeLine, dateRange),
        _bullets(style, education.description),
      ],
    );
  }

  pw.Widget _certificationEntry(_PdfStyle style, Certification certification) {
    return _entryHeaderRow(
      style,
      '${certification.name} - ${certification.issuer}',
      certification.dateLabel(l10n),
    );
  }

  pw.Widget _customEntry(
    _PdfStyle style,
    CustomSection section,
    CustomSectionEntry entry,
  ) {
    final dateRange = section.hasDateRange
        ? '${entry.startLabel(l10n)} - ${entry.endLabel(l10n)}'
        : '';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _entryHeaderRow(style, entry.title, dateRange),
        if (section.hasDescription) _bullets(style, entry.description),
      ],
    );
  }
}

/// Per-template PDF style tokens — an independent counterpart to
/// `CvRenderer`'s Flutter `_Style`, using `pdf` package types
/// (`pw.Font`, `PdfColor`) instead of Flutter's.
class _PdfStyle {
  const _PdfStyle({
    required this.pagePadding,
    required this.sectionGap,
    required this.entryGap,
    required this.bulletTopGap,
    required this.bulletGap,
    required this.headingBottomGap,
    required this.headingUppercase,
    required this.headingUnderlineColor,
    required this.headingStyle,
    required this.bodyStyle,
    required this.entryTitleStyle,
    required this.entryMetaStyle,
    required this.stackedEntryHeader,
    required this.skillsAsChips,
    required this.contactSeparator,
    required this.fontRegular,
    required this.fontBold,
    required this.fontItalic,
    required this.textColor,
    required this.metaColor,
    required this.accentColor,
    this.centeredHeadingRules = false,
    this.bulletChar = '-',
  });

  final pw.EdgeInsets pagePadding;
  final double sectionGap;
  final double entryGap;
  final double bulletTopGap;
  final double bulletGap;
  final double headingBottomGap;
  final bool headingUppercase;
  final PdfColor? headingUnderlineColor;
  final pw.TextStyle headingStyle;
  final pw.TextStyle bodyStyle;
  final pw.TextStyle entryTitleStyle;
  final pw.TextStyle entryMetaStyle;
  final bool stackedEntryHeader;
  final bool skillsAsChips;
  final String contactSeparator;
  final pw.Font fontRegular;
  final pw.Font fontBold;
  final pw.Font fontItalic;
  final PdfColor textColor;
  final PdfColor metaColor;
  final PdfColor accentColor;
  final bool centeredHeadingRules;
  final String bulletChar;
}

_PdfStyle _styleFor(CvTemplateId templateId) {
  final accent = PdfColor.fromInt(0xff2e7d32);
  final textColor = PdfColor.fromInt(0xff1a1a1a);

  switch (templateId) {
    case CvTemplateId.minimalClassic:
      final serif = pw.Font.times();
      final serifBold = pw.Font.timesBold();
      final serifItalic = pw.Font.timesItalic();
      final metaColor = PdfColor.fromInt(0xff4a4a4a);
      return _PdfStyle(
        pagePadding: const pw.EdgeInsets.fromLTRB(34, 36, 34, 36),
        sectionGap: 14,
        entryGap: 10,
        bulletTopGap: 4,
        bulletGap: 2.5,
        headingBottomGap: 7,
        headingUppercase: false,
        headingUnderlineColor: PdfColors.grey400,
        headingStyle: pw.TextStyle(
          font: serifBold,
          fontSize: 11,
          color: textColor,
        ),
        bodyStyle: pw.TextStyle(font: serif, fontSize: 10, color: textColor),
        entryTitleStyle: pw.TextStyle(
          font: serifBold,
          fontSize: 10,
          color: textColor,
        ),
        entryMetaStyle: pw.TextStyle(
          font: serifItalic,
          fontSize: 9,
          color: metaColor,
        ),
        stackedEntryHeader: false,
        skillsAsChips: false,
        contactSeparator: '   |   ',
        fontRegular: serif,
        fontBold: serifBold,
        fontItalic: serifItalic,
        textColor: textColor,
        metaColor: metaColor,
        accentColor: accent,
      );

    case CvTemplateId.modernClean:
      final sans = pw.Font.helvetica();
      final sansBold = pw.Font.helveticaBold();
      final sansItalic = pw.Font.helveticaOblique();
      final metaColor = PdfColor.fromInt(0xff5c6360);
      return _PdfStyle(
        pagePadding: const pw.EdgeInsets.fromLTRB(30, 30, 30, 32),
        sectionGap: 16,
        entryGap: 12,
        bulletTopGap: 5,
        bulletGap: 3,
        headingBottomGap: 8,
        headingUppercase: true,
        headingUnderlineColor: PdfColor.fromInt(0xffd7ecdf),
        headingStyle: pw.TextStyle(
          font: sansBold,
          fontSize: 9.5,
          letterSpacing: 1,
          color: accent,
        ),
        bodyStyle: pw.TextStyle(
          font: sans,
          fontSize: 10,
          color: PdfColor.fromInt(0xff1a1c1b),
        ),
        entryTitleStyle: pw.TextStyle(
          font: sansBold,
          fontSize: 10.5,
          color: PdfColor.fromInt(0xff1a1c1b),
        ),
        entryMetaStyle: pw.TextStyle(font: sans, fontSize: 9, color: metaColor),
        stackedEntryHeader: true,
        skillsAsChips: false,
        contactSeparator: '   .   ',
        fontRegular: sans,
        fontBold: sansBold,
        fontItalic: sansItalic,
        textColor: PdfColor.fromInt(0xff1a1c1b),
        metaColor: metaColor,
        accentColor: accent,
      );

    case CvTemplateId.compactTechnical:
      final monoBold = pw.Font.courierBold();
      final sans = pw.Font.helvetica();
      final metaColor = PdfColor.fromInt(0xff555555);
      return _PdfStyle(
        pagePadding: const pw.EdgeInsets.fromLTRB(24, 24, 24, 26),
        sectionGap: 10,
        entryGap: 7,
        bulletTopGap: 3,
        bulletGap: 1.5,
        headingBottomGap: 4,
        headingUppercase: true,
        headingUnderlineColor: null,
        headingStyle: pw.TextStyle(
          font: monoBold,
          fontSize: 9,
          color: textColor,
        ),
        bodyStyle: pw.TextStyle(font: sans, fontSize: 8.8, color: textColor),
        entryTitleStyle: pw.TextStyle(
          font: sans,
          fontSize: 9.2,
          color: textColor,
        ),
        entryMetaStyle: pw.TextStyle(
          font: sans,
          fontSize: 8.3,
          color: metaColor,
        ),
        stackedEntryHeader: false,
        skillsAsChips: true,
        contactSeparator: '   |   ',
        fontRegular: sans,
        fontBold: monoBold,
        fontItalic: sans,
        textColor: textColor,
        metaColor: metaColor,
        accentColor: accent,
      );

    case CvTemplateId.professionalExecutive:
      final sans = pw.Font.helvetica();
      final sansBold = pw.Font.helveticaBold();
      final metaColor = PdfColor.fromInt(0xff555555);
      return _PdfStyle(
        pagePadding: const pw.EdgeInsets.fromLTRB(38, 38, 38, 40),
        sectionGap: 18,
        entryGap: 13,
        bulletTopGap: 6,
        bulletGap: 4,
        headingBottomGap: 9,
        headingUppercase: true,
        headingUnderlineColor: null,
        headingStyle: pw.TextStyle(
          font: sansBold,
          fontSize: 9.5,
          letterSpacing: 1.8,
          color: textColor,
        ),
        bodyStyle: pw.TextStyle(font: sans, fontSize: 10.3, color: textColor),
        entryTitleStyle: pw.TextStyle(
          font: sansBold,
          fontSize: 10.5,
          color: textColor,
        ),
        entryMetaStyle: pw.TextStyle(font: sans, fontSize: 9, color: metaColor),
        stackedEntryHeader: true,
        skillsAsChips: false,
        contactSeparator: '   .   ',
        fontRegular: sans,
        fontBold: sansBold,
        fontItalic: sans,
        textColor: textColor,
        metaColor: metaColor,
        accentColor: accent,
      );

    case CvTemplateId.pureMinimal:
      final sans = pw.Font.helvetica();
      final sansBold = pw.Font.helveticaBold();
      final metaColor = PdfColor.fromInt(0xff777777);
      return _PdfStyle(
        pagePadding: const pw.EdgeInsets.fromLTRB(36, 38, 36, 38),
        sectionGap: 20,
        entryGap: 14,
        bulletTopGap: 5,
        bulletGap: 3,
        headingBottomGap: 9,
        headingUppercase: true,
        headingUnderlineColor: null,
        headingStyle: pw.TextStyle(
          font: sansBold,
          fontSize: 9,
          letterSpacing: 1,
          color: textColor,
        ),
        bodyStyle: pw.TextStyle(font: sans, fontSize: 10, color: textColor),
        entryTitleStyle: pw.TextStyle(
          font: sansBold,
          fontSize: 10,
          color: textColor,
        ),
        entryMetaStyle: pw.TextStyle(
          font: sans,
          fontSize: 8.8,
          color: metaColor,
        ),
        stackedEntryHeader: true,
        skillsAsChips: false,
        contactSeparator: '   .   ',
        fontRegular: sans,
        fontBold: sansBold,
        fontItalic: sans,
        textColor: textColor,
        metaColor: metaColor,
        accentColor: accent,
        bulletChar: '-',
      );

    case CvTemplateId.corporateFormal:
      final serif = pw.Font.times();
      final serifBold = pw.Font.timesBold();
      final serifItalic = pw.Font.timesItalic();
      final metaColor = PdfColor.fromInt(0xff555555);
      return _PdfStyle(
        pagePadding: const pw.EdgeInsets.fromLTRB(34, 32, 34, 34),
        sectionGap: 16,
        entryGap: 11,
        bulletTopGap: 5,
        bulletGap: 3,
        headingBottomGap: 8,
        headingUppercase: true,
        headingUnderlineColor: null,
        centeredHeadingRules: true,
        headingStyle: pw.TextStyle(
          font: serifBold,
          fontSize: 9,
          letterSpacing: 1.6,
          color: textColor,
        ),
        bodyStyle: pw.TextStyle(font: serif, fontSize: 10, color: textColor),
        entryTitleStyle: pw.TextStyle(
          font: serifBold,
          fontSize: 10,
          color: textColor,
        ),
        entryMetaStyle: pw.TextStyle(
          font: serifItalic,
          fontSize: 9,
          color: metaColor,
        ),
        stackedEntryHeader: true,
        skillsAsChips: false,
        contactSeparator: '   |   ',
        fontRegular: serif,
        fontBold: serifBold,
        fontItalic: serifItalic,
        textColor: textColor,
        metaColor: metaColor,
        accentColor: accent,
      );
  }
}
