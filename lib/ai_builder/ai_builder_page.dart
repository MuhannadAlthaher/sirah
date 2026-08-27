import 'package:flutter/material.dart';
import 'package:sira/ai_builder/widgets/chat_bubble.dart';
import 'package:sira/ai_builder/widgets/step_progress_chip.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/theme/app_palette.dart';

/// The "AI Builder" tab: a chat-styled, scripted CV interview.
///
/// Visual-only for now — the step chips and transcript below are a
/// static demo, not driven by real [CvBuilderState]. Sending a
/// message stubs to the same coming-soon message every other AI
/// action in this app uses, since there's no AI backend yet.
class AiBuilderPage extends StatefulWidget {
  const AiBuilderPage({super.key});

  @override
  State<AiBuilderPage> createState() => _AiBuilderPageState();
}

class _AiBuilderPageState extends State<AiBuilderPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    if (_messageController.text.trim().isEmpty) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.aiBuilderComingSoon)));
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    final chips = [
      (l10n.aiBuilderChipPersonalInfo, StepChipStatus.completed),
      (l10n.aiBuilderChipSummary, StepChipStatus.completed),
      (l10n.aiBuilderChipExperience, StepChipStatus.completed),
      (l10n.aiBuilderChipEducation, StepChipStatus.current),
      (l10n.aiBuilderChipSkills, StepChipStatus.upcoming),
      (l10n.aiBuilderChipCertifications, StepChipStatus.upcoming),
    ];

    return Scaffold(
      backgroundColor: palette.screenBackground,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: chips.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) =>
                    StepProgressChip(label: chips[i].$1, status: chips[i].$2),
              ),
            ),
            Divider(height: 1, color: palette.border),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  ChatBubble(isAi: true, text: l10n.aiBuilderDemoAiMessage1),
                  ChatBubble(isAi: false, text: l10n.aiBuilderDemoUserMessage1),
                  ChatBubble(
                    isAi: true,
                    text: l10n.aiBuilderDemoAiMessage2,
                    confirmation: l10n.aiBuilderDemoConfirmation1,
                  ),
                  ChatBubble(isAi: true, text: l10n.aiBuilderDemoAiMessage3),
                  ChatBubble(isAi: false, text: l10n.aiBuilderDemoUserMessage2),
                  ChatBubble(
                    isAi: true,
                    text: l10n.aiBuilderDemoAiMessage4,
                    confirmation: l10n.aiBuilderDemoConfirmation2,
                  ),
                  ChatBubble(isAi: true, text: l10n.aiBuilderDemoAiMessage5),
                ],
              ),
            ),
            _InputBar(
              controller: _messageController,
              onSend: () => _send(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        color: palette.screenBackground,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: palette.border),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    l10n.aiBuilderDemoQuickReply,
                    style: TextStyle(
                      color: palette.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.surface,
                  border: Border.all(color: palette.border),
                ),
                child: Icon(Icons.mic_none, color: palette.textSecondary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: palette.surface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: l10n.aiBuilderInputPlaceholder,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.accent,
                  foregroundColor: palette.onAccent,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.aiBuilderSend,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
