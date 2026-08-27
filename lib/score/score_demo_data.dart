import 'package:sira/l10n/app_localizations.dart';

/// One category in the ATS score breakdown. Demo data for now — swap
/// for the real computed breakdown once ATS scoring exists.
class ScoreBreakdownItem {
  const ScoreBreakdownItem({required this.label, required this.score});

  final String label;
  final int score;
}

List<ScoreBreakdownItem> demoScoreBreakdownFor(AppLocalizations l10n) => [
  ScoreBreakdownItem(label: l10n.keywordMatch, score: 92),
  ScoreBreakdownItem(label: l10n.formatting, score: 88),
  ScoreBreakdownItem(label: l10n.sectionCompleteness, score: 80),
  ScoreBreakdownItem(label: l10n.readability, score: 85),
];
