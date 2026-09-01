import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/export/cv_pdf_document.dart';
import 'package:sira/cv_builder/export/cv_word_document.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/paywall/watermark_gate.dart';
import 'package:sira/l10n/app_localizations.dart';

/// A safe, human-readable base filename from the CV's own name — used
/// for both the PDF and Word exports.
String _fileBaseName(AppLocalizations l10n, CvBuilderState state) {
  final name = state.draftName(l10n);
  final safe = name.replaceAll(RegExp(r'[^A-Za-z0-9 _-]'), '').trim();
  return safe.isEmpty ? 'CV' : safe;
}

/// Opens the OS print/export sheet for a real, selectable-text PDF of
/// [state] — the watermark is included unless the dummy paywall has
/// been unlocked ([WatermarkGate.isPremium]), same as the in-app
/// preview.
Future<void> exportCvAsPdf(
  BuildContext context, {
  required CvBuilderState state,
  required CvTemplateId templateId,
}) async {
  final l10n = context.l10n;
  final fileName = _fileBaseName(l10n, state);

  await Printing.layoutPdf(
    name: fileName,
    onLayout: (format) => buildCvPdfBytes(
      l10n: l10n,
      state: state,
      templateId: templateId,
      includeWatermark: !WatermarkGate.isPremium.value,
    ),
  );
}

/// Shares a real, selectable-text PDF file of [state] via the native
/// share sheet — used for the CV card's "Share" action, which
/// previously only shared plain text.
Future<void> shareCvAsPdf(
  BuildContext context, {
  required CvBuilderState state,
  required CvTemplateId templateId,
}) async {
  final l10n = context.l10n;
  final fileName = _fileBaseName(l10n, state);
  final bytes = await buildCvPdfBytes(
    l10n: l10n,
    state: state,
    templateId: templateId,
    includeWatermark: !WatermarkGate.isPremium.value,
  );

  await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(
          bytes,
          name: '$fileName.pdf',
          mimeType: 'application/pdf',
        ),
      ],
      subject: fileName,
    ),
  );
}

/// Shares a real, Word-openable `.doc` file of [state] via the native
/// share sheet (which on most platforms also offers "Save to Files").
Future<void> exportCvAsWord(
  BuildContext context, {
  required CvBuilderState state,
  required CvTemplateId templateId,
}) async {
  final l10n = context.l10n;
  final fileName = _fileBaseName(l10n, state);
  final bytes = buildCvWordBytes(
    l10n: l10n,
    state: state,
    templateId: templateId,
    includeWatermark: !WatermarkGate.isPremium.value,
  );

  await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(
          bytes,
          name: '$fileName.doc',
          mimeType: 'application/msword',
        ),
      ],
      subject: fileName,
    ),
  );
}
