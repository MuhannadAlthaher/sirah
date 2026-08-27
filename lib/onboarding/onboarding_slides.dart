import 'package:flutter/material.dart';
import 'package:sira/l10n/app_localizations.dart';
import 'package:sira/onboarding/onboarding_slide_data.dart';
import 'package:sira/onboarding/previews/action_pills_preview.dart';
import 'package:sira/onboarding/previews/ats_scan_preview.dart';
import 'package:sira/onboarding/previews/before_after_preview.dart';

/// The onboarding flow's three slides. Each one pairs a feature-card
/// preview template with its own headline, copy, and checklist.
const onboardingSlideCount = 3;

List<OnboardingSlideData> buildOnboardingSlides(AppLocalizations l10n) => [
  OnboardingSlideData(
    icon: Icons.crop_free,
    previewBuilder: (sizes) => AtsScanPreview(sizes: sizes),
    title: l10n.onboardingSlideOneTitle,
    description: l10n.onboardingSlideOneDescription,
    bullets: [
      l10n.parsableLayout,
      l10n.standardSectionNames,
      l10n.keywordReadyStructure,
    ],
    ctaLabel: l10n.continueLabel,
  ),
  OnboardingSlideData(
    icon: Icons.auto_awesome,
    previewBuilder: (sizes) => BeforeAfterPreview(
      sizes: sizes,
      before: l10n.onboardingBeforeText,
      after: l10n.onboardingAfterText,
    ),
    title: l10n.onboardingSlideTwoTitle,
    description: l10n.onboardingSlideTwoDescription,
    bullets: [
      l10n.professionalSummaries,
      l10n.jobDescriptions,
      l10n.achievements,
      l10n.skills,
      l10n.atsKeywords,
    ],
    ctaLabel: l10n.continueLabel,
  ),
  OnboardingSlideData(
    icon: Icons.description_outlined,
    previewBuilder: (sizes) => ActionPillsPreview(
      sizes: sizes,
      labels: [
        l10n.onboardingFillStep,
        l10n.brandAccent,
        l10n.onboardingTemplateStep,
        l10n.onboardingDownloadStep,
      ],
      activeCount: 3,
    ),
    title: l10n.onboardingSlideThreeTitle,
    description: l10n.onboardingSlideThreeDescription,
    bullets: [
      l10n.guidedBuilder,
      l10n.atsScoreReport,
      l10n.recruiterReadyTemplates,
    ],
    ctaLabel: l10n.createMyCv,
    showSecondaryAction: true,
  ),
];
