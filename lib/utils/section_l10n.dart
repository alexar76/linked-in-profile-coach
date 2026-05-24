import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../models/profile_section.dart';

/// Applies UI locale to section metadata (title, description, hint).
ProfileSection localizeSection(AppLocalizations l10n, ProfileSection section) {
  final meta = sectionMeta(l10n, section.key);
  return ProfileSection(
    key: section.key,
    title: meta.title,
    description: meta.description,
    hint: meta.hint,
    content: section.content,
    aiContent: section.aiContent,
    updatedAt: section.updatedAt,
    aiGeneratedAt: section.aiGeneratedAt,
    manualSyncedAt: section.manualSyncedAt,
  );
}

List<ProfileSection> localizeSections(
  AppLocalizations l10n,
  List<ProfileSection> sections,
) =>
    sections.map((s) => localizeSection(l10n, s)).toList();

String sectionTitle(AppLocalizations l10n, String key) =>
    sectionMeta(l10n, key).title;

({String title, String description, String hint}) sectionMeta(
  AppLocalizations l10n,
  String key,
) =>
    switch (key) {
      'headline' => (
          title: l10n.sectionHeadlineTitle,
          description: l10n.sectionHeadlineDescription,
          hint: l10n.sectionHeadlineHint,
        ),
      'about' => (
          title: l10n.sectionAboutTitle,
          description: l10n.sectionAboutDescription,
          hint: l10n.sectionAboutHint,
        ),
      'location_industry' => (
          title: l10n.sectionLocationIndustryTitle,
          description: l10n.sectionLocationIndustryDescription,
          hint: l10n.sectionLocationIndustryHint,
        ),
      'contact_links' => (
          title: l10n.sectionContactLinksTitle,
          description: l10n.sectionContactLinksDescription,
          hint: l10n.sectionContactLinksHint,
        ),
      'open_to_work' => (
          title: l10n.sectionOpenToWorkTitle,
          description: l10n.sectionOpenToWorkDescription,
          hint: l10n.sectionOpenToWorkHint,
        ),
      'experience' => (
          title: l10n.sectionExperienceTitle,
          description: l10n.sectionExperienceDescription,
          hint: l10n.sectionExperienceHint,
        ),
      'education' => (
          title: l10n.sectionEducationTitle,
          description: l10n.sectionEducationDescription,
          hint: l10n.sectionEducationHint,
        ),
      'skills' => (
          title: l10n.sectionSkillsTitle,
          description: l10n.sectionSkillsDescription,
          hint: l10n.sectionSkillsHint,
        ),
      'certifications' => (
          title: l10n.sectionCertificationsTitle,
          description: l10n.sectionCertificationsDescription,
          hint: l10n.sectionCertificationsHint,
        ),
      'languages' => (
          title: l10n.sectionLanguagesTitle,
          description: l10n.sectionLanguagesDescription,
          hint: l10n.sectionLanguagesHint,
        ),
      'courses' => (
          title: l10n.sectionCoursesTitle,
          description: l10n.sectionCoursesDescription,
          hint: l10n.sectionCoursesHint,
        ),
      'projects' => (
          title: l10n.sectionProjectsTitle,
          description: l10n.sectionProjectsDescription,
          hint: l10n.sectionProjectsHint,
        ),
      'publications' => (
          title: l10n.sectionPublicationsTitle,
          description: l10n.sectionPublicationsDescription,
          hint: l10n.sectionPublicationsHint,
        ),
      'patents' => (
          title: l10n.sectionPatentsTitle,
          description: l10n.sectionPatentsDescription,
          hint: l10n.sectionPatentsHint,
        ),
      'honors' => (
          title: l10n.sectionHonorsTitle,
          description: l10n.sectionHonorsDescription,
          hint: l10n.sectionHonorsHint,
        ),
      'organizations' => (
          title: l10n.sectionOrganizationsTitle,
          description: l10n.sectionOrganizationsDescription,
          hint: l10n.sectionOrganizationsHint,
        ),
      'services' => (
          title: l10n.sectionServicesTitle,
          description: l10n.sectionServicesDescription,
          hint: l10n.sectionServicesHint,
        ),
      'featured' => (
          title: l10n.sectionFeaturedTitle,
          description: l10n.sectionFeaturedDescription,
          hint: l10n.sectionFeaturedHint,
        ),
      'volunteer' => (
          title: l10n.sectionVolunteerTitle,
          description: l10n.sectionVolunteerDescription,
          hint: l10n.sectionVolunteerHint,
        ),
      'causes' => (
          title: l10n.sectionCausesTitle,
          description: l10n.sectionCausesDescription,
          hint: l10n.sectionCausesHint,
        ),
      'recommendations_received' => (
          title: l10n.sectionRecommendationsTitle,
          description: l10n.sectionRecommendationsDescription,
          hint: l10n.sectionRecommendationsHint,
        ),
      'recommendations_given' => (
          title: l10n.sectionRecommendationsGivenTitle,
          description: l10n.sectionRecommendationsGivenDescription,
          hint: l10n.sectionRecommendationsGivenHint,
        ),
      'activity' => (
          title: l10n.sectionActivityTitle,
          description: l10n.sectionActivityDescription,
          hint: l10n.sectionActivityHint,
        ),
      'creator_newsletter' => (
          title: l10n.sectionCreatorNewsletterTitle,
          description: l10n.sectionCreatorNewsletterDescription,
          hint: l10n.sectionCreatorNewsletterHint,
        ),
      _ => (
          title: key,
          description: '',
          hint: '',
        ),
    };

