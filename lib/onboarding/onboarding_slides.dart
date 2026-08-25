import 'package:flutter/material.dart';
import 'package:sira/onboarding/onboarding_slide_data.dart';
import 'package:sira/onboarding/previews/action_pills_preview.dart';
import 'package:sira/onboarding/previews/ats_scan_preview.dart';
import 'package:sira/onboarding/previews/before_after_preview.dart';

/// The onboarding flow's three slides. Each one pairs a feature-card
/// preview template with its own headline, copy, and checklist.
final List<OnboardingSlideData> onboardingSlides = [
  OnboardingSlideData(
    icon: Icons.crop_free,
    previewBuilder: (sizes) => AtsScanPreview(sizes: sizes),
    title: 'Built to pass\nATS systems',
    description:
        'Your CV is structured with clean sections, standard headings '
        'and parsable formatting so Applicant Tracking Systems read '
        'every detail correctly.',
    bullets: const [
      'Parsable layout',
      'Standard section names',
      'Keyword-ready structure',
    ],
    ctaLabel: 'Continue',
  ),
  OnboardingSlideData(
    icon: Icons.auto_awesome,
    previewBuilder: (sizes) => BeforeAfterPreview(
      sizes: sizes,
      before: 'Worked on mobile applications.',
      after:
          'Developed high-performance mobile banking features in React '
          'Native, improving reliability across releases.',
    ),
    title: 'Turn your experience\ninto impact',
    description:
        'AI rewrites your content so recruiters see results, not tasks.',
    bullets: const [
      'Professional summaries',
      'Job descriptions',
      'Achievements',
      'Skills',
      'ATS keywords',
    ],
    ctaLabel: 'Continue',
  ),
  OnboardingSlideData(
    icon: Icons.description_outlined,
    previewBuilder: (sizes) => ActionPillsPreview(
      sizes: sizes,
      labels: const ['Fill', 'AI', 'Template', 'Download'],
      activeCount: 3,
    ),
    title: 'Your professional\nCV in minutes',
    description:
        'Fill your information → improve it with AI → choose a '
        'template → download your CV.',
    bullets: const [
      'Guided 7-step builder',
      'ATS score report',
      '5 recruiter-ready templates',
    ],
    ctaLabel: 'Create My CV',
    showSecondaryAction: true,
  ),
];
