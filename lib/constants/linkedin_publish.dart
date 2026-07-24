import '../models/section_publish_info.dart';

const linkedInProfileBase = 'https://www.linkedin.com/in/me';

SectionPublishInfo publishInfoFor(String sectionKey) {
  return switch (sectionKey) {
    'headline' => const SectionPublishInfo(
        sectionKey: 'headline',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/edit/forms/intro/new/',
        manualNote: '',
      ),
    'about' => const SectionPublishInfo(
        sectionKey: 'about',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/edit/forms/intro/new/',
        manualNote: '',
      ),
    'location_industry' => const SectionPublishInfo(
        sectionKey: 'location_industry',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/edit/forms/intro/new/',
        manualNote: '',
      ),
    'contact_links' => const SectionPublishInfo(
        sectionKey: 'contact_links',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/edit/forms/intro/new/',
        manualNote: '',
      ),
    'open_to_work' => const SectionPublishInfo(
        sectionKey: 'open_to_work',
        capability: PublishCapability.openInBrowser,
        editUrl: 'https://www.linkedin.com/jobs/',
        manualNote: '',
      ),
    'experience' => const SectionPublishInfo(
        sectionKey: 'experience',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/experience/',
        manualNote: '',
      ),
    'education' => const SectionPublishInfo(
        sectionKey: 'education',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/education/',
        manualNote: '',
      ),
    'skills' => const SectionPublishInfo(
        sectionKey: 'skills',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/skills/',
        manualNote: '',
      ),
    'certifications' => const SectionPublishInfo(
        sectionKey: 'certifications',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/certifications/',
        manualNote: '',
      ),
    'languages' => const SectionPublishInfo(
        sectionKey: 'languages',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/languages/',
        manualNote: '',
      ),
    'courses' => const SectionPublishInfo(
        sectionKey: 'courses',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/courses/',
        manualNote: '',
      ),
    'projects' => const SectionPublishInfo(
        sectionKey: 'projects',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/projects/',
        manualNote: '',
      ),
    'publications' => const SectionPublishInfo(
        sectionKey: 'publications',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/publications/',
        manualNote: '',
      ),
    'patents' => const SectionPublishInfo(
        sectionKey: 'patents',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/patents/',
        manualNote: '',
      ),
    'honors' => const SectionPublishInfo(
        sectionKey: 'honors',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/honors/',
        manualNote: '',
      ),
    'organizations' => const SectionPublishInfo(
        sectionKey: 'organizations',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/organizations/',
        manualNote: '',
      ),
    'services' => const SectionPublishInfo(
        sectionKey: 'services',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/services/',
        manualNote: '',
      ),
    'featured' => const SectionPublishInfo(
        sectionKey: 'featured',
        capability: PublishCapability.manualOnly,
        editUrl: linkedInProfileBase,
        manualNote: '',
      ),
    'volunteer' => const SectionPublishInfo(
        sectionKey: 'volunteer',
        capability: PublishCapability.openInBrowser,
        editUrl: '$linkedInProfileBase/details/volunteering-experiences/',
        manualNote: '',
      ),
    'causes' => const SectionPublishInfo(
        sectionKey: 'causes',
        capability: PublishCapability.manualOnly,
        editUrl: linkedInProfileBase,
        manualNote: '',
      ),
    'recommendations_received' => const SectionPublishInfo(
        sectionKey: 'recommendations_received',
        capability: PublishCapability.manualOnly,
        editUrl: linkedInProfileBase,
        manualNote: '',
      ),
    'recommendations_given' => const SectionPublishInfo(
        sectionKey: 'recommendations_given',
        capability: PublishCapability.manualOnly,
        editUrl: linkedInProfileBase,
        manualNote: '',
      ),
    'activity' => const SectionPublishInfo(
        sectionKey: 'activity',
        capability: PublishCapability.manualOnly,
        editUrl: linkedInProfileBase,
        manualNote: '',
      ),
    'creator_newsletter' => const SectionPublishInfo(
        sectionKey: 'creator_newsletter',
        capability: PublishCapability.manualOnly,
        editUrl: linkedInProfileBase,
        manualNote: '',
      ),
    _ => const SectionPublishInfo(
        sectionKey: 'general',
        capability: PublishCapability.copyToClipboard,
        editUrl: linkedInProfileBase,
        manualNote: '',
      ),
  };
}

const linkedInApiDisclaimer =
    'LinkedIn does not offer a public API to write to personal profiles. '
    'Updates are done by copying text and pasting in the browser.';
