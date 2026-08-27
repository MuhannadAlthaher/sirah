import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];
  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'AppLocalizations not found in context.');
    return localizations!;
  }

  bool get isArabic => locale.languageCode == 'ar';

  String _text({required String en, required String ar}) => isArabic ? ar : en;

  String get brandLead => _text(en: 'Resume', ar: 'سيرة');
  String get brandAccent => 'AI';

  String get homeTab => _text(en: 'Home', ar: 'الرئيسية');
  String get scoreTab => _text(en: 'Score', ar: 'الدرجة');
  String get profileTab => _text(en: 'Profile', ar: 'الملف الشخصي');
  String get settingsTab => _text(en: 'Settings', ar: 'الإعدادات');

  String get skip => _text(en: 'Skip', ar: 'تخطي');
  String get continueLabel => _text(en: 'Continue', ar: 'متابعة');
  String get alreadyHaveAccount =>
      _text(en: 'I already have an account', ar: 'لدي حساب بالفعل');
  String get createMyCv => _text(en: 'Create My CV', ar: 'أنشئ سيرتي الذاتية');

  String get onboardingSlideOneTitle =>
      _text(en: 'Built to pass\nATS systems', ar: 'مصممة لاجتياز\nأنظمة ATS');
  String get onboardingSlideOneDescription => _text(
    en:
        'Your CV is structured with clean sections, standard headings and '
        'parsable formatting so Applicant Tracking Systems read every '
        'detail correctly.',
    ar:
        'سيرتك الذاتية منظمة بأقسام واضحة وعناوين قياسية وتنسيق قابل '
        'للقراءة ليتمكن نظام تتبع المتقدمين من فهم كل التفاصيل بدقة.',
  );
  String get parsableLayout =>
      _text(en: 'Parsable layout', ar: 'تصميم قابل للقراءة');
  String get standardSectionNames =>
      _text(en: 'Standard section names', ar: 'أسماء أقسام قياسية');
  String get keywordReadyStructure =>
      _text(en: 'Keyword-ready structure', ar: 'هيكل جاهز للكلمات المفتاحية');

  String get onboardingBeforeLabel => _text(en: 'BEFORE', ar: 'قبل');
  String get onboardingAfterLabel => _text(en: 'AFTER', ar: 'بعد');
  String get onboardingBeforeText => _text(
    en: 'Worked on mobile applications.',
    ar: 'عملت على تطبيقات للجوال.',
  );
  String get onboardingAfterText => _text(
    en:
        'Developed high-performance mobile banking features in React '
        'Native, improving reliability across releases.',
    ar:
        'طورت مزايا عالية الأداء لتطبيقات بنكية للجوال باستخدام React '
        'Native، مما حسّن الاعتمادية عبر الإصدارات.',
  );
  String get onboardingSlideTwoTitle => _text(
    en: 'Turn your experience\ninto impact',
    ar: 'حوّل خبرتك\nإلى تأثير',
  );
  String get onboardingSlideTwoDescription => _text(
    en: 'AI rewrites your content so recruiters see results, not tasks.',
    ar: 'يعيد الذكاء الاصطناعي صياغة محتواك ليرى مسؤولو التوظيف النتائج لا المهام.',
  );
  String get professionalSummaries =>
      _text(en: 'Professional summaries', ar: 'الملخصات المهنية');
  String get jobDescriptions =>
      _text(en: 'Job descriptions', ar: 'الأوصاف الوظيفية');
  String get achievements => _text(en: 'Achievements', ar: 'الإنجازات');
  String get skills => _text(en: 'Skills', ar: 'المهارات');
  String get atsKeywords =>
      _text(en: 'ATS keywords', ar: 'الكلمات المفتاحية لـ ATS');

  String get onboardingAtsScan => _text(en: 'ATS SCAN', ar: 'فحص ATS');
  String get onboardingFillStep => _text(en: 'Fill', ar: 'إدخال');
  String get onboardingTemplateStep => _text(en: 'Template', ar: 'قالب');
  String get onboardingDownloadStep => _text(en: 'Download', ar: 'تنزيل');
  String get onboardingSlideThreeTitle => _text(
    en: 'Your professional\nCV in minutes',
    ar: 'سيرتك المهنية\nخلال دقائق',
  );
  String get onboardingSlideThreeDescription => _text(
    en:
        'Fill your information -> improve it with AI -> choose a '
        'template -> download your CV.',
    ar:
        'أدخل معلوماتك -> حسّنها بالذكاء الاصطناعي -> اختر قالباً -> '
        'نزّل سيرتك الذاتية.',
  );
  String get guidedBuilder =>
      _text(en: 'Guided 7-step builder', ar: 'منشئ موجه من 7 خطوات');
  String get atsScoreReport =>
      _text(en: 'ATS score report', ar: 'تقرير درجة ATS');
  String get recruiterReadyTemplates =>
      _text(en: '5 recruiter-ready templates', ar: '5 قوالب جاهزة للتوظيف');

  String get loginTitle => _text(
    en: 'Build a resume that gets you hired',
    ar: 'أنشئ سيرة ذاتية تساعدك على الحصول على الوظيفة',
  );
  String get loginDescription => _text(
    en:
        'Sign in to save your CV, access it on any device, and unlock AI '
        'rewriting, ATS scoring, and premium templates.',
    ar:
        'سجّل الدخول لحفظ سيرتك الذاتية والوصول إليها من أي جهاز وفتح '
        'ميزات إعادة الصياغة بالذكاء الاصطناعي ودرجة ATS والقوالب المميزة.',
  );
  String get continueWithApple =>
      _text(en: 'Continue with Apple', ar: 'المتابعة باستخدام Apple');
  String get continueWithGoogle =>
      _text(en: 'Continue with Google', ar: 'المتابعة باستخدام Google');
  String get continueWithEmail => _text(
    en: 'Continue with Email',
    ar: 'المتابعة باستخدام البريد الإلكتروني',
  );
  String get continueWithPhoneNumber => _text(
    en: 'Continue with Phone Number',
    ar: 'المتابعة باستخدام رقم الهاتف',
  );
  String get continueAsGuest =>
      _text(en: 'Continue as Guest', ar: 'المتابعة كضيف');

  String get quickActions => _text(en: 'Quick Actions', ar: 'إجراءات سريعة');
  String get atsScore => _text(en: 'ATS Score', ar: 'درجة ATS');
  String get coverLetter => _text(en: 'Cover Letter', ar: 'خطاب تقديم');
  String get createNow => _text(en: 'Create now', ar: 'أنشئ الآن');
  String get coverLetterBuilder =>
      _text(en: 'Cover letter builder', ar: 'منشئ خطاب التقديم');
  String get createNewCv =>
      _text(en: 'Create New CV', ar: 'أنشئ سيرة ذاتية جديدة');
  String get myCvs => _text(en: 'My CVs', ar: 'سيرتي الذاتية');
  String get myCoverLetters =>
      _text(en: 'My Cover Letters', ar: 'خطابات التقديم');
  String get noCoverLettersYet =>
      _text(en: 'No cover letters yet', ar: 'لا توجد خطابات تقديم بعد');
  String get coverLettersEmptyMessage => _text(
    en: 'Create one from Quick Actions to pair with your CV.',
    ar: 'أنشئ واحداً من الإجراءات السريعة لإرفاقه مع سيرتك الذاتية.',
  );
  String get edit => _text(en: 'Edit', ar: 'تعديل');
  String get preview => _text(en: 'Preview', ar: 'معاينة');
  String get download => _text(en: 'Download', ar: 'تنزيل');
  String get share => _text(en: 'Share', ar: 'مشاركة');
  String get cvPreviewPlaceholder => _text(
    en:
        'This is a placeholder preview. The full CV will render here '
        'once the builder is connected.',
    ar: 'هذه معاينة مؤقتة. ستظهر السيرة الذاتية الكاملة هنا عند ربط أداة الإنشاء.',
  );
  String comingSoon(String feature) =>
      _text(en: '$feature - coming soon', ar: '$feature - قريباً');
  String editCv(String name) => _text(en: 'Edit "$name"', ar: 'تعديل "$name"');
  String downloadCv(String name) =>
      _text(en: 'Download "$name"', ar: 'تنزيل "$name"');
  String shareCv(String name) =>
      _text(en: 'Share "$name"', ar: 'مشاركة "$name"');

  String get profileName => _text(en: 'Name', ar: 'الاسم');
  String get profilePosition => _text(en: 'Position', ar: 'المسمى الوظيفي');
  String get profileEmail => _text(en: 'Email', ar: 'البريد الإلكتروني');
  String get profilePhone => _text(en: 'Phone', ar: 'الهاتف');
  String get profileLocation => _text(en: 'Location', ar: 'الموقع');
  String get dateOfBirth => _text(en: 'Date of Birth', ar: 'تاريخ الميلاد');
  String get notSet => _text(en: 'Not set', ar: 'غير محدد');
  String get save => _text(en: 'Save', ar: 'حفظ');
  String get cancel => _text(en: 'Cancel', ar: 'إلغاء');
  String get logOut => _text(en: 'Log Out', ar: 'تسجيل الخروج');

  String get personalInfo =>
      _text(en: 'Personal Info', ar: 'المعلومات الشخصية');
  String get changePhoto => _text(en: 'Change Photo', ar: 'تغيير الصورة');
  String get takePhoto => _text(en: 'Take Photo', ar: 'التقاط صورة');
  String get chooseFromGallery =>
      _text(en: 'Choose from Gallery', ar: 'اختيار من المعرض');

  // dart format off
  static const _monthNamesEn = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _monthNamesAr = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];
  static const _monthNamesFullEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  // dart format on

  /// Formats [date] as e.g. "Jan 5, 1990" (or the Arabic equivalent,
  /// with day-before-month order).
  String formatDate(DateTime date) {
    final month = (isArabic ? _monthNamesAr : _monthNamesEn)[date.month - 1];
    return isArabic
        ? '${date.day} $month ${date.year}'
        : '$month ${date.day}, ${date.year}';
  }

  /// Full month names (e.g. "January"), indexed by month - 1 — used by
  /// the CV Builder's month/year picker. Arabic reuses the same names
  /// as [formatDate] (Arabic month names aren't abbreviated).
  List<String> get monthNames => isArabic ? _monthNamesAr : _monthNamesFullEn;

  /// Formats a month/year pair as e.g. "January 2024".
  String formatMonthYear(int month, int year) =>
      '${monthNames[month - 1]} $year';

  String get settingsTitle => _text(en: 'Settings', ar: 'الإعدادات');
  String get language => _text(en: 'Language', ar: 'اللغة');
  String get languageModeDevice =>
      _text(en: 'Use device language', ar: 'استخدام لغة الجهاز');
  String get languageModeEnglish => _text(en: 'English', ar: 'الإنجليزية');
  String get languageModeArabic => _text(en: 'Arabic', ar: 'العربية');
  String get notifications => _text(en: 'Notifications', ar: 'الإشعارات');
  String get privacy => _text(en: 'Privacy', ar: 'الخصوصية');
  String get termsOfService => _text(en: 'Terms of Service', ar: 'شروط الخدمة');
  String get about => _text(en: 'About', ar: 'حول التطبيق');

  String get appearance => _text(en: 'Appearance', ar: 'المظهر');
  String get themeModeAuto => _text(en: 'Auto', ar: 'تلقائي');
  String get themeModeLight => _text(en: 'Light', ar: 'فاتح');
  String get themeModeDark => _text(en: 'Dark', ar: 'داكن');

  String get scoreDescription => _text(
    en: 'How well your resume is likely to pass Applicant Tracking Systems.',
    ar: 'مدى احتمالية اجتياز سيرتك الذاتية لأنظمة تتبع المتقدمين.',
  );
  String get overall => _text(en: 'Overall', ar: 'الإجمالي');
  String get breakdown => _text(en: 'Breakdown', ar: 'التفصيل');
  String get keywordMatch =>
      _text(en: 'Keyword match', ar: 'تطابق الكلمات المفتاحية');
  String get formatting => _text(en: 'Formatting', ar: 'التنسيق');
  String get sectionCompleteness =>
      _text(en: 'Section completeness', ar: 'اكتمال الأقسام');
  String get readability => _text(en: 'Readability', ar: 'سهولة القراءة');

  String get demoUserName => _text(en: 'Alex Morgan', ar: 'أليكس مورغان');
  String get demoUserPosition => _text(en: 'Project Manager', ar: 'مدير مشروع');
  String get demoCvOneName =>
      _text(en: 'Product Manager Resume', ar: 'سيرة مدير منتجات');
  String get demoCvOneSubtitle =>
      _text(en: 'Edited 2 days ago', ar: 'عُدلت قبل يومين');
  String get demoCvTwoName =>
      _text(en: 'Software Engineer CV', ar: 'سيرة مهندس برمجيات');
  String get demoCvTwoSubtitle =>
      _text(en: 'Edited 1 week ago', ar: 'عُدلت قبل أسبوع');
  String get demoCvThreeName =>
      _text(en: 'Marketing Specialist Resume', ar: 'سيرة أخصائي تسويق');
  String get demoCvThreeSubtitle =>
      _text(en: 'Edited 3 weeks ago', ar: 'عُدلت قبل 3 أسابيع');

  // --- CV Builder ---
  String cvStepOf(int step, int total) =>
      _text(en: 'Step $step of $total', ar: 'الخطوة $step من $total');
  String get cvStepPersonalInfoTitle =>
      _text(en: 'Personal Information', ar: 'المعلومات الشخصية');
  String get cvStepSummaryTitle =>
      _text(en: 'Professional Summary', ar: 'الملخص المهني');
  String get cvStepExperienceTitle =>
      _text(en: 'Professional Experience', ar: 'الخبرة المهنية');
  String get cvStepEducationTitle => _text(en: 'Education', ar: 'التعليم');
  String get cvStepSkillsTitle => _text(en: 'Skills', ar: 'المهارات');
  String get cvStepCertificationsTitle =>
      _text(en: 'Certifications & Courses', ar: 'الشهادات والدورات');
  String get cvFinish => _text(en: 'Finish', ar: 'إنهاء');

  String get optional => _text(en: 'Optional', ar: 'اختياري');
  String get fieldRequired =>
      _text(en: 'This field is required', ar: 'هذا الحقل مطلوب');
  String get invalidEmail => _text(
    en: 'Enter a valid email address',
    ar: 'أدخل بريداً إلكترونياً صحيحاً',
  );
  String get yes => _text(en: 'Yes', ar: 'نعم');
  String get no => _text(en: 'No', ar: 'لا');
  String get delete => _text(en: 'Delete', ar: 'حذف');
  String get close => _text(en: 'Close', ar: 'إغلاق');

  String get cvUntitled => _text(en: 'Untitled CV', ar: 'سيرة بدون عنوان');
  String cvDraftProgress(int done, int total) => _text(
    en: 'Draft • $done of $total essentials done',
    ar: 'مسودة • $done من $total أساسيات مكتملة',
  );
  String get cvLeaveTitle =>
      _text(en: 'Save your progress?', ar: 'هل تريد حفظ ما أنجزته؟');
  String get cvLeaveMessage => _text(
    en:
        'You can save what you\'ve entered so far and pick up from the '
        'dashboard later, or discard it.',
    ar:
        'يمكنك حفظ ما أدخلته حتى الآن ومتابعته لاحقاً من لوحة التحكم، أو '
        'تجاهله.',
  );
  String get cvSaveAndExit => _text(en: 'Save & Exit', ar: 'حفظ وخروج');
  String get cvDiscard => _text(en: 'Discard', ar: 'تجاهل');
  String get cvContinueDraft =>
      _text(en: 'Continue your CV', ar: 'أكمل سيرتك الذاتية');
  String get cvEditedJustNow => _text(en: 'Edited just now', ar: 'عُدلت الآن');

  String get cvFirstName => _text(en: 'First Name', ar: 'الاسم الأول');
  String get cvLastName => _text(en: 'Last Name', ar: 'اسم العائلة');
  String get cvEmail => _text(en: 'Email', ar: 'البريد الإلكتروني');
  String get cvPhone => _text(en: 'Phone Number', ar: 'رقم الهاتف');
  String get cvCity => _text(en: 'City', ar: 'المدينة');
  String get cvCountry => _text(en: 'Country', ar: 'الدولة');
  String get cvNationality => _text(en: 'Nationality', ar: 'الجنسية');
  String get cvDrivingLicense =>
      _text(en: 'Driving License', ar: 'رخصة القيادة');
  String get cvSelectCountry => _text(en: 'Select Country', ar: 'اختر الدولة');
  String get cvSearchCountry => _text(en: 'Search country', ar: 'ابحث عن دولة');
  String get cvNoCountryFound =>
      _text(en: 'No country found', ar: 'لم يتم العثور على دولة');
  String get cvSelectDate => _text(en: 'Select date', ar: 'اختر التاريخ');

  String get cvSummarySubtitle => _text(
    en:
        'Give recruiters a quick overview of your experience, strengths, '
        'and career goals.',
    ar: 'أعطِ أصحاب العمل نظرة سريعة عن خبرتك ونقاط قوتك وأهدافك المهنية.',
  );
  String get cvSummaryPlaceholder => _text(
    en: 'Write a short summary about your experience and goals...',
    ar: 'اكتب ملخصاً قصيراً عن خبرتك وأهدافك...',
  );
  String get cvImproveWithAi =>
      _text(en: '✨ Improve with AI', ar: '✨ تحسين بالذكاء الاصطناعي');
  String get cvGenerateWithAi =>
      _text(en: '✨ Generate with AI', ar: '✨ إنشاء بالذكاء الاصطناعي');
  String get cvAiComingSoon => _text(
    en: 'AI writing assistance is coming soon',
    ar: 'المساعدة الكتابية بالذكاء الاصطناعي متوفرة قريباً',
  );

  String get cvStepExperienceSubtitle => _text(
    en: 'Add your work experience, starting with your most recent position.',
    ar: 'أضف خبرتك العملية، بدءاً بأحدث منصب.',
  );
  String get cvEmployer =>
      _text(en: 'Employer / Company Name', ar: 'جهة العمل / اسم الشركة');
  String get cvJobTitle => _text(en: 'Job Title', ar: 'المسمى الوظيفي');
  String get cvStartDate => _text(en: 'Start Date', ar: 'تاريخ البدء');
  String get cvEndDate => _text(en: 'End Date', ar: 'تاريخ الانتهاء');
  String get cvLocation => _text(en: 'Location', ar: 'الموقع');
  String get cvDescription => _text(en: 'Description', ar: 'الوصف');
  String get cvDescriptionPlaceholder => _text(
    en: 'Describe your responsibilities, achievements, and impact in this role.',
    ar: 'صف مسؤولياتك وإنجازاتك وتأثيرك في هذا الدور.',
  );
  String get cvCurrentlyWorkHere =>
      _text(en: 'I currently work here', ar: 'أعمل هنا حالياً');
  String get cvPresent => _text(en: 'Present', ar: 'حتى الآن');
  String get cvSelectMonthYear =>
      _text(en: 'Select Month & Year', ar: 'اختر الشهر والسنة');
  String get cvMonth => _text(en: 'Month', ar: 'الشهر');
  String get cvYear => _text(en: 'Year', ar: 'السنة');
  String get cvAddExperienceTitle =>
      _text(en: 'Add Experience', ar: 'إضافة خبرة');
  String get cvEditExperienceTitle =>
      _text(en: 'Edit Experience', ar: 'تعديل الخبرة');
  String get cvAddAnotherExperience =>
      _text(en: 'Add Another Experience', ar: 'إضافة خبرة أخرى');
  String get cvFreshGraduatePrompt => _text(
    en: "I'm a fresh graduate / I don't have work experience yet",
    ar: 'أنا خريج حديث / ليس لدي خبرة عمل بعد',
  );
  String get cvFreshGraduateSupport => _text(
    en:
        'No problem. You can continue and highlight your education, '
        'projects, certifications, and skills instead.',
    ar:
        'لا مشكلة. يمكنك المتابعة وإبراز تعليمك ومشاريعك وشهاداتك ومهاراتك '
        'بدلاً من ذلك.',
  );
  String get cvStepEducationSubtitle => _text(
    en: 'Add your education, starting with your most recent degree.',
    ar: 'أضف مؤهلاتك التعليمية، بدءاً بأحدث شهادة.',
  );
  String get cvInstitution =>
      _text(en: 'School / University', ar: 'المدرسة / الجامعة');
  String get cvDegree => _text(en: 'Degree', ar: 'الدرجة العلمية');
  String get cvFieldOfStudy => _text(en: 'Field of Study', ar: 'التخصص');
  String get cvCurrentlyStudyingHere =>
      _text(en: 'I currently study here', ar: 'أدرس هنا حالياً');
  String get cvAddEducationTitle =>
      _text(en: 'Add Education', ar: 'إضافة تعليم');
  String get cvEditEducationTitle =>
      _text(en: 'Edit Education', ar: 'تعديل التعليم');
  String get cvAddAnotherEducation =>
      _text(en: 'Add Another Education', ar: 'إضافة تعليم آخر');

  String get cvStepSkillsSubtitle => _text(
    en:
        'Select the skills that apply to you, or add your own — these '
        'help recruiters and ATS systems match you to the right roles.',
    ar:
        'اختر المهارات التي تنطبق عليك، أو أضف مهاراتك الخاصة — تساعد '
        'أصحاب العمل وأنظمة تتبع المتقدمين على مطابقتك مع الأدوار المناسبة.',
  );
  String get cvSkillCategorySkills => _text(en: 'Skills', ar: 'المهارات');
  String get cvSkillCategoryTools =>
      _text(en: 'Tools & Software', ar: 'الأدوات والبرامج');
  String get cvSkillCategoryLanguages => _text(en: 'Languages', ar: 'اللغات');
  String get cvAddSkill => _text(en: 'Add', ar: 'إضافة');
  String get cvAddSkillHint => _text(en: 'Add a skill...', ar: 'أضف مهارة...');
  String get cvSkillsOnYourCv =>
      _text(en: 'On Your CV', ar: 'في سيرتك الذاتية');

  String get cvStepCertificationsSubtitle => _text(
    en: 'Add any certifications or courses that strengthen your profile.',
    ar: 'أضف أي شهادات أو دورات تعزز ملفك الشخصي.',
  );
  String get cvCertificationName =>
      _text(en: 'Certification / Course Name', ar: 'اسم الشهادة / الدورة');
  String get cvCertificationIssuer =>
      _text(en: 'Issuing Organization', ar: 'الجهة المانحة');
  String get cvCertificationDate =>
      _text(en: 'Date Completed', ar: 'تاريخ الإتمام');
  String get cvAddCertificationTitle =>
      _text(en: 'Add Certification', ar: 'إضافة شهادة');
  String get cvEditCertificationTitle =>
      _text(en: 'Edit Certification', ar: 'تعديل الشهادة');
  String get cvAddAnotherCertification =>
      _text(en: 'Add Another Certification', ar: 'إضافة شهادة أخرى');

  String get cvCustomSectionCreateTitle =>
      _text(en: 'Add a Section', ar: 'إضافة قسم');
  String get cvCustomSectionCreateSubtitle => _text(
    en:
        'Build your own section — projects, volunteer work, publications, '
        'anything that belongs on this CV.',
    ar:
        'أنشئ قسماً خاصاً بك — مشاريع، عمل تطوعي، منشورات، أي شيء يستحق '
        'الظهور في سيرتك الذاتية.',
  );
  String get cvCustomSectionNameLabel =>
      _text(en: 'Section Name', ar: 'اسم القسم');
  String get cvCustomSectionNameHint =>
      _text(en: 'e.g. Volunteer Work', ar: 'مثال: العمل التطوعي');
  String get cvCustomSectionIncludeDescription =>
      _text(en: 'Include a description', ar: 'تضمين وصف');
  String get cvCustomSectionIncludeDateRange => _text(
    en: 'Include a start & end date',
    ar: 'تضمين تاريخ البدء والانتهاء',
  );
  String get cvCustomSectionCreateAction =>
      _text(en: 'Create Section', ar: 'إنشاء القسم');
  String get cvCustomSectionEntryTitleLabel =>
      _text(en: 'Title', ar: 'العنوان');
  String cvCustomSectionAddEntryTitle(String section) =>
      _text(en: 'Add to $section', ar: 'إضافة إلى $section');
  String cvCustomSectionEditEntryTitle(String section) =>
      _text(en: 'Edit $section Entry', ar: 'تعديل إدخال $section');
  String get cvCustomSectionAddEntry =>
      _text(en: 'Add Entry', ar: 'إضافة إدخال');
  String get cvCurrentlyOngoing =>
      _text(en: 'This is still ongoing', ar: 'ما زال هذا مستمراً');
  String get cvCustomSectionDeleteConfirmTitle =>
      _text(en: 'Delete this section?', ar: 'حذف هذا القسم؟');
  String get cvCustomSectionDeleteConfirmBody => _text(
    en: 'This removes the section and everything in it. This can\'t be undone.',
    ar: 'سيؤدي هذا إلى حذف القسم وكل ما فيه. لا يمكن التراجع عن هذا.',
  );
  String get cvCustomSectionAddSection =>
      _text(en: 'Add a Section', ar: 'إضافة قسم');

  String get cvHubTitle => _text(en: 'Build your CV', ar: 'أنشئ سيرتك الذاتية');
  String cvHubEssentialStepsLeft(int count) => count == 1
      ? _text(en: '1 essential step left', ar: 'خطوة أساسية واحدة متبقية')
      : _text(
          en: '$count essential steps left',
          ar: '$count خطوات أساسية متبقية',
        );
  String get cvHubAllEssentialsDone => _text(
    en: 'All essentials done — ready to finish!',
    ar: 'اكتملت جميع الأساسيات — جاهز للإنهاء!',
  );
  String cvHubSectionsFilled(int filled, int total) => _text(
    en: '$filled of $total sections filled',
    ar: '$filled من $total أقسام مكتملة',
  );
  String cvHubContinueLabel(String section) =>
      _text(en: 'Continue: $section', ar: 'متابعة: $section');
  String get cvHubEssentialHeader =>
      _text(en: 'Essential · Needed to Export', ar: 'أساسي · مطلوب للتصدير');
  String get cvHubOptionalHeader => _text(
    en: 'Optional · Strengthens Your CV',
    ar: 'اختياري · يعزز سيرتك الذاتية',
  );
  String get cvHubFilledIn => _text(en: 'Filled in', ar: 'تم التعبئة');
  String get cvHubNeededBeforeExport =>
      _text(en: 'Needed before export', ar: 'مطلوب قبل التصدير');
  String get cvHubOptionalAddsCredibility =>
      _text(en: 'Optional — adds credibility', ar: 'اختياري — يعزز المصداقية');
  String cvHubEntriesCount(int count) => count == 1
      ? _text(en: '1 entry', ar: 'إدخال واحد')
      : _text(en: '$count entries', ar: '$count إدخالات');
  String cvHubSkillsSelected(int count) => count == 1
      ? _text(en: '1 skill selected', ar: 'مهارة واحدة مختارة')
      : _text(en: '$count skills selected', ar: '$count مهارات مختارة');
  String get cvHubSummaryWritten => _text(en: 'Written', ar: 'تمت الكتابة');
  String get cvHubFinishCv =>
      _text(en: 'Finish CV', ar: 'إنهاء السيرة الذاتية');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'ar';

  @override
  Future<AppLocalizations> load(Locale locale) {
    final resolvedLocale = locale.languageCode == 'ar'
        ? const Locale('ar')
        : const Locale('en');
    return SynchronousFuture(AppLocalizations(resolvedLocale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
