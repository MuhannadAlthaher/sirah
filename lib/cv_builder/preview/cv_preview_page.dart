import 'package:flutter/material.dart';
import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/export/cv_export_actions.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/paywall/watermark_gate.dart';
import 'package:sira/cv_builder/preview/cv_renderer.dart';
import 'package:sira/cv_builder/template_picker/cv_template_picker_page.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// Whether the preview was opened just to "peek" mid-flow, or as the
/// final review after the last step — decides what the bottom CTA
/// does and says.
enum CvPreviewMode { peek, finalReview }

/// What [CvPreviewPage] pops with — the template it ended on (which
/// may have changed via "Change Template"), and, in [CvPreviewMode
/// .finalReview], whether the user actually tapped "Save CV".
class CvPreviewResult {
  const CvPreviewResult({required this.templateId, required this.saved});

  final CvTemplateId templateId;
  final bool saved;
}

/// A live, real render of the CV built so far — reachable at any
/// point in the flow ("peek") and shown once more as the last step
/// before saving. Carries a diagonal watermark until
/// [WatermarkGate.isPremium] is unlocked (dummy payment, for testing
/// the flow ahead of a real payment integration).
class CvPreviewPage extends StatefulWidget {
  const CvPreviewPage({super.key, required this.state, required this.mode});

  final CvBuilderState state;
  final CvPreviewMode mode;

  @override
  State<CvPreviewPage> createState() => _CvPreviewPageState();
}

/// A4's own width:height ratio — the preview page is sized against
/// this (not just clamped to a max width) so a short CV still renders
/// as a full page instead of shrinking down to hug its own content,
/// with the rest of the screen left as bare gray background.
const _kA4AspectRatio = 210 / 297;

class _CvPreviewPageState extends State<CvPreviewPage> {
  late CvTemplateId _templateId = widget.state.templateId;
  late bool _watermarkRemoved = WatermarkGate.isPremium.value;

  @override
  void initState() {
    super.initState();
    WatermarkGate.isPremium.addListener(_onPremiumChanged);
  }

  @override
  void dispose() {
    WatermarkGate.isPremium.removeListener(_onPremiumChanged);
    super.dispose();
  }

  void _onPremiumChanged() {
    setState(() => _watermarkRemoved = WatermarkGate.isPremium.value);
  }

  Future<void> _changeTemplate() async {
    final picked = await Navigator.of(context).push<CvTemplateId>(
      MaterialPageRoute(
        builder: (_) => CvTemplatePickerPage(initialSelection: _templateId),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _templateId = picked);
    }
  }

  void _close({required bool saved}) {
    Navigator.of(
      context,
    ).pop(CvPreviewResult(templateId: _templateId, saved: saved));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isFinal = widget.mode == CvPreviewMode.finalReview;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text(l10n.cvPreviewTitle),
        actions: [
          TextButton(
            onPressed: _changeTemplate,
            child: Text(l10n.cvPreviewChangeTemplate),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final pageWidth = constraints.maxWidth
                      .clamp(0, 720)
                      .toDouble();
                  final pageHeight = pageWidth / _kA4AspectRatio;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: pageWidth),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRect(
                            child: Stack(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: pageHeight,
                                  ),
                                  child: CvRenderer(
                                    state: widget.state,
                                    templateId: _templateId,
                                  ),
                                ),
                                if (!_watermarkRemoved)
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: _WatermarkOverlay(
                                        text: l10n.cvWatermarkText,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => exportCvAsPdf(
                            context,
                            state: widget.state,
                            templateId: _templateId,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.palette.textPrimary,
                            side: BorderSide(color: context.palette.border),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(
                            Icons.picture_as_pdf_outlined,
                            size: 18,
                          ),
                          label: Text(l10n.cvExportPdf),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => exportCvAsWord(
                            context,
                            state: widget.state,
                            templateId: _templateId,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.palette.textPrimary,
                            side: BorderSide(color: context.palette.border),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(
                            Icons.description_outlined,
                            size: 18,
                          ),
                          label: Text(l10n.cvExportWord),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (!_watermarkRemoved) ...[
                    OutlinedButton(
                      onPressed: () => showWatermarkPaywallSheet(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.palette.accent,
                        side: BorderSide(color: context.palette.border),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size.fromHeight(0),
                      ),
                      child: Text(l10n.cvWatermarkRemoveCta),
                    ),
                    const SizedBox(height: 10),
                  ],
                  PrimaryCtaButton(
                    label: isFinal
                        ? l10n.cvPreviewSaveCv
                        : l10n.cvPreviewBackToEditing,
                    icon: isFinal ? Icons.check : Icons.edit_outlined,
                    onPressed: () => _close(saved: isFinal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A repeating diagonal watermark tiled across the whole preview area
/// — the "unlicensed preview" mark the dummy paywall removes.
class _WatermarkOverlay extends StatelessWidget {
  const _WatermarkOverlay({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final diagonal = constraints.maxWidth + constraints.maxHeight;

        return Center(
          child: Transform.rotate(
            angle: -0.4636,
            child: SizedBox(
              width: diagonal,
              height: diagonal,
              child: Wrap(
                spacing: 32,
                runSpacing: 48,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: List.generate(
                  60,
                  (_) => Text(
                    text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
