import 'package:sira/l10n/app_localizations.dart';

/// The six ATS-safe CV designs a user can pick between at the start of
/// the CV Builder flow (see `CvTemplatePickerPage`) and switch between
/// later from the live preview ("Change Template"). Purely a
/// rendering choice — it never changes which fields exist or how
/// "complete" a section is.
enum CvTemplateId {
  minimalClassic,
  modernClean,
  compactTechnical,
  professionalExecutive,
  pureMinimal,
  corporateFormal;

  String displayName(AppLocalizations l10n) => switch (this) {
    CvTemplateId.minimalClassic => l10n.cvTemplateMinimalClassicName,
    CvTemplateId.modernClean => l10n.cvTemplateModernCleanName,
    CvTemplateId.compactTechnical => l10n.cvTemplateCompactTechnicalName,
    CvTemplateId.professionalExecutive =>
      l10n.cvTemplateProfessionalExecutiveName,
    CvTemplateId.pureMinimal => l10n.cvTemplatePureMinimalName,
    CvTemplateId.corporateFormal => l10n.cvTemplateCorporateFormalName,
  };
}