String publishManualNote(AppLocalizations l10n, String sectionKey) =>
    switch (sectionKey) {
      'headline' => l10n.publishNoteHeadline,
      'about' => l10n.publishNoteAbout,
      'location_industry' => l10n.publishNoteLocationIndustry,
      'contact_links' => l10n.publishNoteContactLinks,
      'open_to_work' => l10n.publishNoteOpenToWork,
      'experience' => l10n.publishNoteExperience,
      'education' => l10n.publishNoteEducation,
      'skills' => l10n.publishNoteSkills,
      'certifications' => l10n.publishNoteCertifications,
      'languages' => l10n.publishNoteLanguages,
      'honors' => l10n.publishNoteHonors,
      'publications' => l10n.publishNotePublications,
      'patents' => l10n.publishNotePatents,
      'courses' => l10n.publishNoteCourses,
      'organizations' => l10n.publishNoteOrganizations,
      'services' => l10n.publishNoteServices,
      'projects' => l10n.publishNoteProjects,
      'featured' => l10n.publishNoteFeatured,
      'volunteer' => l10n.publishNoteVolunteer,
      'causes' => l10n.publishNoteCauses,
      'recommendations_received' => l10n.publishNoteRecommendations,
      'recommendations_given' => l10n.publishNoteRecommendationsGiven,
      'activity' => l10n.publishNoteActivity,
      'creator_newsletter' => l10n.publishNoteCreatorNewsletter,
      _ => l10n.publishNoteGeneral,
    };

String publishCapabilityLabel(
  AppLocalizations l10n,
  PublishCapabilityKind kind,
) =>
    switch (kind) {
      PublishCapabilityKind.copy => l10n.publishCapabilityCopy,
      PublishCapabilityKind.browser => l10n.publishCapabilityBrowser,
      PublishCapabilityKind.manual => l10n.publishCapabilityManual,
    };

enum PublishCapabilityKind { copy, browser, manual }

String aiProviderLabel(AppLocalizations l10n, String providerName) =>
    switch (providerName) {
      'openAiCompatible' => l10n.aiProviderOpenAiCompatible,
      'ollama' => l10n.aiProviderOllama,
      _ => aiProviderPresetsBrandLabel(providerName),
    };

String aiProviderPresetsBrandLabel(String providerName) => switch (providerName) {
      'deepseek' => 'DeepSeek',
      'openai' => 'OpenAI',
      'anthropic' => 'Anthropic',
      'lmrouter' => 'LM Router',
      'openAiCompatible' => 'OpenAI-compatible',
      'ollama' => 'Ollama',
      _ => providerName,
    };

String? aiProviderPresetHint(AppLocalizations l10n, String providerName) =>
    switch (providerName) {
      'openAiCompatible' => l10n.aiProviderCompatibleEndpointHint,
      'lmrouter' => l10n.aiProviderLmRouterEndpointHint,
      'ollama' => l10n.aiProviderOllamaServeHint,
      _ => null,
    };
