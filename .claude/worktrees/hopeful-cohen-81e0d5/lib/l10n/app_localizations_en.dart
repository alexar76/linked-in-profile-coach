// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Profile Coach';

  @override
  String get appTagline => 'Premium LinkedIn profile intelligence';

  @override
  String get navOverview => 'Overview';

  @override
  String get navLinkedIn => 'LinkedIn';

  @override
  String get navAiProfile => 'AI Profile';

  @override
  String get navCompare => 'Compare';

  @override
  String get navScoring => 'Scoring';

  @override
  String get navTips => 'Insights';

  @override
  String get navAdmin => 'Settings';

  @override
  String get btnNext => 'Continue';

  @override
  String get btnBack => 'Back';

  @override
  String get btnSkip => 'Skip';

  @override
  String get btnFinish => 'Finish';

  @override
  String get btnGetStarted => 'Get started';

  @override
  String get btnAnalyze => 'Run analysis';

  @override
  String get btnScore => 'Score profile';

  @override
  String get btnGenerateAi => 'Generate AI';

  @override
  String get btnOpenWizard => 'Guided analysis';

  @override
  String get btnSave => 'Save';

  @override
  String get btnTest => 'Test connection';

  @override
  String get langEnglish => 'English';

  @override
  String get langRussian => 'Russian';

  @override
  String get langSpanish => 'Spanish';

  @override
  String get setupWelcomeTitle => 'Welcome to Profile Coach';

  @override
  String get setupWelcomeSubtitle =>
      'A premium workspace to import, refine, and publish your LinkedIn presence.';

  @override
  String get setupLanguageTitle => 'Choose your language';

  @override
  String get setupLanguageSubtitle =>
      'You can change this anytime in Settings.';

  @override
  String get setupProfileTitle => 'Your identity';

  @override
  String get setupProfileSubtitle =>
      'How you appear in previews and AI drafts.';

  @override
  String get setupNameLabel => 'Display name';

  @override
  String get setupNameHint => 'Alex Morgan';

  @override
  String get setupUrlLabel => 'LinkedIn profile URL';

  @override
  String get setupUrlHint => 'https://www.linkedin.com/in/username/';

  @override
  String get setupGoalTitle => 'Career focus';

  @override
  String get setupGoalSubtitle =>
      'We align headlines, skills, and AI copy to this target.';

  @override
  String get setupRoleLabel => 'Target role';

  @override
  String get setupRoleHint => 'Senior Product Manager';

  @override
  String get setupIndustryLabel => 'Industry';

  @override
  String get setupIndustryHint => 'FinTech, SaaS, HealthTech…';

  @override
  String get setupTemplateTitle => 'Premium templates';

  @override
  String get setupTemplateSubtitle =>
      'Curated positioning frameworks used by top profiles. Pick one to seed your AI draft.';

  @override
  String get templateExecutive => 'Executive presence';

  @override
  String get templateExecutiveDesc => 'Authority, scale, board-level impact.';

  @override
  String get templateTechLeader => 'Tech leader';

  @override
  String get templateTechLeaderDesc =>
      'Engineering leadership, delivery, architecture.';

  @override
  String get templateCreator => 'Creator & brand';

  @override
  String get templateCreatorDesc => 'Audience, content, personal monopoly.';

  @override
  String get templateCareerShift => 'Career pivot';

  @override
  String get templateCareerShiftDesc =>
      'Transferable skills, narrative bridge.';

  @override
  String get setupAiTitle => 'AI provider';

  @override
  String get setupAiSubtitle =>
      'DeepSeek is default. Add your API key or skip to use local templates.';

  @override
  String get setupResumeTitle => 'Resume (optional)';

  @override
  String get setupResumeSubtitle =>
      'Upload a .docx (Word 2007+) to enrich comparisons and AI suggestions. Legacy .doc is not supported.';

  @override
  String get resumeDragDropHint =>
      'Drag and drop a .docx file here, or use Browse.';

  @override
  String get resumeErrorLegacyDoc =>
      'Legacy Word .doc is not supported. In Word use File → Save As → .docx.';

  @override
  String resumeErrorUnsupportedExt(String ext) {
    return 'Unsupported file type \"$ext\". Only .docx is supported.';
  }

  @override
  String get resumeErrorEmptyDocx => 'The .docx file has no readable text.';

  @override
  String get resumeErrorInvalidDocx =>
      'Could not read this file as .docx. Check that it is a valid Word document.';

  @override
  String get setupImportTitle => 'Import LinkedIn';

  @override
  String get setupImportSubtitle =>
      'Copy sections from LinkedIn with headers HEADLINE, ABOUT, EXPERIENCE — or import later.';

  @override
  String get setupReadyTitle => 'You\'re set';

  @override
  String get setupReadySubtitle =>
      'We\'ll guide you through a focused analysis — step by step.';

  @override
  String get analysisTitle => 'Guided analysis';

  @override
  String get analysisStepImport => 'Import profile';

  @override
  String get analysisStepImportDesc =>
      'Paste your LinkedIn sections or load a JSON export.';

  @override
  String get analysisStepAi => 'Generate AI profile';

  @override
  String get analysisStepAiDesc =>
      'Create a polished version aligned with your goal and template.';

  @override
  String get analysisStepReview => 'Review & compare';

  @override
  String get analysisStepReviewDesc =>
      'Side-by-side diff and similarity score per section.';

  @override
  String get analysisStepInsights => 'Insights';

  @override
  String get analysisStepInsightsDesc =>
      'Prioritized recommendations for fill, promotion, and alignment.';

  @override
  String get analysisStepPublish => 'Publish plan';

  @override
  String get analysisStepPublishDesc =>
      'Copy, open LinkedIn forms, track what\'s done manually.';

  @override
  String get analysisCompleteTitle => 'Analysis complete';

  @override
  String get analysisCompleteSubtitle =>
      'Your workspace is ready. Keep iterating from the main dashboard.';

  @override
  String get premiumBadge => 'PREMIUM';

  @override
  String stepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get snackAnalysisDone => 'Analysis complete';

  @override
  String get snackAiDone => 'AI profile generated';

  @override
  String get snackSaved => 'Saved';

  @override
  String get snackImportDone => 'Import successful';

  @override
  String get dashboardTitle => 'Overview';

  @override
  String get dashboardSubtitle =>
      'Completeness, urgent insights, and quick actions.';

  @override
  String get statSections => 'Sections filled';

  @override
  String get statUrgent => 'Urgent insights';

  @override
  String get statTotalTips => 'Total insights';

  @override
  String get importLinkedIn => 'Import from clipboard';

  @override
  String get importJson => 'JSON file';

  @override
  String get compareTitle => 'Compare';

  @override
  String get updateLinkedIn => 'Update on LinkedIn';

  @override
  String get linkedInApiNote =>
      'LinkedIn does not offer a public write API for personal profiles. Copy AI text and paste in the browser.';

  @override
  String get adminTitle => 'Settings';

  @override
  String get adminAiSection => 'AI — API';

  @override
  String get adminProfileSection => 'Profile & goal';

  @override
  String get adminResumeSection => 'Resume (.docx)';

  @override
  String get restartSetup => 'Run setup wizard again';

  @override
  String get restartAnalysis => 'Run guided analysis';

  @override
  String get themeSectionTitle => 'Appearance';

  @override
  String get themeSectionSubtitle =>
      'Dark, light, and blush palettes — switch anytime.';

  @override
  String get themeGroupDark => 'Dark';

  @override
  String get themeGroupLight => 'Light';

  @override
  String get themeGroupPink => 'Blush & pink';

  @override
  String get themeDarkGold => 'Midnight Gold';

  @override
  String get themeDarkOcean => 'Deep Ocean';

  @override
  String get themeDarkPlum => 'Royal Plum';

  @override
  String get themeLightIvory => 'Ivory Pro';

  @override
  String get themeLightCloud => 'Cloud Blue';

  @override
  String get themeLightSage => 'Soft Sage';

  @override
  String get themeLightPearl => 'Pearl Gray';

  @override
  String get themeLightSand => 'Warm Sand';

  @override
  String get themeLightMint => 'Fresh Mint';

  @override
  String get themeLightAmber => 'Golden Amber';

  @override
  String get themePinkRose => 'Rose Quartz';

  @override
  String get themePinkBlush => 'Blush Petal';

  @override
  String get themePinkLilac => 'Lilac Dream';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnImport => 'Import';

  @override
  String get btnUploadResume => 'Upload .docx';

  @override
  String get btnReplaceResume => 'Replace resume';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get importParseFailed =>
      'Could not parse sections. Use headers: HEADLINE, ABOUT, EXPERIENCE…';

  @override
  String importSectionsImported(int count) {
    return 'Imported $count sections';
  }

  @override
  String get previewNotGenerated => '— Not generated yet —';

  @override
  String get previewNotImported => '— Not imported —';

  @override
  String get previewYourName => 'Your name';

  @override
  String previewImportMeta(int count, String date) {
    return '$count sections • $date';
  }

  @override
  String get previewSyncedTooltip => 'Marked as applied on LinkedIn';

  @override
  String get previewChangedLabel => 'changed';

  @override
  String get dashboardHowTo => 'How to use';

  @override
  String get dashboardStep1 => 'Open LinkedIn and copy each profile section';

  @override
  String get dashboardStep2 =>
      'Paste on the LinkedIn tab or use clipboard import';

  @override
  String get dashboardStep3 => 'Upload a .docx resume in Settings (optional)';

  @override
  String get dashboardStep4 => 'Run analysis for section-by-section insights';

  @override
  String adminResumeLoaded(String date) {
    return 'Uploaded: $date';
  }

  @override
  String get adminResumePreviewLabel => 'Text preview:';

  @override
  String get adminPrivacyNote =>
      'The app does not connect to LinkedIn directly (platform limits). Copy sections manually — safer for your account.';

  @override
  String adminResumeUploaded(String filename) {
    return 'Resume uploaded: $filename';
  }

  @override
  String get importDialogTitle => 'Import from LinkedIn';

  @override
  String get importDialogBody =>
      'Copy profile sections from LinkedIn and paste below. Use section headers:';

  @override
  String get importDialogPlaceholder => 'Paste profile text…';

  @override
  String get importFormatExample =>
      'HEADLINE:\n...\n\nABOUT:\n...\n\nEXPERIENCE:\n...\n\nSKILLS:\n...\n\nLANGUAGES:\n...';

  @override
  String get setupImportPasteHint =>
      'Paste with HEADLINE, ABOUT, EXPERIENCE headers — or skip and import later.';

  @override
  String get aiConnectionOkTitle => 'Connection OK';

  @override
  String aiConnectionReply(String reply) {
    return 'Reply: $reply';
  }

  @override
  String get btnClose => 'Close';

  @override
  String get aiProfileTitle => 'AI profile';

  @override
  String aiProfileSectionsCount(int count) {
    return '$count sections';
  }

  @override
  String aiProfileDiffCount(int count) {
    return '$count diffs';
  }

  @override
  String get aiProfileSubtitle =>
      'Via LLM (DeepSeek, etc.) or local templates if the API fails';

  @override
  String get aiProfileEmptyTitle => 'AI version not created yet';

  @override
  String get aiProfileEmptyHint => 'Tap Generate AI in the toolbar';

  @override
  String get aiSectionEditLabel => 'AI version text';

  @override
  String get aiSettingsSubtitle =>
      'DeepSeek by default. On API errors — local templates.';

  @override
  String get aiProviderLabel => 'Provider';

  @override
  String get aiApiKeyLabel => 'API key';

  @override
  String get aiApiKeyStored => 'Provider key';

  @override
  String get aiModelLabel => 'Model';

  @override
  String get aiResetDefaults => 'Reset URL/model';

  @override
  String get aiProviderOpenAiHint =>
      'OpenAI: platform.openai.com — /v1/chat/completions';

  @override
  String get aiProviderCompatibleHint =>
      'Any OpenAI-compatible endpoint (Together, Groq, local proxy…)';

  @override
  String get aiProviderAnthropicHint =>
      'Anthropic: console.anthropic.com — separate API';

  @override
  String get aiProviderLmRouterHint => 'LM Router: base URL from service docs';

  @override
  String get aiProviderOllamaHint =>
      'Ollama: localhost:11434 — no API key required';

  @override
  String get analysisImportNow => 'Import from clipboard';

  @override
  String get linkedinSourceTitle => 'LinkedIn — imported profile';

  @override
  String linkedinSectionsMeta(int filled, int total) {
    return '$filled / $total sections imported';
  }

  @override
  String get linkedinSectionEditLabel => 'LinkedIn section text';

  @override
  String get aiLlmToggle => 'LLM';

  @override
  String get aiBaseUrlLabel => 'Base URL';

  @override
  String get aiProviderOpenAiCompatible => 'OpenAI-compatible';

  @override
  String get aiProviderOllama => 'Ollama (local)';

  @override
  String get aiProviderCompatibleEndpointHint =>
      'Any endpoint with /chat/completions';

  @override
  String get aiProviderLmRouterEndpointHint =>
      'Set your base URL if it differs';

  @override
  String get aiProviderOllamaServeHint => 'Run: ollama serve';

  @override
  String get aiProviderDeepseekSetupHint =>
      'DeepSeek: platform.deepseek.com → API Keys. Endpoint: api.deepseek.com';

  @override
  String get aiGenLocalFallback =>
      'LLM disabled or no API key — using local templates';

  @override
  String aiGenViaProvider(String provider) {
    return 'Generated via $provider';
  }

  @override
  String aiGenLlmErrorFallback(String error) {
    return 'LLM error ($error) — local templates used';
  }

  @override
  String get compareEmptyLinkedIn => '— empty —';

  @override
  String get compareEmptyAi => '— not generated —';

  @override
  String compareSectionsWithDiff(int count) {
    return '$count sections with differences';
  }

  @override
  String get compareSideBySide => 'Side by side';

  @override
  String get compareDiffMode => 'Diff';

  @override
  String get compareSectionLabel => 'Section';

  @override
  String get compareLinkedInColumn => 'LinkedIn (import)';

  @override
  String get compareAiColumn => 'AI version';

  @override
  String get diffRemoved => 'Removed';

  @override
  String get diffAdded => 'Added';

  @override
  String diffSimilarity(String percent) {
    return 'Similarity: $percent%';
  }

  @override
  String get publishSheetTitle => 'Update LinkedIn profile';

  @override
  String publishChangedCount(int count) {
    return 'Changed sections: $count';
  }

  @override
  String get publishHasChanges => 'has changes';

  @override
  String get publishCopyAi => 'Copy AI text';

  @override
  String get publishOpenLinkedIn => 'Open in LinkedIn';

  @override
  String get publishMarkDone => 'Mark done';

  @override
  String publishCopiedSection(String title) {
    return 'Copied: $title';
  }

  @override
  String get publishBrowserFailed => 'Could not open browser';

  @override
  String get publishCapabilityCopy => 'Copy only + paste manually';

  @override
  String get publishCapabilityBrowser => 'Copy → open form → paste';

  @override
  String get publishCapabilityManual => 'Manual update in LinkedIn UI only';

  @override
  String get publishNoteHeadline =>
      'Paste the headline in the Headline field on the Intro page.';

  @override
  String get publishNoteAbout =>
      'About text is in the same Intro section, Summary field.';

  @override
  String get publishNoteExperience => 'Add or edit each position separately.';

  @override
  String get publishNoteEducation => 'Enter schools and years.';

  @override
  String get publishNoteSkills =>
      'Add skills manually; endorsements are separate.';

  @override
  String get publishNoteCertifications =>
      'Certifications are added one by one.';

  @override
  String get publishNoteProjects =>
      'Projects and links go in the Projects section.';

  @override
  String get publishNoteFeatured =>
      'Featured: pin a post or link via Add profile section.';

  @override
  String get publishNoteVolunteer =>
      'Volunteer experience uses a separate form.';

  @override
  String get publishNoteRecommendations =>
      'Recommendations are requested from others — you cannot paste text yourself.';

  @override
  String get publishNoteGeneral =>
      'Open your profile and paste text into the right section.';

  @override
  String get sectionEditDefaultLabel => 'Section text';

  @override
  String get sectionEditPaste => 'Paste';

  @override
  String get sectionEditHintPrefix => 'Tip:';

  @override
  String sectionCharCount(int count) {
    return '$count characters';
  }

  @override
  String get recommendationsEmpty => 'No recommendations yet';

  @override
  String get recommendationsEmptyHint =>
      'Tap Run analysis in the toolbar — this builds rule-based tips for each section.';

  @override
  String get recommendationsEmptyScoringHint =>
      'Recruiter-style advice from Score profile appears on the Scoring tab, not here.';

  @override
  String get filterAllSections => 'All sections';

  @override
  String get filterGeneralPromotion => 'General / promotion';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get categoryFill => 'Fill';

  @override
  String get categoryPromote => 'Promote';

  @override
  String get categoryAlign => 'Align';

  @override
  String get sectionHeadlineTitle => 'Headline';

  @override
  String get sectionHeadlineDescription =>
      'The first line under your name — visible to recruiters in search and feed.';

  @override
  String get sectionHeadlineHint =>
      'e.g. Senior Flutter Developer | FinTech | Remote';

  @override
  String get sectionAboutTitle => 'About';

  @override
  String get sectionAboutDescription =>
      'Short story, value proposition, specialty, and call to action.';

  @override
  String get sectionAboutHint =>
      '2–4 paragraphs: who you are, how you help, what sets you apart, how to reach you.';

  @override
  String get sectionExperienceTitle => 'Experience';

  @override
  String get sectionExperienceDescription =>
      'Roles, companies, dates, and achievements with numbers.';

  @override
  String get sectionExperienceHint =>
      'Each role: context → actions → outcome (metrics).';

  @override
  String get sectionEducationTitle => 'Education';

  @override
  String get sectionEducationDescription =>
      'Schools, degrees, years, relevant courses.';

  @override
  String get sectionEducationHint =>
      'Include major and activities if they strengthen your profile.';

  @override
  String get sectionSkillsTitle => 'Skills';

  @override
  String get sectionSkillsDescription =>
      'Key skills for search and credibility.';

  @override
  String get sectionSkillsHint =>
      'Comma or line-separated: Flutter, Dart, SQLite, …';

  @override
  String get sectionCertificationsTitle => 'Certifications';

  @override
  String get sectionCertificationsDescription =>
      'Official courses and exams that build trust.';

  @override
  String get sectionCertificationsHint => 'Name | Organization | Year';

  @override
  String get sectionProjectsTitle => 'Projects';

  @override
  String get sectionProjectsDescription =>
      'Public cases, pet projects, open source.';

  @override
  String get sectionProjectsHint => 'Name — role — stack — outcome/link';

  @override
  String get sectionFeaturedTitle => 'Featured';

  @override
  String get sectionFeaturedDescription =>
      'Articles, posts, portfolio — what you want shown first.';

  @override
  String get sectionFeaturedHint => 'Links or descriptions for featured items';

  @override
  String get sectionVolunteerTitle => 'Volunteering';

  @override
  String get sectionVolunteerDescription =>
      'Non-profit experience if relevant to your goal.';

  @override
  String get sectionVolunteerHint => 'Organization — role — period — impact';

  @override
  String get sectionRecommendationsTitle => 'Recommendations';

  @override
  String get sectionRecommendationsDescription =>
      'Colleague endorsements — social proof.';

  @override
  String get sectionRecommendationsHint =>
      'Who to ask and which themes to cover';

  @override
  String get sectionLocationIndustryTitle => 'Location & industry';

  @override
  String get sectionLocationIndustryDescription =>
      'Where you are based and your industry — visible on the intro card.';

  @override
  String get sectionLocationIndustryHint => 'City, country · Industry name';

  @override
  String get sectionContactLinksTitle => 'Contact & links';

  @override
  String get sectionContactLinksDescription =>
      'Websites, portfolio, email, and social links.';

  @override
  String get sectionContactLinksHint => 'One link per line with label';

  @override
  String get sectionOpenToWorkTitle => 'Open to work';

  @override
  String get sectionOpenToWorkDescription =>
      'Job-seeker preferences and visibility to recruiters.';

  @override
  String get sectionOpenToWorkHint =>
      'Roles, locations, start date, remote/hybrid';

  @override
  String get sectionLanguagesTitle => 'Languages';

  @override
  String get sectionLanguagesDescription =>
      'Languages you speak and proficiency level.';

  @override
  String get sectionLanguagesHint => 'English — Full professional proficiency';

  @override
  String get sectionHonorsTitle => 'Honors & awards';

  @override
  String get sectionHonorsDescription =>
      'Awards, prizes, and formal recognition.';

  @override
  String get sectionHonorsHint => 'Title — issuer — year';

  @override
  String get sectionPublicationsTitle => 'Publications';

  @override
  String get sectionPublicationsDescription => 'Articles, papers, and books.';

  @override
  String get sectionPublicationsHint => 'Title — publisher — date — link';

  @override
  String get sectionPatentsTitle => 'Patents';

  @override
  String get sectionPatentsDescription => 'Patents you hold or co-invented.';

  @override
  String get sectionPatentsHint => 'Title — patent office — number — year';

  @override
  String get sectionCoursesTitle => 'Courses';

  @override
  String get sectionCoursesDescription =>
      'Training and courses beyond formal degrees.';

  @override
  String get sectionCoursesHint => 'Course — provider — year';

  @override
  String get sectionOrganizationsTitle => 'Organizations';

  @override
  String get sectionOrganizationsDescription =>
      'Memberships in professional associations.';

  @override
  String get sectionOrganizationsHint => 'Organization — role — years';

  @override
  String get sectionServicesTitle => 'Services';

  @override
  String get sectionServicesDescription =>
      'Services you offer (freelance / consulting).';

  @override
  String get sectionServicesHint => 'Service name — description';

  @override
  String get sectionCausesTitle => 'Causes';

  @override
  String get sectionCausesDescription =>
      'Causes you care about on your profile.';

  @override
  String get sectionCausesHint => 'List causes or short note';

  @override
  String get sectionRecommendationsGivenTitle => 'Recommendations given';

  @override
  String get sectionRecommendationsGivenDescription =>
      'Recommendations you wrote for others.';

  @override
  String get sectionRecommendationsGivenHint => 'Name — relationship — excerpt';

  @override
  String get sectionActivityTitle => 'Activity';

  @override
  String get sectionActivityDescription =>
      'Recent posts and shares — your public voice.';

  @override
  String get sectionActivityHint => 'Paste recent post titles or excerpts';

  @override
  String get sectionCreatorNewsletterTitle => 'Creator & newsletter';

  @override
  String get sectionCreatorNewsletterDescription =>
      'Newsletter or creator mode content.';

  @override
  String get sectionCreatorNewsletterHint => 'Newsletter name — topic — link';

  @override
  String get publishNoteLocationIndustry =>
      'Location and industry are on the Intro edit page.';

  @override
  String get publishNoteContactLinks =>
      'Add websites and contact info on Intro or Contact info.';

  @override
  String get publishNoteOpenToWork =>
      'Set job preferences via Jobs → Open to work.';

  @override
  String get publishNoteLanguages =>
      'Add each language with proficiency in Languages.';

  @override
  String get publishNoteHonors =>
      'Honors are added one by one in Honors & awards.';

  @override
  String get publishNotePublications =>
      'Add publications individually with links.';

  @override
  String get publishNotePatents => 'Patents are added one by one in Patents.';

  @override
  String get publishNoteCourses => 'Courses go in the Courses section.';

  @override
  String get publishNoteOrganizations => 'Organizations are added separately.';

  @override
  String get publishNoteServices =>
      'Services use the Services profile section.';

  @override
  String get publishNoteCauses =>
      'Select causes via Add profile section → Causes.';

  @override
  String get publishNoteRecommendationsGiven =>
      'Recommendations you gave are not editable as bulk text.';

  @override
  String get publishNoteActivity =>
      'Activity is your feed — create or edit posts on LinkedIn.';

  @override
  String get publishNoteCreatorNewsletter =>
      'Newsletter settings are in Creator mode / Pages.';

  @override
  String get importFromProfileUrl => 'Import from profile URL';

  @override
  String get importLinkedInExport => 'LinkedIn data export';

  @override
  String get importLinkedInExportTooltip =>
      'Upload ZIP or JSON from Settings → Data privacy → Get a copy of your data';

  @override
  String get refreshLinkedIn => 'Refresh from LinkedIn';

  @override
  String get refreshLinkedInTooltip =>
      'Re-import from watch folder, last export file, or profile URL';

  @override
  String get refreshLinkedInNothing =>
      'Nothing new found. Set watch folder or export path in Settings, or import manually.';

  @override
  String get importUpToDate =>
      'Profile is already up to date for imported sections.';

  @override
  String get importMergeCancelled => 'Import cancelled.';

  @override
  String get importMergeTitle => 'Review changes';

  @override
  String importMergeSubtitle(String source, int count) {
    return 'Source: $source · $count sections changed';
  }

  @override
  String get importMergeSelectChanged => 'Changed only';

  @override
  String get importMergeSelectAll => 'All';

  @override
  String get importMergeSelectNone => 'None';

  @override
  String get importMergePreview => 'Preview';

  @override
  String get importMergeApply => 'Apply selected';

  @override
  String get importMergeCurrent => 'Current';

  @override
  String get importMergeIncoming => 'Incoming';

  @override
  String get importMergeStatusNew => 'New section';

  @override
  String get importMergeStatusChanged => 'Updated';

  @override
  String get importMergeStatusUnchanged => 'No change';

  @override
  String get snapshotsTitle => 'History';

  @override
  String get snapshotsEmpty =>
      'Snapshots are created automatically before each import.';

  @override
  String get snapshotRestore => 'Restore';

  @override
  String get snapshotRestoreTitle => 'Restore snapshot?';

  @override
  String get snapshotRestoreBody =>
      'Current profile content will be replaced. A backup snapshot is saved first.';

  @override
  String get snapshotRestoreConfirm => 'Restore';

  @override
  String get snapshotRestored => 'Snapshot restored.';

  @override
  String get atsMatchTitle => 'ATS keyword match';

  @override
  String atsMatchScore(int percent) {
    return 'Match score: $percent%';
  }

  @override
  String atsMatchMissing(String keywords) {
    return 'Consider adding: $keywords';
  }

  @override
  String importReminderBody(int days) {
    return 'Last LinkedIn import was $days days ago. Refresh to keep insights accurate.';
  }

  @override
  String get importReminderSnooze => 'Remind in 7 days';

  @override
  String get syncSettingsTitle => 'LinkedIn sync';

  @override
  String get syncSettingsSubtitle =>
      'Watch folder auto-imports newest ZIP/JSON. Refresh uses folder → last file → profile URL.';

  @override
  String lastExportPath(String path) {
    return 'Last export: $path';
  }

  @override
  String get watchFolderNotSet => 'Watch folder: not set';

  @override
  String watchFolderPath(String path) {
    return 'Watch folder: $path';
  }

  @override
  String get watchFolderPick => 'Choose watch folder';

  @override
  String get watchFolderSet => 'Watch folder saved.';

  @override
  String get experienceRolesTitle => 'Parsed roles';

  @override
  String get dashboardImports => 'Imports';

  @override
  String get dashboardDynamicsTitle => 'Growth dynamics';

  @override
  String get dashboardDynamicsSubtitle =>
      'Profile completeness from snapshots and scores from evaluations.';

  @override
  String get dashboardCompletenessTrend => 'Profile completeness';

  @override
  String get dashboardTrendHint =>
      'Filled sections over time (from import snapshots)';

  @override
  String get dashboardScoreTrend => 'Profile score';

  @override
  String get dashboardScoreTrendHint => 'Evaluator score after each run';

  @override
  String get dashboardLinkedInStatsTitle => 'LinkedIn statistics';

  @override
  String get dashboardLinkedInStatsEmpty =>
      'Import a LinkedIn data export ZIP that includes analytics CSVs (Profile Views, Search Appearances, etc.) to see trends here.';

  @override
  String dashboardTargetRole(String role) {
    return 'Target: $role';
  }

  @override
  String dashboardLastImport(String when) {
    return 'Last import: $when';
  }

  @override
  String get dashboardMetricProfileViews => 'Profile views';

  @override
  String get dashboardMetricSearch => 'Search appearances';

  @override
  String get dashboardMetricPosts => 'Post impressions';

  @override
  String get dashboardMetricFollowers => 'Followers';

  @override
  String get dashboardMetricConnections => 'Connections';

  @override
  String get importFromUrlFailed =>
      'Could not load profile from URL. LinkedIn may block auto-import — copy sections manually or paste below.';

  @override
  String get importFromUrlHint =>
      'Uses your saved LinkedIn URL. Public profiles only; may return partial data.';

  @override
  String get profileLanguageTitle => 'App language';

  @override
  String get profileLanguageSubtitle =>
      'UI, insights, AI drafts, and scoring all use this language.';

  @override
  String get snackLanguageChanged =>
      'Language updated. Run analysis again for new insights.';

  @override
  String get compareOnlyWithAi => 'Only sections with AI';

  @override
  String compareAiSectionsCount(int count) {
    return '$count with AI version';
  }

  @override
  String get compareNoAiTitle => 'No AI version yet';

  @override
  String get compareNoAiHint =>
      'Generate AI profile first, then return here to compare.';

  @override
  String get scoreTitle => 'Profile scoring';

  @override
  String get scoreSubtitle =>
      'Independent recruiter-style evaluation of your current profile and AI draft.';

  @override
  String get scoreEmptyTitle => 'No score yet';

  @override
  String get scoreEmptyHint =>
      'Import your profile and tap Score profile in the toolbar. Uses a separate evaluator agent from content generation.';

  @override
  String get scoreCurrentProfile => 'Current profile';

  @override
  String get scoreAiProfile => 'AI version';

  @override
  String get scoreAiNotGenerated => 'Not generated';

  @override
  String scoreDeltaPositive(int delta) {
    return '+$delta vs current';
  }

  @override
  String scoreDeltaNegative(int delta) {
    return '−$delta vs current';
  }

  @override
  String get scoreDeltaNeutral => 'Same as current';

  @override
  String get scoreSectionBreakdown => 'Section scores';

  @override
  String get scoreRecommendationsTitle => 'Evaluator recommendations';

  @override
  String get scoreRecommendationsSubtitle =>
      'From the independent scoring agent — not the content writer.';

  @override
  String get scoreCurrentShort => 'Current';

  @override
  String get scoreAiShort => 'AI';

  @override
  String scoreEvaluatorBadge(String provider) {
    return 'Evaluator · $provider';
  }

  @override
  String get statProfileScore => 'Profile score';

  @override
  String get statAiScore => 'AI score';

  @override
  String scoreEvalViaProvider(String provider) {
    return 'Scored via $provider evaluator';
  }

  @override
  String get scoreEvalLocalFallback =>
      'LLM unavailable — heuristic scoring used';

  @override
  String scoreEvalLlmErrorFallback(String error) {
    return 'Evaluator error ($error) — heuristic scoring used';
  }

  @override
  String get snackScoreDone => 'Profile scored';
}
