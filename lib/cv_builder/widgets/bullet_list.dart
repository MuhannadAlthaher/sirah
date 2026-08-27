import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// A bulleted line starts with this literal text, rather than Quill's
/// built-in `list: bullet` block attribute.
///
/// Quill's own bullet-list rendering positions the marker in a way
/// that ignores both the line's `direction` attribute and the ambient
/// `Directionality` — confirmed by direct testing across every
/// combination, the marker never moves for RTL content. Treating the
/// bullet as ordinary paragraph text sidesteps that renderer entirely:
/// Flutter's own bidi-aware `RichText` places these leading neutral
/// characters (the bullet + spacing) on the same side as the rest of
/// the (correctly direction-aware) paragraph.
const String bulletPrefix = '•  ';

/// The plain-text offset where the line containing [offset] begins —
/// shared with `text_direction_support.dart`'s auto-direction detection,
/// which also needs to isolate a single line's content.
int lineStartOf(String text, int offset) {
  if (text.isEmpty) return 0;
  final safeOffset = offset.clamp(0, text.length);
  if (safeOffset == 0) return 0;
  final index = text.lastIndexOf('\n', safeOffset - 1);
  return index == -1 ? 0 : index + 1;
}

/// Whether the line the cursor is currently on already starts with
/// [bulletPrefix] — drives the toolbar button's active/inactive state.
bool currentLineHasBullet(QuillController controller) {
  final text = controller.document.toPlainText();
  final lineStart = lineStartOf(text, controller.selection.baseOffset);
  return text.startsWith(bulletPrefix, lineStart);
}

/// Adds or removes [bulletPrefix] on the line the cursor is currently
/// on. Only acts on a single line — a bullet button press with a
/// multi-line selection is a rare enough case that falling back to
/// "toggle just the cursor's line" is an acceptable simplification.
void toggleBulletList(QuillController controller) {
  final text = controller.document.toPlainText();
  final cursor = controller.selection.baseOffset.clamp(0, text.length);
  final lineStart = lineStartOf(text, cursor);

  if (text.startsWith(bulletPrefix, lineStart)) {
    controller.replaceText(
      lineStart,
      bulletPrefix.length,
      '',
      TextSelection.collapsed(
        offset: (cursor - bulletPrefix.length).clamp(lineStart, text.length),
      ),
    );
  } else {
    controller.replaceText(
      lineStart,
      0,
      bulletPrefix,
      TextSelection.collapsed(offset: cursor + bulletPrefix.length),
    );
  }
}

/// Wired to [QuillController.onReplaceText]. Handles two things for a
/// bulleted line:
///
/// 1. **Enter continues the bullet** onto the next line — always,
///    even when the current line is still empty. (An earlier version
///    followed Word/Google Docs and removed the bullet on an empty
///    line's Enter instead, to "exit" the list — but that meant a
///    second, easy-to-trigger-by-accident Enter silently dropped the
///    bullet with no visible cause, which read as data loss rather
///    than a feature. Pressing the bullet button is the only way to
///    turn a line off now — one predictable mechanism instead of two.)
///
/// 2. **Typing never lands before the bullet.** Under RTL content, a
///    bidi caret-affinity quirk can report a keystroke's insertion
///    index as sitting at or inside the bullet's prefix — visually
///    the cursor looks like it's right after the bullet, but the
///    input system logs the new character *before* it, so the typed
///    text ends up reading before the bullet instead of after it.
///    Any insertion that targets that protected zone is redirected to
///    just past it instead.
///
/// Returns `false` once it has handled the keystroke itself (so Quill
/// doesn't *also* apply the original, unredirected replacement),
/// `true` to let Quill's default handling proceed unchanged.
bool handleBulletReplaceText(
  QuillController controller,
  int index,
  int len,
  Object? data,
) {
  final text = controller.document.toPlainText();
  final safeIndex = index.clamp(0, text.length);
  final lineStart = lineStartOf(text, safeIndex);
  if (!text.startsWith(bulletPrefix, lineStart)) return true;
  final protectedEnd = lineStart + bulletPrefix.length;

  if (data == '\n' && len == 0) {
    final insertAt = safeIndex < protectedEnd ? protectedEnd : safeIndex;
    controller.replaceText(
      insertAt,
      0,
      '\n$bulletPrefix',
      TextSelection.collapsed(offset: insertAt + 1 + bulletPrefix.length),
    );
    return false;
  }

  if (data is String &&
      data.isNotEmpty &&
      len == 0 &&
      safeIndex < protectedEnd) {
    controller.replaceText(
      protectedEnd,
      0,
      data,
      TextSelection.collapsed(offset: protectedEnd + data.length),
    );
    return false;
  }

  return true;
}
