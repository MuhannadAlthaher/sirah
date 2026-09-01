import 'package:sira/l10n/app_localizations.dart';

/// One category in the ATS score breakdown. Demo data for now — swap
/// for the real computed breakdown once ATS scoring exists.
///
/// [tip] is a short, actionable suggestion for raising that specific
/// category's score — shown under the row whenever it's below
/// [ScoreBreakdownItem.strongScoreThreshold], so advice only surfaces
/// where the user actually has room to improve.
class ScoreBreakdownItem {
  const ScoreBreakdownItem({
    required this.label,
    required this.score,
    required this.tip,
  });

  static const strongScoreThreshold = 90;

  final String label;
  final int score;
  final String tip;

  bool get isStrong => score >= strongScoreThreshold;
}

List<ScoreBreakdownItem> demoScoreBreakdownFor(AppLocalizations l10n) => [
  ScoreBreakdownItem(
    label: l10n.keywordMatch,
    score: 92,
    tip: l10n.keywordMatchTip,
  ),
  ScoreBreakdownItem(
    label: l10n.formatting,
    score: 88,
    tip: l10n.formattingTip,
  ),
  ScoreBreakdownItem(
    label: l10n.sectionCompleteness,
    score: 80,
    tip: l10n.sectionCompletenessTip,
  ),
  ScoreBreakdownItem(
    label: l10n.readability,
    score: 85,
    tip: l10n.readabilityTip,
  ),
];
