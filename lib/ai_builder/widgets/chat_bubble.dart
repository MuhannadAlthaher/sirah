import 'package:flutter/material.dart';
import 'package:sira/theme/app_palette.dart';

/// One message in the AI Builder's chat transcript. AI messages show
/// a small avatar and, optionally, a save-confirmation pill beneath
/// them (e.g. "Personal info saved") once that section is filled in;
/// user messages are plain, right-aligned bubbles.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isAi,
    required this.text,
    this.confirmation,
  });

  final bool isAi;
  final String text;
  final String? confirmation;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isAi ? palette.surface : palette.accent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAi ? palette.textPrimary : palette.onAccent,
            height: 1.35,
          ),
        ),
      ),
    );

    if (!isAi) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Align(alignment: Alignment.centerRight, child: bubble),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: palette.accentSoft,
            child: Text(
              'AI',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: palette.accent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bubble,
                if (confirmation != null) ...[
                  const SizedBox(height: 6),
                  _ConfirmationPill(text: confirmation!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationPill extends StatelessWidget {
  const _ConfirmationPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 12, color: palette.accent),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: palette.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
