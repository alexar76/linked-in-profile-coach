/// Canonical display and import order for profile sections.
const linkedInSectionOrder = [
  'headline',
  'about',
  'location_industry',
  'contact_links',
  'open_to_work',
  'experience',
  'education',
  'skills',
  'certifications',
  'languages',
  'courses',
  'projects',
  'publications',
  'patents',
  'honors',
  'organizations',
  'services',
  'featured',
  'volunteer',
  'causes',
  'recommendations_received',
  'recommendations_given',
  'activity',
  'creator_newsletter',
];

int linkedInSectionSortIndex(String key) {
  final i = linkedInSectionOrder.indexOf(key);
  return i < 0 ? linkedInSectionOrder.length + key.hashCode : i;
}
