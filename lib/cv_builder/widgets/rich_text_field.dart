import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sira/cv_builder/widgets/bullet_list.dart';
import 'package:sira/cv_builder/widgets/rich_text_fullscreen_page.dart';
import 'package:sira/cv_builder/widgets/text_direction_support.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// A toolbar button whose icon/pressed-state react live to
/// [controller] — used for every button below instead of Quill's
/// built-in toggle buttons, since those don't give a press handler to
/// hook extra coordination onto (see `text_direction_support.dart`
/// and `bullet_list.dart` for why bullets, alignment, and direction
/// all need to stay coordinated rather than acting independently).
QuillToolbarCustomButtonOptions _reactiveToolbarButton({
  required QuillController controller,
  required IconData icon,
  required bool Function() isSelected,
  required VoidCallback onPressed,
}) {
  return QuillToolbarCustomButtonOptions(
    onPressed: onPressed,
    // `childBuilder`'s declared type here is the raw, unparameterized
    // `Widget Function(dynamic, dynamic)?` — flutter_quill's own
    // options resolver stores it through un-generic-ed fields — so
    // the closure's params must stay `dynamic`, not the specific
    // option types, or this throws a type-check error at runtime.
    childBuilder: (dynamic options, dynamic extra) {
      final extraOptions = extra as QuillToolbarCustomButtonExtraOptions;
      return AnimatedBuilder(
        animation: controller,
        builder: (context, _) => QuillToolbarIconButton(
          icon: Icon(icon),
          isSelected: isSelected(),
          iconTheme: null,
          onPressed: extraOptions.onPressed,
        ),
      );
    },
  );
}

/// The Bold/Italic/Underline + alignment + bullet-list + link toolbar
/// shared by [RichTextField] and [RichTextFullScreenPage] — kept as a
/// function (not a `const`) since [extraButtons] differs per call
/// site (only the inline field shows the expand button).
///
/// There's no direction toggle button: direction is auto-detected from
/// each line's own content (see `text_direction_support.dart`), so the
/// bullet and alignment always land on the correct physical side
/// without a manual step to remember. Alignment and the bullet-list
/// button are both custom (not Quill's built-ins) — Quill's own bullet
/// marker never follows RTL content regardless of any attribute (see
/// `bullet_list.dart`), and its `align: left`/`right` attributes are
/// direction-*relative* under the hood, which `text_direction_support`
/// corrects for.
QuillSimpleToolbarConfig richTextToolbarConfig({
  required QuillController controller,
  List<QuillToolbarCustomButtonOptions> extraButtons = const [],
}) {
  QuillToolbarCustomButtonOptions alignmentButton(
    IconData icon,
    PhysicalAlignment target,
  ) {
    return _reactiveToolbarButton(
      controller: controller,
      icon: icon,
      isSelected: () => isPhysicalAlignmentActive(controller, target),
      onPressed: () => setPhysicalAlignment(controller, target),
    );
  }

  return QuillSimpleToolbarConfig(
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
    showAlignmentButtons: false,
    showDirection: false,
    showHeaderStyle: false,
    showListNumbers: false,
    showListBullets: false,
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
    customButtons: [
      alignmentButton(Icons.format_align_left, PhysicalAlignment.left),
      alignmentButton(Icons.format_align_center, PhysicalAlignment.center),
      alignmentButton(Icons.format_align_right, PhysicalAlignment.right),
      alignmentButton(Icons.format_align_justify, PhysicalAlignment.justify),
      _reactiveToolbarButton(
        controller: controller,
        icon: Icons.format_list_bulleted,
        isSelected: () => currentLineHasBullet(controller),
        onPressed: () => toggleBulletList(controller),
      ),
      ...extraButtons,
    ],
  );
}

/// A minimal rich-text editor (bold/italic/underline, a bulleted
/// list, a link, and paragraph alignment) backed by `flutter_quill`.
/// Content round-trips as a JSON-encoded Quill "delta" string, so it
/// can live in a plain [String] model field just like any other text.
///
/// The toolbar's expand button pushes [RichTextFullScreenPage] with
/// this same [QuillController] instance, so edits made there are
/// already reflected here the moment it pops — no delta hand-off.
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
    this.label,
  });

  /// A JSON-encoded Quill delta (`Document.toDelta().toJson()`), or
  /// an empty string for a blank document.
  final String initialDeltaJson;
  final ValueChanged<String> onChanged;
  final String? placeholder;

  /// Shown as the fullscreen editor's title; falls back to
  /// [AppLocalizations.cvDescription] when omitted.
  final String? label;

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
  bool _isSyncingDirection = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChange);
    _controller.onReplaceText = (index, len, data) =>
        handleBulletReplaceText(_controller, index, len, data);
  }

  void _handleChange() {
    if (!_isSyncingDirection) {
      _isSyncingDirection = true;
      syncDirectionWithContent(_controller);
      _isSyncingDirection = false;
    }
    widget.onChanged(jsonEncode(_controller.document.toDelta().toJson()));
  }

  void _openFullScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RichTextFullScreenPage(
          controller: _controller,
          label: widget.label,
          placeholder: widget.placeholder,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    _controller.onReplaceText = null;
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                config: richTextToolbarConfig(
                  controller: _controller,
                  extraButtons: [
                    QuillToolbarCustomButtonOptions(
                      icon: const Icon(Icons.open_in_full),
                      tooltip: l10n.cvExpandEditor,
                      onPressed: () => _openFullScreen(context),
                    ),
                  ],
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
