import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sira/cv_builder/widgets/rich_text_field.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// Full-page version of [RichTextField]'s editor, opened from its
/// toolbar's expand button.
///
/// Shares the same [QuillController] instance as the inline field it
/// was opened from (not a copy), so edits made here already live in
/// that field's document the moment this page pops — no delta
/// hand-off, no risk of the two views drifting apart.
class RichTextFullScreenPage extends StatefulWidget {
  const RichTextFullScreenPage({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
  });

  final QuillController controller;
  final String? label;
  final String? placeholder;

  @override
  State<RichTextFullScreenPage> createState() => _RichTextFullScreenPageState();
}

class _RichTextFullScreenPageState extends State<RichTextFullScreenPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: context.palette.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.label ?? l10n.cvDescription,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cvDone),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: context.palette.border),
            QuillSimpleToolbar(
              controller: widget.controller,
              config: richTextToolbarConfig(controller: widget.controller),
            ),
            Divider(height: 1, color: context.palette.border),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: QuillEditor(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  scrollController: ScrollController(),
                  config: QuillEditorConfig(
                    placeholder: widget.placeholder,
                    padding: EdgeInsets.zero,
                    expands: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
