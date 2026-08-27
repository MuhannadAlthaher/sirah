import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sira/theme/app_palette.dart';

/// A minimal rich-text editor (bold/italic/underline, a bulleted
/// list, a link, and paragraph alignment) backed by `flutter_quill`.
/// Content round-trips as a JSON-encoded Quill "delta" string, so it
/// can live in a plain [String] model field just like any other text.
///
/// A [StatefulWidget] because [QuillController] is a long-lived,
/// mutable controller that must survive this entry page's frequent
/// rebuilds (its `ValueNotifier<...>` draft repaints the whole form
/// on every keystroke in *any* field) — the same reasoning as
/// `PersonalInfoStep`'s [GlobalKey]s, just for a controller instead.
class RichTextField extends StatefulWidget {
  const RichTextField({
    super.key,
    required this.initialDeltaJson,
    required this.onChanged,
    this.placeholder,
  });

  /// A JSON-encoded Quill delta (`Document.toDelta().toJson()`), or
  /// an empty string for a blank document.
  final String initialDeltaJson;
  final ValueChanged<String> onChanged;
  final String? placeholder;

  /// Delta JSON -> plain text, for read-only previews (summary
  /// cards) that don't need the editor itself.
  static String plainTextOf(String deltaJson) {
    if (deltaJson.trim().isEmpty) return '';
    try {
      final document = Document.fromJson(jsonDecode(deltaJson) as List);
      return document.toPlainText().trim();
    } on FormatException {
      return '';
    }
  }

  @override
  State<RichTextField> createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  late final QuillController _controller = QuillController(
    document: widget.initialDeltaJson.trim().isEmpty
        ? Document()
        : Document.fromJson(jsonDecode(widget.initialDeltaJson) as List),
    selection: const TextSelection.collapsed(offset: 0),
  );
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChange);
  }

  void _handleChange() {
    widget.onChanged(jsonEncode(_controller.document.toDelta().toJson()));
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final padding = width * 0.04;

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.palette.border),
            borderRadius: BorderRadius.circular(padding),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: _controller,
                config: const QuillSimpleToolbarConfig(
                  showFontFamily: false,
                  showFontSize: false,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: false,
                  showInlineCode: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showClearFormat: false,
                  showAlignmentButtons: true,
                  showHeaderStyle: false,
                  showListNumbers: false,
                  showListBullets: true,
                  showListCheck: false,
                  showCodeBlock: false,
                  showQuote: false,
                  showIndent: false,
                  showLink: true,
                  showUndo: false,
                  showRedo: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                ),
              ),
              Divider(height: 1, color: context.palette.border),
              Padding(
                padding: EdgeInsets.all(padding),
                child: QuillEditor.basic(
                  controller: _controller,
                  focusNode: _focusNode,
                  config: QuillEditorConfig(
                    placeholder: widget.placeholder,
                    minHeight: width * 0.3,
                    padding: EdgeInsets.zero,
                    expands: false,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
