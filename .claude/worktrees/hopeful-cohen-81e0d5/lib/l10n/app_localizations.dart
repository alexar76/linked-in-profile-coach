import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Coach'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Premium LinkedIn profile intelligence'**
  String get appTagline;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get navLinkedIn;

  /// No description provided for @navAiProfile.
  ///
  /// In en, this message translates to:
  /// **'AI Profile'**
  String get navAiProfile;

  /// No description provided for @navCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get navCompare;

  /// No description provided for @navScoring.
  ///
  /// In en, this message translates to:
  /// **'Scoring'**
  String get navScoring;

  /// No description provided for @navTips.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navTips;

  /// No description provided for @navAdmin.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navAdmin;

  /// No description provided for @btnNext.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get btnNext;

  /// No description provided for @btnBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get btnBack;

  /// No description provided for @btnSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get btnSkip;

  /// No description provided for @btnFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get btnFinish;

  /// No description provided for @btnGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get btnGetStarted;

  /// No description provided for @btnAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Run analysis'**
  String get btnAnalyze;

  /// No description provided for @btnScore.
  ///
  /// In en, this message translates to:
  /// **'Score profile'**
  String get btnScore;

  /// No description provided for @btnGenerateAi.
  ///
  /// In en, this message translates to:
  /// **'Generate AI'**
  String get btnGenerateAi;

  /// No description provided for @btnOpenWizard.
  ///
  /// In en, this message translates to:
  /// **'Guided analysis'**
  String get btnOpenWizard;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @btnTest.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get btnTest;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get langRussian;

  /// No description provided for @langSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get langSpanish;

  /// No description provided for @setupWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Profile Coach'**
  String get setupWelcomeTitle;

  /// No description provided for @setupWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A premium workspace to import, refine, and publish your LinkedIn presence.'**
  String get setupWelcomeSubtitle;

  /// No description provided for @setupLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get setupLanguageTitle;

  /// No description provided for @setupLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in Settings.'**
  String get setupLanguageSubtitle;

  /// No description provided for @setupProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your identity'**
  String get setupProfileTitle;

  /// No description provided for @setupProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How you appear in previews and AI drafts.'**
  String get setupProfileSubtitle;

  /// No description provided for @setupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get setupNameLabel;

  /// No description provided for @setupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Alex Morgan'**
  String get setupNameHint;

  /// No description provided for @setupUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn profile URL'**
  String get setupUrlLabel;

  /// No description provided for @setupUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://www.linkedin.com/in/username/'**
  String get setupUrlHint;

  /// No description provided for @setupGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Career focus'**
  String get setupGoalTitle;

  /// No description provided for @setupGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We align headlines, skills, and AI copy to this target.'**
  String get setupGoalSubtitle;

  /// No description provided for @setupRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Target role'**
  String get setupRoleLabel;

  /// No description provided for @setupRoleHint.
  ///
  /// In en, this message translates to:
  /// **'Senior Product Manager'**
  String get setupRoleHint;

  /// No description provided for @setupIndustryLabel.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get setupIndustryLabel;

  /// No description provided for @setupIndustryHint.
  ///
  /// In en, this message translates to:
  /// **'FinTech, SaaS, HealthTech…'**
  String get setupIndustryHint;

  /// No description provided for @setupTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium templates'**
  String get setupTemplateTitle;

  /// No description provided for @setupTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Curated positioning frameworks used by top profiles. Pick one to seed your AI draft.'**
  String get setupTemplateSubtitle;

  /// No description provided for @templateExecutive.
  ///
  /// In en, this message translates to:
  /// **'Executive presence'**
  String get templateExecutive;

  /// No description provided for @templateExecutiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Authority, scale, board-level impact.'**
  String get templateExecutiveDesc;

  /// No description provided for @templateTechLeader.
  ///
  /// In en, this message translates to:
  /// **'Tech leader'**
  String get templateTechLeader;

  /// No description provided for @templateTechLeaderDesc.
  ///
  /// In en, this message translates to:
  /// **'Engineering leadership, delivery, architecture.'**
  String get templateTechLeaderDesc;

  /// No description provided for @templateCreator.
  ///
  /// In en, this message translates to:
  /// **'Creator & brand'**
  String get templateCreator;

  /// No description provided for @templateCreatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Audience, content, personal monopoly.'**
  String get templateCreatorDesc;

  /// No description provided for @templateCareerShift.
  ///
  /// In en, this message translates to:
  /// **'Career pivot'**
  String get templateCareerShift;

  /// No description provided for @templateCareerShiftDesc.
  ///
  /// In en, this message translates to:
  /// **'Transferable skills, narrative bridge.'**
  String get templateCareerShiftDesc;

  /// No description provided for @setupAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI provider'**
  String get setupAiTitle;

  /// No description provided for @setupAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DeepSeek is default. Add your API key or skip to use local templates.'**
  String get setupAiSubtitle;

  /// No description provided for @setupResumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Resume (optional)'**
  String get setupResumeTitle;

  /// No description provided for @setupResumeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a .docx (Word 2007+) to enrich comparisons and AI suggestions. Legacy .doc is not supported.'**
  String get setupResumeSubtitle;

  /// No description provided for @resumeDragDropHint.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop a .docx file here, or use Browse.'**
  String get resumeDragDropHint;

  /// No description provided for @resumeErrorLegacyDoc.
  ///
  /// In en, this message translates to:
  /// **'Legacy Word .doc is not supported. In Word use File → Save As → .docx.'**
  String get resumeErrorLegacyDoc;

  /// No description provided for @resumeErrorUnsupportedExt.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type \"{ext}\". Only .docx is supported.'**
  String resumeErrorUnsupportedExt(String ext);

  /// No description provided for @resumeErrorEmptyDocx.
  ///
  /// In en, this message translates to:
  /// **'The .docx file has no readable text.'**
  String get resumeErrorEmptyDocx;

  /// No description provided for @resumeErrorInvalidDocx.
  ///
  /// In en, this message translates to:
  /// **'Could not read this file as .docx. Check that it is a valid Word document.'**
  String get resumeErrorInvalidDocx;

  /// No description provided for @setupImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import LinkedIn'**
  String get setupImportTitle;

  /// No description provided for @setupImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copy sections from LinkedIn with headers HEADLINE, ABOUT, EXPERIENCE — or import later.'**
  String get setupImportSubtitle;

  /// No description provided for @setupReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re set'**
  String get setupReadyTitle;

  /// No description provided for @setupReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll guide you through a focused analysis — step by step.'**
  String get setupReadySubtitle;

  /// No description provided for @analysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Guided analysis'**
  String get analysisTitle;

  /// No description provided for @analysisStepImport.
  ///
  /// In en, this message translates to:
  /// **'Import profile'**
  String get analysisStepImport;

  /// No description provided for @analysisStepImportDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste your LinkedIn sections or load a JSON export.'**
  String get analysisStepImportDesc;

  /// No description provided for @analysisStepAi.
  ///
  /// In en, this message translates to:
  /// **'Generate AI profile'**
  String get analysisStepAi;

  /// No description provided for @analysisStepAiDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a polished version aligned with your goal and template.'**
  String get analysisStepAiDesc;

  /// No description provided for @analysisStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & compare'**
  String get analysisStepReview;

  /// No description provided for @analysisStepReviewDesc.
  ///
  /// In en, this message translates to:
  /// **'Side-by-side diff and similarity score per section.'**
  String get analysisStepReviewDesc;

  /// No description provided for @analysisStepInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get analysisStepInsights;

  /// No description provided for @analysisStepInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Prioritized recommendations for fill, promotion, and alignment.'**
  String get analysisStepInsightsDesc;

  /// No description provided for @analysisStepPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish plan'**
  String get analysisStepPublish;

  /// No description provided for @analysisStepPublishDesc.
  ///
  /// In en, this message translates to:
  /// **'Copy, open LinkedIn forms, track what\'s done manually.'**
  String get analysisStepPublishDesc;

  /// No description provided for @analysisCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis complete'**
  String get analysisCompleteTitle;

  /// No description provided for @analysisCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your workspace is ready. Keep iterating from the main dashboard.'**
  String get analysisCompleteSubtitle;

  /// No description provided for @premiumBadge.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premiumBadge;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(int current, int total);

  /// No description provided for @snackAnalysisDone.
  ///
  /// In en, this message translates to:
  /// **'Analysis complete'**
  String get snackAnalysisDone;

  /// No description provided for @snackAiDone.
  ///
  /// In en, this message translates to:
  /// **'AI profile generated'**
  String get snackAiDone;

  /// No description provided for @snackSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get snackSaved;

  /// No description provided for @snackImportDone.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get snackImportDone;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completeness, urgent insights, and quick actions.'**
  String get dashboardSubtitle;

  /// No description provided for @statSections.
  ///
  /// In en, this message translates to:
  /// **'Sections filled'**
  String get statSections;

  /// No description provided for @statUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent insights'**
  String get statUrgent;

  /// No description provided for @statTotalTips.
  ///
  /// In en, this message translates to:
  /// **'Total insights'**
  String get statTotalTips;

  /// No description provided for @importLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'Import from clipboard'**
  String get importLinkedIn;

  /// No description provided for @importJson.
  ///
  /// In en, this message translates to:
  /// **'JSON file'**
  String get importJson;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareTitle;

  /// No description provided for @updateLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'Update on LinkedIn'**
  String get updateLinkedIn;

  /// No description provided for @linkedInApiNote.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn does not offer a public write API for personal profiles. Copy AI text and paste in the browser.'**
  String get linkedInApiNote;

  /// No description provided for @adminTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adminTitle;

  /// No description provided for @adminAiSection.
  ///
  /// In en, this message translates to:
  /// **'AI — API'**
  String get adminAiSection;

  /// No description provided for @adminProfileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile & goal'**
  String get adminProfileSection;

  /// No description provided for @adminResumeSection.
  ///
  /// In en, this message translates to:
  /// **'Resume (.docx)'**
  String get adminResumeSection;

  /// No description provided for @restartSetup.
  ///
  /// In en, this message translates to:
  /// **'Run setup wizard again'**
  String get restartSetup;

  /// No description provided for @restartAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Run guided analysis'**
  String get restartAnalysis;

  /// No description provided for @themeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeSectionTitle;

  /// No description provided for @themeSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark, light, and blush palettes — switch anytime.'**
  String get themeSectionSubtitle;

  /// No description provided for @themeGroupDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeGroupDark;

  /// No description provided for @themeGroupLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeGroupLight;

  /// No description provided for @themeGroupPink.
  ///
  /// In en, this message translates to:
  /// **'Blush & pink'**
  String get themeGroupPink;

  /// No description provided for @themeDarkGold.
  ///
  /// In en, this message translates to:
  /// **'Midnight Gold'**
  String get themeDarkGold;

  /// No description provided for @themeDarkOcean.
  ///
  /// In en, this message translates to:
  /// **'Deep Ocean'**
  String get themeDarkOcean;

  /// No description provided for @themeDarkPlum.
  ///
  /// In en, this message translates to:
  /// **'Royal Plum'**
  String get themeDarkPlum;

  /// No description provided for @themeLightIvory.
  ///
  /// In en, this message translates to:
  /// **'Ivory Pro'**
  String get themeLightIvory;

  /// No description provided for @themeLightCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud Blue'**
  String get themeLightCloud;

  /// No description provided for @themeLightSage.
  ///
  /// In en, this message translates to:
  /// **'Soft Sage'**
  String get themeLightSage;

  /// No description provided for @themeLightPearl.
  ///
  /// In en, this message translates to:
  /// **'Pearl Gray'**
  String get themeLightPearl;

  /// No description provided for @themeLightSand.
  ///
  /// In en, this message translates to:
  /// **'Warm Sand'**
  String get themeLightSand;

  /// No description provided for @themeLightMint.
  ///
  /// In en, this message translates to:
  /// **'Fresh Mint'**
  String get themeLightMint;

  /// No description provided for @themeLightAmber.
  ///
  /// In en, this message translates to:
  /// **'Golden Amber'**
  String get themeLightAmber;

  /// No description provided for @themePinkRose.
  ///
  /// In en, this message translates to:
  /// **'Rose Quartz'**
  String get themePinkRose;

  /// No description provided for @themePinkBlush.
  ///
  /// In en, this message translates to:
  /// **'Blush Petal'**
  String get themePinkBlush;

  /// No description provided for @themePinkLilac.
  ///
  /// In en, this message translates to:
  /// **'Lilac Dream'**
  String get themePinkLilac;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get btnImport;

  /// No description provided for @btnUploadResume.
  ///
  /// In en, this message translates to:
  /// **'Upload .docx'**
  String get btnUploadResume;

  /// No description provided for @btnReplaceResume.
  ///
  /// In en, this message translates to:
  /// **'Replace resume'**
  String get btnReplaceResume;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(String error);

  /// No description provided for @importParseFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not parse sections. Use headers: HEADLINE, ABOUT, EXPERIENCE…'**
  String get importParseFailed;

  /// No description provided for @importSectionsImported.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} sections'**
  String importSectionsImported(int count);

  /// No description provided for @previewNotGenerated.
  ///
  /// In en, this message translates to:
  /// **'— Not generated yet —'**
  String get previewNotGenerated;

  /// No description provided for @previewNotImported.
  ///
  /// In en, this message translates to:
  /// **'— Not imported —'**
  String get previewNotImported;

  /// No description provided for @previewYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get previewYourName;

  /// No description provided for @previewImportMeta.
  ///
  /// In en, this message translates to:
  /// **'{count} sections • {date}'**
  String previewImportMeta(int count, String date);

  /// No description provided for @previewSyncedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Marked as applied on LinkedIn'**
  String get previewSyncedTooltip;

  /// No description provided for @previewChangedLabel.
  ///
  /// In en, this message translates to:
  /// **'changed'**
  String get previewChangedLabel;

  /// No description provided for @dashboardHowTo.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get dashboardHowTo;

  /// No description provided for @dashboardStep1.
  ///
  /// In en, this message translates to:
  /// **'Open LinkedIn and copy each profile section'**
  String get dashboardStep1;

  /// No description provided for @dashboardStep2.
  ///
  /// In en, this message translates to:
  /// **'Paste on the LinkedIn tab or use clipboard import'**
  String get dashboardStep2;

  /// No description provided for @dashboardStep3.
  ///
  /// In en, this message translates to:
  /// **'Upload a .docx resume in Settings (optional)'**
  String get dashboardStep3;

  /// No description provided for @dashboardStep4.
  ///
  /// In en, this message translates to:
  /// **'Run analysis for section-by-section insights'**
  String get dashboardStep4;

  /// No description provided for @adminResumeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded: {date}'**
  String adminResumeLoaded(String date);

  /// No description provided for @adminResumePreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Text preview:'**
  String get adminResumePreviewLabel;

  /// No description provided for @adminPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'The app does not connect to LinkedIn directly (platform limits). Copy sections manually — safer for your account.'**
  String get adminPrivacyNote;

  /// No description provided for @adminResumeUploaded.
  ///
  /// In en, this message translates to:
  /// **'Resume uploaded: {filename}'**
  String adminResumeUploaded(String filename);

  /// No description provided for @importDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import from LinkedIn'**
  String get importDialogTitle;

  /// No description provided for @importDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Copy profile sections from LinkedIn and paste below. Use section headers:'**
  String get importDialogBody;

  /// No description provided for @importDialogPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Paste profile text…'**
  String get importDialogPlaceholder;

  /// No description provided for @importFormatExample.
  ///
  /// In en, this message translates to:
  /// **'HEADLINE:\n...\n\nABOUT:\n...\n\nEXPERIENCE:\n...\n\nSKILLS:\n...\n\nLANGUAGES:\n...'**
  String get importFormatExample;

  /// No description provided for @setupImportPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste with HEADLINE, ABOUT, EXPERIENCE headers — or skip and import later.'**
  String get setupImportPasteHint;

  /// No description provided for @aiConnectionOkTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection OK'**
  String get aiConnectionOkTitle;

  /// No description provided for @aiConnectionReply.
  ///
  /// In en, this message translates to:
  /// **'Reply: {reply}'**
  String aiConnectionReply(String reply);

  /// No description provided for @btnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// No description provided for @aiProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'AI profile'**
  String get aiProfileTitle;

  /// No description provided for @aiProfileSectionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sections'**
  String aiProfileSectionsCount(int count);

  /// No description provided for @aiProfileDiffCount.
  ///
  /// In en, this message translates to:
  /// **'{count} diffs'**
  String aiProfileDiffCount(int count);

  /// No description provided for @aiProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Via LLM (DeepSeek, etc.) or local templates if the API fails'**
  String get aiProfileSubtitle;

  /// No description provided for @aiProfileEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'AI version not created yet'**
  String get aiProfileEmptyTitle;

  /// No description provided for @aiProfileEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap Generate AI in the toolbar'**
  String get aiProfileEmptyHint;

  /// No description provided for @aiSectionEditLabel.
  ///
  /// In en, this message translates to:
  /// **'AI version text'**
  String get aiSectionEditLabel;

  /// No description provided for @aiSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DeepSeek by default. On API errors — local templates.'**
  String get aiSettingsSubtitle;

  /// No description provided for @aiProviderLabel.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get aiProviderLabel;

  /// No description provided for @aiApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get aiApiKeyLabel;

  /// No description provided for @aiApiKeyStored.
  ///
  /// In en, this message translates to:
  /// **'Provider key'**
  String get aiApiKeyStored;

  /// No description provided for @aiModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get aiModelLabel;

  /// No description provided for @aiResetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset URL/model'**
  String get aiResetDefaults;

  /// No description provided for @aiProviderOpenAiHint.
  ///
  /// In en, this message translates to:
  /// **'OpenAI: platform.openai.com — /v1/chat/completions'**
  String get aiProviderOpenAiHint;

  /// No description provided for @aiProviderCompatibleHint.
  ///
  /// In en, this message translates to:
  /// **'Any OpenAI-compatible endpoint (Together, Groq, local proxy…)'**
  String get aiProviderCompatibleHint;

  /// No description provided for @aiProviderAnthropicHint.
  ///
  /// In en, this message translates to:
  /// **'Anthropic: console.anthropic.com — separate API'**
  String get aiProviderAnthropicHint;

  /// No description provided for @aiProviderLmRouterHint.
  ///
  /// In en, this message translates to:
  /// **'LM Router: base URL from service docs'**
  String get aiProviderLmRouterHint;

  /// No description provided for @aiProviderOllamaHint.
  ///
  /// In en, this message translates to:
  /// **'Ollama: localhost:11434 — no API key required'**
  String get aiProviderOllamaHint;

  /// No description provided for @analysisImportNow.
  ///
  /// In en, this message translates to:
  /// **'Import from clipboard'**
  String get analysisImportNow;

  /// No description provided for @linkedinSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn — imported profile'**
  String get linkedinSourceTitle;

  /// No description provided for @linkedinSectionsMeta.
  ///
  /// In en, this message translates to:
  /// **'{filled} / {total} sections imported'**
  String linkedinSectionsMeta(int filled, int total);

  /// No description provided for @linkedinSectionEditLabel.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn section text'**
  String get linkedinSectionEditLabel;

  /// No description provided for @aiLlmToggle.
  ///
  /// In en, this message translates to:
  /// **'LLM'**
  String get aiLlmToggle;

  /// No description provided for @aiBaseUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get aiBaseUrlLabel;

  /// No description provided for @aiProviderOpenAiCompatible.
  ///
  /// In en, this message translates to:
  /// **'OpenAI-compatible'**
  String get aiProviderOpenAiCompatible;

  /// No description provided for @aiProviderOllama.
  ///
  /// In en, this message translates to:
  /// **'Ollama (local)'**
  String get aiProviderOllama;

  /// No description provided for @aiProviderCompatibleEndpointHint.
  ///
  /// In en, this message translates to:
  /// **'Any endpoint with /chat/completions'**
  String get aiProviderCompatibleEndpointHint;

  /// No description provided for @aiProviderLmRouterEndpointHint.
  ///
  /// In en, this message translates to:
  /// **'Set your base URL if it differs'**
  String get aiProviderLmRouterEndpointHint;

  /// No description provided for @aiProviderOllamaServeHint.
  ///
  /// In en, this message translates to:
  /// **'Run: ollama serve'**
  String get aiProviderOllamaServeHint;

  /// No description provided for @aiProviderDeepseekSetupHint.
  ///
  /// In en, this message translates to:
  /// **'DeepSeek: platform.deepseek.com → API Keys. Endpoint: api.deepseek.com'**
  String get aiProviderDeepseekSetupHint;

  /// No description provided for @aiGenLocalFallback.
  ///
  /// In en, this message translates to:
  /// **'LLM disabled or no API key — using local templates'**
  String get aiGenLocalFallback;

  /// No description provided for @aiGenViaProvider.
  ///
  /// In en, this message translates to:
  /// **'Generated via {provider}'**
  String aiGenViaProvider(String provider);

  /// No description provided for @aiGenLlmErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'LLM error ({error}) — local templates used'**
  String aiGenLlmErrorFallback(String error);

  /// No description provided for @compareEmptyLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'— empty —'**
  String get compareEmptyLinkedIn;

  /// No description provided for @compareEmptyAi.
  ///
  /// In en, this message translates to:
  /// **'— not generated —'**
  String get compareEmptyAi;

  /// No description provided for @compareSectionsWithDiff.
  ///
  /// In en, this message translates to:
  /// **'{count} sections with differences'**
  String compareSectionsWithDiff(int count);

  /// No description provided for @compareSideBySide.
  ///
  /// In en, this message translates to:
  /// **'Side by side'**
  String get compareSideBySide;

  /// No description provided for @compareDiffMode.
  ///
  /// In en, this message translates to:
  /// **'Diff'**
  String get compareDiffMode;

  /// No description provided for @compareSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get compareSectionLabel;

  /// No description provided for @compareLinkedInColumn.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn (import)'**
  String get compareLinkedInColumn;

  /// No description provided for @compareAiColumn.
  ///
  /// In en, this message translates to:
  /// **'AI version'**
  String get compareAiColumn;

  /// No description provided for @diffRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get diffRemoved;

  /// No description provided for @diffAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get diffAdded;

  /// No description provided for @diffSimilarity.
  ///
  /// In en, this message translates to:
  /// **'Similarity: {percent}%'**
  String diffSimilarity(String percent);

  /// No description provided for @publishSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Update LinkedIn profile'**
  String get publishSheetTitle;

  /// No description provided for @publishChangedCount.
  ///
  /// In en, this message translates to:
  /// **'Changed sections: {count}'**
  String publishChangedCount(int count);

  /// No description provided for @publishHasChanges.
  ///
  /// In en, this message translates to:
  /// **'has changes'**
  String get publishHasChanges;

  /// No description provided for @publishCopyAi.
  ///
  /// In en, this message translates to:
  /// **'Copy AI text'**
  String get publishCopyAi;

  /// No description provided for @publishOpenLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'Open in LinkedIn'**
  String get publishOpenLinkedIn;

  /// No description provided for @publishMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get publishMarkDone;

  /// No description provided for @publishCopiedSection.
  ///
  /// In en, this message translates to:
  /// **'Copied: {title}'**
  String publishCopiedSection(String title);

  /// No description provided for @publishBrowserFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open browser'**
  String get publishBrowserFailed;

  /// No description provided for @publishCapabilityCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy only + paste manually'**
  String get publishCapabilityCopy;

  /// No description provided for @publishCapabilityBrowser.
  ///
  /// In en, this message translates to:
  /// **'Copy → open form → paste'**
  String get publishCapabilityBrowser;

  /// No description provided for @publishCapabilityManual.
  ///
  /// In en, this message translates to:
  /// **'Manual update in LinkedIn UI only'**
  String get publishCapabilityManual;

  /// No description provided for @publishNoteHeadline.
  ///
  /// In en, this message translates to:
  /// **'Paste the headline in the Headline field on the Intro page.'**
  String get publishNoteHeadline;

  /// No description provided for @publishNoteAbout.
  ///
  /// In en, this message translates to:
  /// **'About text is in the same Intro section, Summary field.'**
  String get publishNoteAbout;

  /// No description provided for @publishNoteExperience.
  ///
  /// In en, this message translates to:
  /// **'Add or edit each position separately.'**
  String get publishNoteExperience;

  /// No description provided for @publishNoteEducation.
  ///
  /// In en, this message translates to:
  /// **'Enter schools and years.'**
  String get publishNoteEducation;

  /// No description provided for @publishNoteSkills.
  ///
  /// In en, this message translates to:
  /// **'Add skills manually; endorsements are separate.'**
  String get publishNoteSkills;

  /// No description provided for @publishNoteCertifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications are added one by one.'**
  String get publishNoteCertifications;

  /// No description provided for @publishNoteProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects and links go in the Projects section.'**
  String get publishNoteProjects;

  /// No description provided for @publishNoteFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured: pin a post or link via Add profile section.'**
  String get publishNoteFeatured;

  /// No description provided for @publishNoteVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer experience uses a separate form.'**
  String get publishNoteVolunteer;

  /// No description provided for @publishNoteRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations are requested from others — you cannot paste text yourself.'**
  String get publishNoteRecommendations;

  /// No description provided for @publishNoteGeneral.
  ///
  /// In en, this message translates to:
  /// **'Open your profile and paste text into the right section.'**
  String get publishNoteGeneral;

  /// No description provided for @sectionEditDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Section text'**
  String get sectionEditDefaultLabel;

  /// No description provided for @sectionEditPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get sectionEditPaste;

  /// No description provided for @sectionEditHintPrefix.
  ///
  /// In en, this message translates to:
  /// **'Tip:'**
  String get sectionEditHintPrefix;

  /// No description provided for @sectionCharCount.
  ///
  /// In en, this message translates to:
  /// **'{count} characters'**
  String sectionCharCount(int count);

  /// No description provided for @recommendationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recommendations yet'**
  String get recommendationsEmpty;

  /// No description provided for @recommendationsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap Run analysis in the toolbar — this builds rule-based tips for each section.'**
  String get recommendationsEmptyHint;

  /// No description provided for @recommendationsEmptyScoringHint.
  ///
  /// In en, this message translates to:
  /// **'Recruiter-style advice from Score profile appears on the Scoring tab, not here.'**
  String get recommendationsEmptyScoringHint;

  /// No description provided for @filterAllSections.
  ///
  /// In en, this message translates to:
  /// **'All sections'**
  String get filterAllSections;

  /// No description provided for @filterGeneralPromotion.
  ///
  /// In en, this message translates to:
  /// **'General / promotion'**
  String get filterGeneralPromotion;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @categoryFill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get categoryFill;

  /// No description provided for @categoryPromote.
  ///
  /// In en, this message translates to:
  /// **'Promote'**
  String get categoryPromote;

  /// No description provided for @categoryAlign.
  ///
  /// In en, this message translates to:
  /// **'Align'**
  String get categoryAlign;

  /// No description provided for @sectionHeadlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Headline'**
  String get sectionHeadlineTitle;

  /// No description provided for @sectionHeadlineDescription.
  ///
  /// In en, this message translates to:
  /// **'The first line under your name — visible to recruiters in search and feed.'**
  String get sectionHeadlineDescription;

  /// No description provided for @sectionHeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Senior Flutter Developer | FinTech | Remote'**
  String get sectionHeadlineHint;

  /// No description provided for @sectionAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAboutTitle;

  /// No description provided for @sectionAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Short story, value proposition, specialty, and call to action.'**
  String get sectionAboutDescription;

  /// No description provided for @sectionAboutHint.
  ///
  /// In en, this message translates to:
  /// **'2–4 paragraphs: who you are, how you help, what sets you apart, how to reach you.'**
  String get sectionAboutHint;

  /// No description provided for @sectionExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get sectionExperienceTitle;

  /// No description provided for @sectionExperienceDescription.
  ///
  /// In en, this message translates to:
  /// **'Roles, companies, dates, and achievements with numbers.'**
  String get sectionExperienceDescription;

  /// No description provided for @sectionExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'Each role: context → actions → outcome (metrics).'**
  String get sectionExperienceHint;

  /// No description provided for @sectionEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get sectionEducationTitle;

  /// No description provided for @sectionEducationDescription.
  ///
  /// In en, this message translates to:
  /// **'Schools, degrees, years, relevant courses.'**
  String get sectionEducationDescription;

  /// No description provided for @sectionEducationHint.
  ///
  /// In en, this message translates to:
  /// **'Include major and activities if they strengthen your profile.'**
  String get sectionEducationHint;

  /// No description provided for @sectionSkillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get sectionSkillsTitle;

  /// No description provided for @sectionSkillsDescription.
  ///
  /// In en, this message translates to:
  /// **'Key skills for search and credibility.'**
  String get sectionSkillsDescription;

  /// No description provided for @sectionSkillsHint.
  ///
  /// In en, this message translates to:
  /// **'Comma or line-separated: Flutter, Dart, SQLite, …'**
  String get sectionSkillsHint;

  /// No description provided for @sectionCertificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get sectionCertificationsTitle;

  /// No description provided for @sectionCertificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Official courses and exams that build trust.'**
  String get sectionCertificationsDescription;

  /// No description provided for @sectionCertificationsHint.
  ///
  /// In en, this message translates to:
  /// **'Name | Organization | Year'**
  String get sectionCertificationsHint;

  /// No description provided for @sectionProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get sectionProjectsTitle;

  /// No description provided for @sectionProjectsDescription.
  ///
  /// In en, this message translates to:
  /// **'Public cases, pet projects, open source.'**
  String get sectionProjectsDescription;

  /// No description provided for @sectionProjectsHint.
  ///
  /// In en, this message translates to:
  /// **'Name — role — stack — outcome/link'**
  String get sectionProjectsHint;

  /// No description provided for @sectionFeaturedTitle.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get sectionFeaturedTitle;

  /// No description provided for @sectionFeaturedDescription.
  ///
  /// In en, this message translates to:
  /// **'Articles, posts, portfolio — what you want shown first.'**
  String get sectionFeaturedDescription;

  /// No description provided for @sectionFeaturedHint.
  ///
  /// In en, this message translates to:
  /// **'Links or descriptions for featured items'**
  String get sectionFeaturedHint;

  /// No description provided for @sectionVolunteerTitle.
  ///
  /// In en, this message translates to:
  /// **'Volunteering'**
  String get sectionVolunteerTitle;

  /// No description provided for @sectionVolunteerDescription.
  ///
  /// In en, this message translates to:
  /// **'Non-profit experience if relevant to your goal.'**
  String get sectionVolunteerDescription;

  /// No description provided for @sectionVolunteerHint.
  ///
  /// In en, this message translates to:
  /// **'Organization — role — period — impact'**
  String get sectionVolunteerHint;

  /// No description provided for @sectionRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get sectionRecommendationsTitle;

  /// No description provided for @sectionRecommendationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Colleague endorsements — social proof.'**
  String get sectionRecommendationsDescription;

  /// No description provided for @sectionRecommendationsHint.
  ///
  /// In en, this message translates to:
  /// **'Who to ask and which themes to cover'**
  String get sectionRecommendationsHint;

  /// No description provided for @sectionLocationIndustryTitle.
  ///
  /// In en, this message translates to:
  /// **'Location & industry'**
  String get sectionLocationIndustryTitle;

  /// No description provided for @sectionLocationIndustryDescription.
  ///
  /// In en, this message translates to:
  /// **'Where you are based and your industry — visible on the intro card.'**
  String get sectionLocationIndustryDescription;

  /// No description provided for @sectionLocationIndustryHint.
  ///
  /// In en, this message translates to:
  /// **'City, country · Industry name'**
  String get sectionLocationIndustryHint;

  /// No description provided for @sectionContactLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact & links'**
  String get sectionContactLinksTitle;

  /// No description provided for @sectionContactLinksDescription.
  ///
  /// In en, this message translates to:
  /// **'Websites, portfolio, email, and social links.'**
  String get sectionContactLinksDescription;

  /// No description provided for @sectionContactLinksHint.
  ///
  /// In en, this message translates to:
  /// **'One link per line with label'**
  String get sectionContactLinksHint;

  /// No description provided for @sectionOpenToWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Open to work'**
  String get sectionOpenToWorkTitle;

  /// No description provided for @sectionOpenToWorkDescription.
  ///
  /// In en, this message translates to:
  /// **'Job-seeker preferences and visibility to recruiters.'**
  String get sectionOpenToWorkDescription;

  /// No description provided for @sectionOpenToWorkHint.
  ///
  /// In en, this message translates to:
  /// **'Roles, locations, start date, remote/hybrid'**
  String get sectionOpenToWorkHint;

  /// No description provided for @sectionLanguagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get sectionLanguagesTitle;

  /// No description provided for @sectionLanguagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Languages you speak and proficiency level.'**
  String get sectionLanguagesDescription;

  /// No description provided for @sectionLanguagesHint.
  ///
  /// In en, this message translates to:
  /// **'English — Full professional proficiency'**
  String get sectionLanguagesHint;

  /// No description provided for @sectionHonorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Honors & awards'**
  String get sectionHonorsTitle;

  /// No description provided for @sectionHonorsDescription.
  ///
  /// In en, this message translates to:
  /// **'Awards, prizes, and formal recognition.'**
  String get sectionHonorsDescription;

  /// No description provided for @sectionHonorsHint.
  ///
  /// In en, this message translates to:
  /// **'Title — issuer — year'**
  String get sectionHonorsHint;

  /// No description provided for @sectionPublicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get sectionPublicationsTitle;

  /// No description provided for @sectionPublicationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Articles, papers, and books.'**
  String get sectionPublicationsDescription;

  /// No description provided for @sectionPublicationsHint.
  ///
  /// In en, this message translates to:
  /// **'Title — publisher — date — link'**
  String get sectionPublicationsHint;

  /// No description provided for @sectionPatentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patents'**
  String get sectionPatentsTitle;

  /// No description provided for @sectionPatentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Patents you hold or co-invented.'**
  String get sectionPatentsDescription;

  /// No description provided for @sectionPatentsHint.
  ///
  /// In en, this message translates to:
  /// **'Title — patent office — number — year'**
  String get sectionPatentsHint;

  /// No description provided for @sectionCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get sectionCoursesTitle;

  /// No description provided for @sectionCoursesDescription.
  ///
  /// In en, this message translates to:
  /// **'Training and courses beyond formal degrees.'**
  String get sectionCoursesDescription;

  /// No description provided for @sectionCoursesHint.
  ///
  /// In en, this message translates to:
  /// **'Course — provider — year'**
  String get sectionCoursesHint;

  /// No description provided for @sectionOrganizationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get sectionOrganizationsTitle;

  /// No description provided for @sectionOrganizationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Memberships in professional associations.'**
  String get sectionOrganizationsDescription;

  /// No description provided for @sectionOrganizationsHint.
  ///
  /// In en, this message translates to:
  /// **'Organization — role — years'**
  String get sectionOrganizationsHint;

  /// No description provided for @sectionServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get sectionServicesTitle;

  /// No description provided for @sectionServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Services you offer (freelance / consulting).'**
  String get sectionServicesDescription;

  /// No description provided for @sectionServicesHint.
  ///
  /// In en, this message translates to:
  /// **'Service name — description'**
  String get sectionServicesHint;

  /// No description provided for @sectionCausesTitle.
  ///
  /// In en, this message translates to:
  /// **'Causes'**
  String get sectionCausesTitle;

  /// No description provided for @sectionCausesDescription.
  ///
  /// In en, this message translates to:
  /// **'Causes you care about on your profile.'**
  String get sectionCausesDescription;

  /// No description provided for @sectionCausesHint.
  ///
  /// In en, this message translates to:
  /// **'List causes or short note'**
  String get sectionCausesHint;

  /// No description provided for @sectionRecommendationsGivenTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendations given'**
  String get sectionRecommendationsGivenTitle;

  /// No description provided for @sectionRecommendationsGivenDescription.
  ///
  /// In en, this message translates to:
  /// **'Recommendations you wrote for others.'**
  String get sectionRecommendationsGivenDescription;

  /// No description provided for @sectionRecommendationsGivenHint.
  ///
  /// In en, this message translates to:
  /// **'Name — relationship — excerpt'**
  String get sectionRecommendationsGivenHint;

  /// No description provided for @sectionActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get sectionActivityTitle;

  /// No description provided for @sectionActivityDescription.
  ///
  /// In en, this message translates to:
  /// **'Recent posts and shares — your public voice.'**
  String get sectionActivityDescription;

  /// No description provided for @sectionActivityHint.
  ///
  /// In en, this message translates to:
  /// **'Paste recent post titles or excerpts'**
  String get sectionActivityHint;

  /// No description provided for @sectionCreatorNewsletterTitle.
  ///
  /// In en, this message translates to:
  /// **'Creator & newsletter'**
  String get sectionCreatorNewsletterTitle;

  /// No description provided for @sectionCreatorNewsletterDescription.
  ///
  /// In en, this message translates to:
  /// **'Newsletter or creator mode content.'**
  String get sectionCreatorNewsletterDescription;

  /// No description provided for @sectionCreatorNewsletterHint.
  ///
  /// In en, this message translates to:
  /// **'Newsletter name — topic — link'**
  String get sectionCreatorNewsletterHint;

  /// No description provided for @publishNoteLocationIndustry.
  ///
  /// In en, this message translates to:
  /// **'Location and industry are on the Intro edit page.'**
  String get publishNoteLocationIndustry;

  /// No description provided for @publishNoteContactLinks.
  ///
  /// In en, this message translates to:
  /// **'Add websites and contact info on Intro or Contact info.'**
  String get publishNoteContactLinks;

  /// No description provided for @publishNoteOpenToWork.
  ///
  /// In en, this message translates to:
  /// **'Set job preferences via Jobs → Open to work.'**
  String get publishNoteOpenToWork;

  /// No description provided for @publishNoteLanguages.
  ///
  /// In en, this message translates to:
  /// **'Add each language with proficiency in Languages.'**
  String get publishNoteLanguages;

  /// No description provided for @publishNoteHonors.
  ///
  /// In en, this message translates to:
  /// **'Honors are added one by one in Honors & awards.'**
  String get publishNoteHonors;

  /// No description provided for @publishNotePublications.
  ///
  /// In en, this message translates to:
  /// **'Add publications individually with links.'**
  String get publishNotePublications;

  /// No description provided for @publishNotePatents.
  ///
  /// In en, this message translates to:
  /// **'Patents are added one by one in Patents.'**
  String get publishNotePatents;

  /// No description provided for @publishNoteCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses go in the Courses section.'**
  String get publishNoteCourses;

  /// No description provided for @publishNoteOrganizations.
  ///
  /// In en, this message translates to:
  /// **'Organizations are added separately.'**
  String get publishNoteOrganizations;

  /// No description provided for @publishNoteServices.
  ///
  /// In en, this message translates to:
  /// **'Services use the Services profile section.'**
  String get publishNoteServices;

  /// No description provided for @publishNoteCauses.
  ///
  /// In en, this message translates to:
  /// **'Select causes via Add profile section → Causes.'**
  String get publishNoteCauses;

  /// No description provided for @publishNoteRecommendationsGiven.
  ///
  /// In en, this message translates to:
  /// **'Recommendations you gave are not editable as bulk text.'**
  String get publishNoteRecommendationsGiven;

  /// No description provided for @publishNoteActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity is your feed — create or edit posts on LinkedIn.'**
  String get publishNoteActivity;

  /// No description provided for @publishNoteCreatorNewsletter.
  ///
  /// In en, this message translates to:
  /// **'Newsletter settings are in Creator mode / Pages.'**
  String get publishNoteCreatorNewsletter;

  /// No description provided for @importFromProfileUrl.
  ///
  /// In en, this message translates to:
  /// **'Import from profile URL'**
  String get importFromProfileUrl;

  /// No description provided for @importLinkedInExport.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn data export'**
  String get importLinkedInExport;

  /// No description provided for @importLinkedInExportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Upload ZIP or JSON from Settings → Data privacy → Get a copy of your data'**
  String get importLinkedInExportTooltip;

  /// No description provided for @refreshLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'Refresh from LinkedIn'**
  String get refreshLinkedIn;

  /// No description provided for @refreshLinkedInTooltip.
  ///
  /// In en, this message translates to:
  /// **'Re-import from watch folder, last export file, or profile URL'**
  String get refreshLinkedInTooltip;

  /// No description provided for @refreshLinkedInNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing new found. Set watch folder or export path in Settings, or import manually.'**
  String get refreshLinkedInNothing;

  /// No description provided for @importUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Profile is already up to date for imported sections.'**
  String get importUpToDate;

  /// No description provided for @importMergeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Import cancelled.'**
  String get importMergeCancelled;

  /// No description provided for @importMergeTitle.
  ///
  /// In en, this message translates to:
  /// **'Review changes'**
  String get importMergeTitle;

  /// No description provided for @importMergeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Source: {source} · {count} sections changed'**
  String importMergeSubtitle(String source, int count);

  /// No description provided for @importMergeSelectChanged.
  ///
  /// In en, this message translates to:
  /// **'Changed only'**
  String get importMergeSelectChanged;

  /// No description provided for @importMergeSelectAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get importMergeSelectAll;

  /// No description provided for @importMergeSelectNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get importMergeSelectNone;

  /// No description provided for @importMergePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get importMergePreview;

  /// No description provided for @importMergeApply.
  ///
  /// In en, this message translates to:
  /// **'Apply selected'**
  String get importMergeApply;

  /// No description provided for @importMergeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get importMergeCurrent;

  /// No description provided for @importMergeIncoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get importMergeIncoming;

  /// No description provided for @importMergeStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New section'**
  String get importMergeStatusNew;

  /// No description provided for @importMergeStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get importMergeStatusChanged;

  /// No description provided for @importMergeStatusUnchanged.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get importMergeStatusUnchanged;

  /// No description provided for @snapshotsTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get snapshotsTitle;

  /// No description provided for @snapshotsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Snapshots are created automatically before each import.'**
  String get snapshotsEmpty;

  /// No description provided for @snapshotRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get snapshotRestore;

  /// No description provided for @snapshotRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore snapshot?'**
  String get snapshotRestoreTitle;

  /// No description provided for @snapshotRestoreBody.
  ///
  /// In en, this message translates to:
  /// **'Current profile content will be replaced. A backup snapshot is saved first.'**
  String get snapshotRestoreBody;

  /// No description provided for @snapshotRestoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get snapshotRestoreConfirm;

  /// No description provided for @snapshotRestored.
  ///
  /// In en, this message translates to:
  /// **'Snapshot restored.'**
  String get snapshotRestored;

  /// No description provided for @atsMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'ATS keyword match'**
  String get atsMatchTitle;

  /// No description provided for @atsMatchScore.
  ///
  /// In en, this message translates to:
  /// **'Match score: {percent}%'**
  String atsMatchScore(int percent);

  /// No description provided for @atsMatchMissing.
  ///
  /// In en, this message translates to:
  /// **'Consider adding: {keywords}'**
  String atsMatchMissing(String keywords);

  /// No description provided for @importReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Last LinkedIn import was {days} days ago. Refresh to keep insights accurate.'**
  String importReminderBody(int days);

  /// No description provided for @importReminderSnooze.
  ///
  /// In en, this message translates to:
  /// **'Remind in 7 days'**
  String get importReminderSnooze;

  /// No description provided for @syncSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn sync'**
  String get syncSettingsTitle;

  /// No description provided for @syncSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch folder auto-imports newest ZIP/JSON. Refresh uses folder → last file → profile URL.'**
  String get syncSettingsSubtitle;

  /// No description provided for @lastExportPath.
  ///
  /// In en, this message translates to:
  /// **'Last export: {path}'**
  String lastExportPath(String path);

  /// No description provided for @watchFolderNotSet.
  ///
  /// In en, this message translates to:
  /// **'Watch folder: not set'**
  String get watchFolderNotSet;

  /// No description provided for @watchFolderPath.
  ///
  /// In en, this message translates to:
  /// **'Watch folder: {path}'**
  String watchFolderPath(String path);

  /// No description provided for @watchFolderPick.
  ///
  /// In en, this message translates to:
  /// **'Choose watch folder'**
  String get watchFolderPick;

  /// No description provided for @watchFolderSet.
  ///
  /// In en, this message translates to:
  /// **'Watch folder saved.'**
  String get watchFolderSet;

  /// No description provided for @experienceRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Parsed roles'**
  String get experienceRolesTitle;

  /// No description provided for @dashboardImports.
  ///
  /// In en, this message translates to:
  /// **'Imports'**
  String get dashboardImports;

  /// No description provided for @dashboardDynamicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth dynamics'**
  String get dashboardDynamicsTitle;

  /// No description provided for @dashboardDynamicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile completeness from snapshots and scores from evaluations.'**
  String get dashboardDynamicsSubtitle;

  /// No description provided for @dashboardCompletenessTrend.
  ///
  /// In en, this message translates to:
  /// **'Profile completeness'**
  String get dashboardCompletenessTrend;

  /// No description provided for @dashboardTrendHint.
  ///
  /// In en, this message translates to:
  /// **'Filled sections over time (from import snapshots)'**
  String get dashboardTrendHint;

  /// No description provided for @dashboardScoreTrend.
  ///
  /// In en, this message translates to:
  /// **'Profile score'**
  String get dashboardScoreTrend;

  /// No description provided for @dashboardScoreTrendHint.
  ///
  /// In en, this message translates to:
  /// **'Evaluator score after each run'**
  String get dashboardScoreTrendHint;

  /// No description provided for @dashboardLinkedInStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn statistics'**
  String get dashboardLinkedInStatsTitle;

  /// No description provided for @dashboardLinkedInStatsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Import a LinkedIn data export ZIP that includes analytics CSVs (Profile Views, Search Appearances, etc.) to see trends here.'**
  String get dashboardLinkedInStatsEmpty;

  /// No description provided for @dashboardTargetRole.
  ///
  /// In en, this message translates to:
  /// **'Target: {role}'**
  String dashboardTargetRole(String role);

  /// No description provided for @dashboardLastImport.
  ///
  /// In en, this message translates to:
  /// **'Last import: {when}'**
  String dashboardLastImport(String when);

  /// No description provided for @dashboardMetricProfileViews.
  ///
  /// In en, this message translates to:
  /// **'Profile views'**
  String get dashboardMetricProfileViews;

  /// No description provided for @dashboardMetricSearch.
  ///
  /// In en, this message translates to:
  /// **'Search appearances'**
  String get dashboardMetricSearch;

  /// No description provided for @dashboardMetricPosts.
  ///
  /// In en, this message translates to:
  /// **'Post impressions'**
  String get dashboardMetricPosts;

  /// No description provided for @dashboardMetricFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get dashboardMetricFollowers;

  /// No description provided for @dashboardMetricConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get dashboardMetricConnections;

  /// No description provided for @importFromUrlFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile from URL. LinkedIn may block auto-import — copy sections manually or paste below.'**
  String get importFromUrlFailed;

  /// No description provided for @importFromUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Uses your saved LinkedIn URL. Public profiles only; may return partial data.'**
  String get importFromUrlHint;

  /// No description provided for @profileLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get profileLanguageTitle;

  /// No description provided for @profileLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'UI, insights, AI drafts, and scoring all use this language.'**
  String get profileLanguageSubtitle;

  /// No description provided for @snackLanguageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language updated. Run analysis again for new insights.'**
  String get snackLanguageChanged;

  /// No description provided for @compareOnlyWithAi.
  ///
  /// In en, this message translates to:
  /// **'Only sections with AI'**
  String get compareOnlyWithAi;

  /// No description provided for @compareAiSectionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} with AI version'**
  String compareAiSectionsCount(int count);

  /// No description provided for @compareNoAiTitle.
  ///
  /// In en, this message translates to:
  /// **'No AI version yet'**
  String get compareNoAiTitle;

  /// No description provided for @compareNoAiHint.
  ///
  /// In en, this message translates to:
  /// **'Generate AI profile first, then return here to compare.'**
  String get compareNoAiHint;

  /// No description provided for @scoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile scoring'**
  String get scoreTitle;

  /// No description provided for @scoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Independent recruiter-style evaluation of your current profile and AI draft.'**
  String get scoreSubtitle;

  /// No description provided for @scoreEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No score yet'**
  String get scoreEmptyTitle;

  /// No description provided for @scoreEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Import your profile and tap Score profile in the toolbar. Uses a separate evaluator agent from content generation.'**
  String get scoreEmptyHint;

  /// No description provided for @scoreCurrentProfile.
  ///
  /// In en, this message translates to:
  /// **'Current profile'**
  String get scoreCurrentProfile;

  /// No description provided for @scoreAiProfile.
  ///
  /// In en, this message translates to:
  /// **'AI version'**
  String get scoreAiProfile;

  /// No description provided for @scoreAiNotGenerated.
  ///
  /// In en, this message translates to:
  /// **'Not generated'**
  String get scoreAiNotGenerated;

  /// No description provided for @scoreDeltaPositive.
  ///
  /// In en, this message translates to:
  /// **'+{delta} vs current'**
  String scoreDeltaPositive(int delta);

  /// No description provided for @scoreDeltaNegative.
  ///
  /// In en, this message translates to:
  /// **'−{delta} vs current'**
  String scoreDeltaNegative(int delta);

  /// No description provided for @scoreDeltaNeutral.
  ///
  /// In en, this message translates to:
  /// **'Same as current'**
  String get scoreDeltaNeutral;

  /// No description provided for @scoreSectionBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Section scores'**
  String get scoreSectionBreakdown;

  /// No description provided for @scoreRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Evaluator recommendations'**
  String get scoreRecommendationsTitle;

  /// No description provided for @scoreRecommendationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From the independent scoring agent — not the content writer.'**
  String get scoreRecommendationsSubtitle;

  /// No description provided for @scoreCurrentShort.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get scoreCurrentShort;

  /// No description provided for @scoreAiShort.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get scoreAiShort;

  /// No description provided for @scoreEvaluatorBadge.
  ///
  /// In en, this message translates to:
  /// **'Evaluator · {provider}'**
  String scoreEvaluatorBadge(String provider);

  /// No description provided for @statProfileScore.
  ///
  /// In en, this message translates to:
  /// **'Profile score'**
  String get statProfileScore;

  /// No description provided for @statAiScore.
  ///
  /// In en, this message translates to:
  /// **'AI score'**
  String get statAiScore;

  /// No description provided for @scoreEvalViaProvider.
  ///
  /// In en, this message translates to:
  /// **'Scored via {provider} evaluator'**
  String scoreEvalViaProvider(String provider);

  /// No description provided for @scoreEvalLocalFallback.
  ///
  /// In en, this message translates to:
  /// **'LLM unavailable — heuristic scoring used'**
  String get scoreEvalLocalFallback;

  /// No description provided for @scoreEvalLlmErrorFallback.
  ///
  /// In en, this message translates to:
  /// **'Evaluator error ({error}) — heuristic scoring used'**
  String scoreEvalLlmErrorFallback(String error);

  /// No description provided for @snackScoreDone.
  ///
  /// In en, this message translates to:
  /// **'Profile scored'**
  String get snackScoreDone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
