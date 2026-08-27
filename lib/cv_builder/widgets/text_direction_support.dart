import 'package:flutter_quill/flutter_quill.dart';
import 'package:sira/cv_builder/widgets/bullet_list.dart';

/// A line's direction is detected automatically from its own content
/// (the first "strong" — i.e. directional — character typed), rather
/// than needing a manual toggle. A manual button was tried first, but
/// it's an easy step to forget: type Arabic without pressing it and
/// Unicode's bidi rules render the Arabic *word* correctly but treat
/// it as a same-position embedded island inside an otherwise-LTR
/// paragraph — the bullet stays on the LTR (left) side because
/// nothing ever told the paragraph itself it's RTL now. Detecting
/// direction from what's actually being typed means the bullet always
/// lands on the correct side without the user needing to know this
/// distinction exists.
bool _isRtlCodeUnit(int codeUnit) {
  return (codeUnit >= 0x0590 && codeUnit <= 0x05FF) || // Hebrew
      (codeUnit >= 0x0600 && codeUnit <= 0x06FF) || // Arabic
      (codeUnit >= 0x0750 && codeUnit <= 0x077F) || // Arabic Supplement
      (codeUnit >= 0x08A0 && codeUnit <= 0x08FF) || // Arabic Extended-A
      (codeUnit >= 0xFB1D &&
          codeUnit <= 0xFDFF) || // Hebrew/Arabic presentation forms
      (codeUnit >= 0xFE70 && codeUnit <= 0xFEFF); // Arabic presentation forms-B
}

bool _isLtrCodeUnit(int codeUnit) {
  return (codeUnit >= 0x0041 && codeUnit <= 0x005A) || // A-Z
      (codeUnit >= 0x0061 && codeUnit <= 0x007A); // a-z
}

/// The first strong (directional) character in [content] determines
/// its direction; digits, punctuation, and spaces are skipped since
/// they carry no direction of their own. `null` means nothing
/// direction-determining has been typed yet (e.g. an empty line, or
/// one with only numbers/punctuation so far) — callers should leave
/// the line's existing direction alone in that case.
bool? _detectRtl(String content) {
  for (final rune in content.runes) {
    if (_isRtlCodeUnit(rune)) return true;
    if (_isLtrCodeUnit(rune)) return false;
  }
  return null;
}

bool currentLineIsRtl(QuillController controller) {
  return controller.getSelectionStyle().attributes[Attribute.rtl.key]?.value ==
      'rtl';
}

String? currentAlignValue(QuillController controller) {
  return controller.getSelectionStyle().attributes[Attribute.align.key]?.value;
}

/// Re-evaluates the current line's direction against its own content
/// and updates the `direction` attribute if they've drifted apart —
/// called after every document change (see `RichTextField._handleChange`).
void syncDirectionWithContent(QuillController controller) {
  final text = controller.document.toPlainText();
  final cursor = controller.selection.baseOffset.clamp(0, text.length);
  final lineStart = lineStartOf(text, cursor);
  final contentStart = text.startsWith(bulletPrefix, lineStart)
      ? lineStart + bulletPrefix.length
      : lineStart;
  final lineEndIndex = text.indexOf('\n', contentStart);
  final lineEnd = lineEndIndex == -1 ? text.length : lineEndIndex;
  if (contentStart > lineEnd) return;

  final detectedRtl = _detectRtl(text.substring(contentStart, lineEnd));
  if (detectedRtl == null || detectedRtl == currentLineIsRtl(controller)) {
    return;
  }

  controller.formatSelection(
    detectedRtl ? Attribute.rtl : Attribute.clone(Attribute.rtl, null),
  );
}

/// Quill's `align: left` / `align: right` attributes resolve to
/// `TextAlign.start` / `.end`, which are relative to the paragraph's
/// direction, not the physical page — under RTL, `TextAlign.end`
/// physically renders on the **left**. Since direction is now
/// auto-detected from content (not a button the align buttons could
/// coordinate with), the align-left/right buttons instead pick
/// whichever underlying attribute is physically correct for the
/// line's *current* direction, so "align right" always means the
/// physical right edge regardless of which script is on that line.
enum PhysicalAlignment { left, center, right, justify }

Attribute<String?> _physicalAlignmentAttribute(
  QuillController controller,
  PhysicalAlignment target,
) {
  final isRtl = currentLineIsRtl(controller);
  return switch (target) {
    PhysicalAlignment.left =>
      isRtl ? Attribute.rightAlignment : Attribute.leftAlignment,
    PhysicalAlignment.right =>
      isRtl ? Attribute.leftAlignment : Attribute.rightAlignment,
    PhysicalAlignment.center => Attribute.centerAlignment,
    PhysicalAlignment.justify => Attribute.justifyAlignment,
  };
}

/// Whether [target] is the alignment currently active on this line —
/// drives the matching toolbar button's highlighted state.
bool isPhysicalAlignmentActive(
  QuillController controller,
  PhysicalAlignment target,
) {
  return currentAlignValue(controller) ==
      _physicalAlignmentAttribute(controller, target).value;
}

/// Applies (or clears, if already active) the alignment that
/// physically corresponds to [target] on-screen.
void setPhysicalAlignment(
  QuillController controller,
  PhysicalAlignment target,
) {
  final attribute = _physicalAlignmentAttribute(controller, target);
  final isActive = currentAlignValue(controller) == attribute.value;
  controller.formatSelection(
    isActive ? Attribute.clone(Attribute.align, null) : attribute,
  );
}
