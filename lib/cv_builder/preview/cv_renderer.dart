import 'package:flutter/material.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/models/certification.dart';
import 'package:sira/cv_builder/models/custom_section.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/models/education.dart';
import 'package:sira/cv_builder/models/work_experience.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';

/// Renders a [CvBuilderState]'s actual content as one of the 4
/// ATS-safe designs — single flowing column, standard fonts, literal
/// section headings, no icons carrying essential info. This is the
/// real CV; `CvTemplatePickerPage`'s thumbnails are only an abstract
/// stand-in shown before any content exists.
class CvRenderer extends StatelessWidget {
  const CvRenderer({super.key, required this.state, required this.templateId});

  final CvBuilderState state;
  final CvTemplateId templateId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = _styleFor(templateId);
    final roleTitle = state.experiences.isNotEmpty
        ? state.experiences.first.jobTitle.trim()
        : '';

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: style.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(l10n, style, roleTitle),
          if (templateId == CvTemplateId.minimalClassic) ...[
            SizedBox(height: style.sectionGap * 0.8),
            Container(height: 1, color: const Color(0xffcccccc)),
          ],
          SizedBox(height: style.sectionGap),
          ..._sections(context, l10n, style),
        ],
      ),
    );
  }

  // ---- Header (structurally different per template) ----

  Widget _header(AppLocalizations l10n, _Style style, String roleTitle) {
    final name = _fullName(l10n);
    final contact = _contactLine(style.contactSeparator);

    switch (templateId) {
      case CvTemplateId.minimalClassic:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1a1a1a),
              ),
            ),
            const SizedBox(height: 10),
            Container(width: 56, height: 2, color: const Color(0xff2e7d32)),
            if (roleTitle.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                roleTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xff3a3a3a),
                ),
              ),
            ],
            if (contact.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                contact,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 12,
                  color: Color(0xff4a4a4a),
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.modernClean:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xffe6f4ea),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1a1c1b),
                ),
              ),
              if (roleTitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  roleTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff2e7d32),
                  ),
                ),
              ],
              if (contact.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  contact,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xff3f4744),
                  ),
                ),
              ],
            ],
          ),
        );

      case CvTemplateId.compactTechnical:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xff1a1a1a),
              ),
            ),
            if (roleTitle.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                roleTitle,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xff444444),
                ),
              ),
            ],
            if (contact.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                contact,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10.5,
                  color: Color(0xff666666),
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.professionalExecutive:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Color(0xff1a1a1a),
              ),
            ),
            if (roleTitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                roleTitle.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: Color(0xff444444),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Container(height: 5, color: const Color(0xff2e7d32)),
            if (contact.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                contact,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xff444444),
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.pureMinimal:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: Color(0xff1a1a1a),
              ),
            ),
            if (roleTitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                roleTitle,
                style: const TextStyle(fontSize: 13, color: Color(0xff555555)),
              ),
            ],
            if (contact.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                contact,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xff888888),
                ),
              ),
            ],
          ],
        );

      case CvTemplateId.corporateFormal:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 23,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
                color: Color(0xff1a1a1a),
              ),
            ),
            if (roleTitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                roleTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Color(0xff444444),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Container(width: 64, height: 2, color: const Color(0xff2e7d32)),
            const SizedBox(height: 14),
            if (contact.isNotEmpty) ...[
              Container(height: 1, color: const Color(0xffcccccc)),
              const SizedBox(height: 8),
              Text(
                contact,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 12,
                  color: Color(0xff444444),
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 1, color: const Color(0xffcccccc)),
            ],
          ],
        );
    }
  }

  String _fullName(AppLocalizations l10n) {
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
      info.country,
    ].where((s) => s.trim().isNotEmpty).join(', ');
    final parts = [
      info.email,
      info.phone,
      location,
    ].where((s) => s.trim().isNotEmpty).toList();
    return parts.join(separator);
  }

  // ---- Sections ----

  List<Widget> _sections(
    BuildContext context,
    AppLocalizations l10n,
    _Style style,
  ) {
    final sections = <Widget>[];

    if (state.isSummaryComplete) {
      sections.add(
        _section(
          style: style,
          heading: l10n.cvStepSummaryTitle,
          child: _paragraph(state.summary, style),
        ),
      );
    }

    if (state.experiences.isNotEmpty) {
      sections.add(
        _section(
          style: style,
          heading: l10n.cvStepExperienceTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < state.experiences.length; i++) ...[
                _experienceEntry(l10n, style, state.experiences[i]),
                if (i != state.experiences.length - 1)
                  SizedBox(height: style.entryGap),
              ],
            ],
          ),
        ),
      );
    }

    if (state.educations.isNotEmpty) {
      sections.add(
        _section(
          style: style,
          heading: l10n.cvStepEducationTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < state.educations.length; i++) ...[
                _educationEntry(l10n, style, state.educations[i]),
                if (i != state.educations.length - 1)
                  SizedBox(height: style.entryGap),
              ],
            ],
          ),
        ),
      );
    }

    if (state.skills.selected.isNotEmpty) {
      sections.add(
        _section(
          style: style,
          heading: l10n.cvStepSkillsTitle,
          child: style.skillsAsChips
              ? Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final skill in state.skills.selected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffdddddd)),
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xfff7f7f7),
                        ),
                        child: Text(
                          skill,
                          style: style.bodyStyle.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                )
              : Text(state.skills.selected.join(', '), style: style.bodyStyle),
        ),
      );
    }

    if (state.certifications.isNotEmpty) {
      sections.add(
        _section(
          style: style,
          heading: l10n.cvStepCertificationsTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < state.certifications.length; i++) ...[
                _certificationEntry(l10n, style, state.certifications[i]),
                if (i != state.certifications.length - 1)
                  SizedBox(height: style.entryGap * 0.6),
              ],
            ],
          ),
        ),
      );
    }

    for (final custom in state.customSections) {
      if (custom.entries.isEmpty) continue;
      sections.add(
        _section(
          style: style,
          heading: custom.title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < custom.entries.length; i++) ...[
                _customEntry(l10n, style, custom, custom.entries[i]),
                if (i != custom.entries.length - 1)
                  SizedBox(height: style.entryGap),
              ],
            ],
          ),
        ),
      );
    }

    return [
      for (final section in sections) ...[
        section,
        SizedBox(height: style.sectionGap),
      ],
    ];
  }

  Widget _section({
    required _Style style,
    required String heading,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_sectionHeading(heading, style), child],
    );
  }

  Widget _sectionHeading(String text, _Style style) {
    final label = style.headingUppercase ? text.toUpperCase() : text;
    final heading = Text(label, style: style.headingStyle);

    if (style.centeredHeadingRules) {
      return Padding(
        padding: EdgeInsets.only(bottom: style.headingBottomGap),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(height: 1, color: const Color(0xffcccccc)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: heading,
            ),
            Expanded(
              child: Container(height: 1, color: const Color(0xffcccccc)),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: style.headingBottomGap),
      child: style.headingUnderline == null
          ? heading
          : Container(
              padding: EdgeInsets.only(bottom: style.headingBottomGap * 0.5),
              decoration: BoxDecoration(
                border: Border(bottom: style.headingUnderline!),
              ),
              child: heading,
            ),
    );
  }

  Widget _paragraph(String text, _Style style) =>
      Text(text.trim(), style: style.bodyStyle);

  Widget _bullets(String deltaJson, _Style style) {
    final lines = RichTextField.plainTextOf(deltaJson)
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: style.bulletTopGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines)
            Padding(
              padding: EdgeInsets.only(bottom: style.bulletGap),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6, top: 1),
                    child: Text(style.bulletChar, style: style.bodyStyle),
                  ),
                  Expanded(child: Text(line, style: style.bodyStyle)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _entryHeaderRow(String title, String meta, _Style style) {
    return style.stackedEntryHeader
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: style.entryTitleStyle),
              const SizedBox(height: 2),
              Text(meta, style: style.entryMetaStyle),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(title, style: style.entryTitleStyle)),
              Text(meta, style: style.entryMetaStyle),
            ],
          );
  }

  Widget _experienceEntry(
    AppLocalizations l10n,
    _Style style,
    WorkExperience experience,
  ) {
    final dateRange =
        '${experience.startLabel(l10n)} – '
        '${experience.endLabel(l10n)}';
    final title = experience.location.trim().isEmpty
        ? '${experience.jobTitle} — ${experience.employer}'
        : '${experience.jobTitle} — ${experience.employer}, '
              '${experience.location}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _entryHeaderRow(title, dateRange, style),
        _bullets(experience.description, style),
      ],
    );
  }

  Widget _educationEntry(
    AppLocalizations l10n,
    _Style style,
    Education education,
  ) {
    final dateRange =
        '${education.startLabel(l10n)} – '
        '${education.endLabel(l10n)}';
    final degreeLine = education.fieldOfStudy.trim().isEmpty
        ? '${education.degree} — ${education.institution}'
        : '${education.degree} in ${education.fieldOfStudy} — '
              '${education.institution}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _entryHeaderRow(degreeLine, dateRange, style),
        _bullets(education.description, style),
      ],
    );
  }

  Widget _certificationEntry(
    AppLocalizations l10n,
    _Style style,
    Certification certification,
  ) {
    return _entryHeaderRow(
      '${certification.name} — ${certification.issuer}',
      certification.dateLabel(l10n),
      style,
    );
  }

  Widget _customEntry(
    AppLocalizations l10n,
    _Style style,
    CustomSection section,
    CustomSectionEntry entry,
  ) {
    final dateRange = section.hasDateRange
        ? '${entry.startLabel(l10n)} – ${entry.endLabel(l10n)}'
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _entryHeaderRow(entry.title, dateRange, style),
        if (section.hasDescription) _bullets(entry.description, style),
      ],
    );
  }

  // ---- Per-template style tokens ----

  _Style _styleFor(CvTemplateId templateId) {
    switch (templateId) {
      case CvTemplateId.minimalClassic:
        return _Style(
          pagePadding: const EdgeInsets.fromLTRB(40, 44, 40, 44),
          sectionGap: 20,
          entryGap: 14,
          bulletTopGap: 6,
          bulletGap: 3,
          headingBottomGap: 10,
          headingUppercase: false,
          headingUnderline: const BorderSide(color: Color(0xffcccccc)),
          headingStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Color(0xff1a1a1a),
          ),
          bodyStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 13.5,
            height: 1.5,
            color: Color(0xff1a1a1a),
          ),
          entryTitleStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: Color(0xff1a1a1a),
          ),
          entryMetaStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 12.5,
            fontStyle: FontStyle.italic,
            color: Color(0xff4a4a4a),
          ),
          stackedEntryHeader: false,
          skillsAsChips: false,
          contactSeparator: '   |   ',
        );

      case CvTemplateId.modernClean:
        return _Style(
          pagePadding: const EdgeInsets.fromLTRB(36, 36, 36, 40),
          sectionGap: 26,
          entryGap: 18,
          bulletTopGap: 8,
          bulletGap: 4,
          headingBottomGap: 12,
          headingUppercase: true,
          headingUnderline: const BorderSide(
            color: Color(0xffd7ecdf),
            width: 2,
          ),
          headingStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
            color: Color(0xff2e7d32),
          ),
          bodyStyle: const TextStyle(
            fontSize: 13.5,
            height: 1.6,
            color: Color(0xff1a1c1b),
          ),
          entryTitleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff1a1c1b),
          ),
          entryMetaStyle: const TextStyle(
            fontSize: 12.5,
            color: Color(0xff5c6360),
          ),
          stackedEntryHeader: true,
          skillsAsChips: false,
          contactSeparator: '   ·   ',
        );

      case CvTemplateId.compactTechnical:
        return _Style(
          pagePadding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
          sectionGap: 14,
          entryGap: 10,
          bulletTopGap: 4,
          bulletGap: 2,
          headingBottomGap: 6,
          headingUppercase: true,
          headingUnderline: null,
          headingStyle: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Color(0xff1a1a1a),
          ),
          bodyStyle: const TextStyle(
            fontSize: 12,
            height: 1.35,
            color: Color(0xff1a1a1a),
          ),
          entryTitleStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Color(0xff1a1a1a),
          ),
          entryMetaStyle: const TextStyle(
            fontSize: 11.5,
            color: Color(0xff555555),
          ),
          stackedEntryHeader: false,
          skillsAsChips: true,
          contactSeparator: '   |   ',
        );

      case CvTemplateId.professionalExecutive:
        return _Style(
          pagePadding: const EdgeInsets.fromLTRB(48, 48, 48, 52),
          sectionGap: 30,
          entryGap: 20,
          bulletTopGap: 10,
          bulletGap: 6,
          headingBottomGap: 14,
          headingUppercase: true,
          headingUnderline: null,
          headingStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.6,
            color: Color(0xff1a1a1a),
          ),
          bodyStyle: const TextStyle(
            fontSize: 14,
            height: 1.65,
            color: Color(0xff1a1a1a),
          ),
          entryTitleStyle: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xff1a1a1a),
          ),
          entryMetaStyle: const TextStyle(
            fontSize: 12.5,
            color: Color(0xff555555),
          ),
          stackedEntryHeader: true,
          skillsAsChips: false,
          contactSeparator: '   •   ',
        );

      case CvTemplateId.pureMinimal:
        return _Style(
          pagePadding: const EdgeInsets.fromLTRB(44, 48, 44, 48),
          sectionGap: 34,
          entryGap: 20,
          bulletTopGap: 8,
          bulletGap: 5,
          headingBottomGap: 14,
          headingUppercase: true,
          headingUnderline: null,
          headingStyle: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.6,
            color: Color(0xff1a1a1a),
          ),
          bodyStyle: const TextStyle(
            fontSize: 13.5,
            height: 1.6,
            color: Color(0xff1a1a1a),
          ),
          entryTitleStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xff1a1a1a),
          ),
          entryMetaStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xff777777),
          ),
          stackedEntryHeader: true,
          skillsAsChips: false,
          contactSeparator: '   ·   ',
          bulletChar: '–',
        );

      case CvTemplateId.corporateFormal:
        return _Style(
          pagePadding: const EdgeInsets.fromLTRB(42, 40, 42, 44),
          sectionGap: 24,
          entryGap: 16,
          bulletTopGap: 7,
          bulletGap: 4,
          headingBottomGap: 12,
          headingUppercase: true,
          headingUnderline: null,
          centeredHeadingRules: true,
          headingStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: Color(0xff1a1a1a),
          ),
          bodyStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 13.5,
            height: 1.55,
            color: Color(0xff1a1a1a),
          ),
          entryTitleStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: Color(0xff1a1a1a),
          ),
          entryMetaStyle: const TextStyle(
            fontFamily: 'serif',
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: Color(0xff555555),
          ),
          stackedEntryHeader: true,
          skillsAsChips: false,
          contactSeparator: '   |   ',
        );
    }
  }
}

