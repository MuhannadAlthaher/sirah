import 'package:sira/cv_builder/bloc/cv_builder_state.dart';
import 'package:sira/cv_builder/models/education.dart';
import 'package:sira/cv_builder/models/personal_info.dart';
import 'package:sira/cv_builder/models/skills_selection.dart';
import 'package:sira/cv_builder/models/work_experience.dart';
import 'package:sira/l10n/app_localizations.dart';

/// A short, fixed sample CV — used only to render a realistic-looking
/// thumbnail on `CvTemplatePickerPage` before the user has entered any
/// real content of their own. Identical across all 4 templates so the
/// thumbnail differences are purely the design, not the content.
CvBuilderState samplePreviewState(AppLocalizations l10n) {
  return CvBuilderState.initial().copyWith(
    personalInfo: const PersonalInfo(
      firstName: 'Muhannad',
      lastName: 'AlThaher',
      email: 'muhannad.althaher@email.com',
      phone: '+1 555 010 2020',
      city: 'Austin',
      country: 'United States',
    ),
    summary:
        'Results-driven ${l10n.demoUserPosition.toLowerCase()} with a track '
        'record of delivering cross-functional projects on time and under '
        'budget.',
    experiences: [
      WorkExperience(
        id: 'sample-1',
        employer: 'Brightline Systems',
        jobTitle: l10n.demoUserPosition,
        startMonth: 3,
        startYear: 2021,
        isCurrent: true,
        location: 'Austin, TX',
        description:
            'Led planning and delivery for 6 concurrent product '
            'workstreams.',
      ),
      WorkExperience(
        id: 'sample-2',
        employer: 'Northbridge Labs',
        jobTitle: 'Associate Project Manager',
        startMonth: 6,
        startYear: 2018,
        endMonth: 2,
        endYear: 2021,
        location: 'Austin, TX',
        description:
            'Coordinated schedules and stakeholder updates across '
            'three teams.',
      ),
    ],
    educations: const [
      Education(
        id: 'sample-edu-1',
        institution: 'University of Texas',
        degree: 'B.A.',
        fieldOfStudy: 'Business Administration',
        startMonth: 8,
        startYear: 2014,
        endMonth: 5,
        endYear: 2018,
      ),
    ],
    skills: const SkillsSelection(
      selected: {
        'Project Planning',
        'Stakeholder Management',
        'Budget Tracking',
        'Agile Delivery',
      },
    ),
  );
}
