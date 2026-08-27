import 'package:flutter/material.dart';
import 'package:sira/cv_builder/models/cv_template.dart';
import 'package:sira/cv_builder/preview/cv_renderer.dart';
import 'package:sira/cv_builder/template_picker/sample_cv_state.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';
import 'package:sira/widget/primary_cta_button.dart';

/// The first screen of a brand-new CV: pick which of the 4 ATS-safe
/// designs to start from. Never final — "Change Template" on the live
/// preview (`CvPreviewPage`) reopens this same picker later, seeded
/// with [initialSelection].
class CvTemplatePickerPage extends StatefulWidget {
  const CvTemplatePickerPage({super.key, this.initialSelection});

  final CvTemplateId? initialSelection;

  @override
  State<CvTemplatePickerPage> createState() => _CvTemplatePickerPageState();
}

class _CvTemplatePickerPageState extends State<CvTemplatePickerPage> {
  late CvTemplateId _selected =
      widget.initialSelection ?? CvTemplateId.modernClean;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      appBar: AppBar(
        backgroundColor: context.palette.screenBackground,
        elevation: 0,
        foregroundColor: context.palette.textPrimary,
        title: Text(l10n.cvTemplatePickerTitle),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.clamp(0, 480).toDouble();
            final padding = width * 0.05;

            return Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: width,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.cvTemplatePickerSubtitle,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: context.palette.textSecondary,
                                  ),
                            ),
                            SizedBox(height: padding),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final tileWidth =
                                    (constraints.maxWidth - padding * 0.7) / 2;

                                return Wrap(
                                  spacing: padding * 0.7,
                                  runSpacing: padding,
                                  children: [
                                    for (final templateId
                                        in CvTemplateId.values)
                                      SizedBox(
                                        width: tileWidth,
                                        child: _TemplateGridTile(
                                          templateId: templateId,
                                          selected: _selected == templateId,
                                          width: tileWidth,
                                          onTap: () => setState(
                                            () => _selected = templateId,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        padding,
                        0,
                        padding,
                        padding,
                      ),
                      child: PrimaryCtaButton(
                        label: l10n.cvTemplateUseThis,
                        icon: Icons.check,
                        onPressed: () => Navigator.of(context).pop(_selected),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// One cell in the picker's 2-column grid: a real, scaled-down render
/// of the template (via [CvRenderer], filled with a fixed sample CV)
/// with its name in bold caps underneath — no separate description
/// text; the preview itself is meant to carry the decision.
class _TemplateGridTile extends StatelessWidget {
  const _TemplateGridTile({
    required this.templateId,
    required this.selected,
    required this.width,
    required this.onTap,
  });

  final CvTemplateId templateId;
  final bool selected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final padding = width * 0.08;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(padding),
      child: Container(
        padding: EdgeInsets.all(padding * 0.6),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(padding),
          border: Border.all(
            color: selected ? context.palette.accent : context.palette.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _TemplatePreview(templateId: templateId, width: width * 0.84),
                if (selected)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: Icon(
                      Icons.check_circle,
                      color: context.palette.accent,
                      size: 22,
                    ),
                  ),
              ],
            ),
            SizedBox(height: padding * 0.6),
            Text(
              templateId.displayName(l10n).toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: context.palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A real, miniature render of [templateId] — [CvRenderer] filled with
/// a fixed sample CV (see `samplePreviewState`) and scaled down to fit
/// [width], so what's picked here is exactly what the real preview
/// later shows, not an abstract stand-in.
class _TemplatePreview extends StatelessWidget {
  const _TemplatePreview({required this.templateId, required this.width});

  final CvTemplateId templateId;
  final double width;

  /// The width [CvRenderer] is laid out at before being scaled down —
  /// chosen to match its own font sizes/paddings (tuned for a
  /// full-size page), not [width].
  static const _naturalWidth = 340.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: width,
      height: width * 1.32,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffe4e4e4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: _naturalWidth,
          child: IgnorePointer(
            child: CvRenderer(
              state: samplePreviewState(l10n),
              templateId: templateId,
            ),
          ),
        ),
      ),
    );
  }
}