class _Style {
  const _Style({
    required this.pagePadding,
    required this.sectionGap,
    required this.entryGap,
    required this.bulletTopGap,
    required this.bulletGap,
    required this.headingBottomGap,
    required this.headingUppercase,
    required this.headingUnderline,
    required this.headingStyle,
    required this.bodyStyle,
    required this.entryTitleStyle,
    required this.entryMetaStyle,
    required this.stackedEntryHeader,
    required this.skillsAsChips,
    required this.contactSeparator,
    this.centeredHeadingRules = false,
    this.bulletChar = '•',
  });

  final EdgeInsets pagePadding;
  final double sectionGap;
  final double entryGap;
  final double bulletTopGap;
  final double bulletGap;
  final double headingBottomGap;
  final bool headingUppercase;
  final BorderSide? headingUnderline;
  final TextStyle headingStyle;
  final TextStyle bodyStyle;
  final TextStyle entryTitleStyle;
  final TextStyle entryMetaStyle;

  /// Title/date stacked on two lines (Modern Clean, Professional
  /// Executive) vs. on one row with the date at the trailing edge
  /// (Minimal Classic, Compact Technical).
  final bool stackedEntryHeader;
  final bool skillsAsChips;
  final String contactSeparator;

  /// Corporate Formal's centered heading label flanked by a thin rule
  /// on each side, instead of the usual left-aligned label (with or
  /// without an underline).
  final bool centeredHeadingRules;

  /// The character each bullet line is prefixed with — Pure Minimal
  /// uses a plain dash for a more understated look; everything else
  /// keeps the classic bullet dot.
  final String bulletChar;
}
