class ProfileSection {
  const ProfileSection({
    required this.key,
    required this.title,
    required this.description,
    required this.hint,
    this.content = '',
    this.aiContent = '',
    this.updatedAt,
    this.aiGeneratedAt,
    this.manualSyncedAt,
  });

  final String key;
  final String title;
  final String description;
  final String hint;
  final String content;
  final String aiContent;
  final DateTime? updatedAt;
  final DateTime? aiGeneratedAt;
  final DateTime? manualSyncedAt;

  bool get hasLinkedInContent => content.trim().isNotEmpty;
  bool get hasAiContent => aiContent.trim().isNotEmpty;
  bool get hasDiff =>
      hasLinkedInContent &&
      hasAiContent &&
      content.trim() != aiContent.trim();

  ProfileSection copyWith({
    String? content,
    String? aiContent,
    DateTime? updatedAt,
    DateTime? aiGeneratedAt,
    DateTime? manualSyncedAt,
    bool clearManualSynced = false,
  }) {
    return ProfileSection(
      key: key,
      title: title,
      description: description,
      hint: hint,
      content: content ?? this.content,
      aiContent: aiContent ?? this.aiContent,
      updatedAt: updatedAt ?? this.updatedAt,
      aiGeneratedAt: aiGeneratedAt ?? this.aiGeneratedAt,
      manualSyncedAt: clearManualSynced
          ? null
          : (manualSyncedAt ?? this.manualSyncedAt),
    );
  }

  Map<String, dynamic> toMap() => {
        'section_key': key,
        'title': title,
        'description': description,
        'hint': hint,
        'content': content,
        'ai_content': aiContent,
        'updated_at': updatedAt?.millisecondsSinceEpoch,
        'ai_generated_at': aiGeneratedAt?.millisecondsSinceEpoch,
        'manual_synced_at': manualSyncedAt?.millisecondsSinceEpoch,
      };

  factory ProfileSection.fromMap(Map<String, dynamic> map) {
    return ProfileSection(
      key: map['section_key'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      hint: map['hint'] as String,
      content: map['content'] as String? ?? '',
      aiContent: map['ai_content'] as String? ?? '',
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
      aiGeneratedAt: map['ai_generated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ai_generated_at'] as int)
          : null,
      manualSyncedAt: map['manual_synced_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['manual_synced_at'] as int)
          : null,
    );
  }
}

/// Default section keys seeded into SQLite (metadata localized in UI).
const linkedInSections = [
  ProfileSection(
    key: 'headline',
    title: 'Headline',
    description: 'Headline section',
    hint: 'Headline hint',
  ),
  ProfileSection(
    key: 'about',
    title: 'About',
    description: 'About section',
    hint: 'About hint',
  ),
  ProfileSection(
    key: 'experience',
    title: 'Experience',
    description: 'Experience section',
    hint: 'Experience hint',
  ),
  ProfileSection(
    key: 'education',
    title: 'Education',
    description: 'Education section',
    hint: 'Education hint',
  ),
  ProfileSection(
    key: 'skills',
    title: 'Skills',
    description: 'Skills section',
    hint: 'Skills hint',
  ),
  ProfileSection(
    key: 'certifications',
    title: 'Certifications',
    description: 'Certifications section',
    hint: 'Certifications hint',
  ),
  ProfileSection(
    key: 'projects',
    title: 'Projects',
    description: 'Projects section',
    hint: 'Projects hint',
  ),
  ProfileSection(
    key: 'featured',
    title: 'Featured',
    description: 'Featured section',
    hint: 'Featured hint',
  ),
  ProfileSection(
    key: 'volunteer',
    title: 'Volunteering',
    description: 'Volunteer section',
    hint: 'Volunteer hint',
  ),
  ProfileSection(
    key: 'recommendations_received',
    title: 'Recommendations',
    description: 'Recommendations section',
    hint: 'Recommendations hint',
  ),
  ProfileSection(
    key: 'location_industry',
    title: 'Location & industry',
    description: 'Location and industry section',
    hint: 'Location and industry hint',
  ),
  ProfileSection(
    key: 'contact_links',
    title: 'Contact & links',
    description: 'Contact and links section',
    hint: 'Contact and links hint',
  ),
  ProfileSection(
    key: 'open_to_work',
    title: 'Open to work',
    description: 'Open to work section',
    hint: 'Open to work hint',
  ),
  ProfileSection(
    key: 'languages',
    title: 'Languages',
    description: 'Languages section',
    hint: 'Languages hint',
  ),
  ProfileSection(
    key: 'honors',
    title: 'Honors & awards',
    description: 'Honors section',
    hint: 'Honors hint',
  ),
  ProfileSection(
    key: 'publications',
    title: 'Publications',
    description: 'Publications section',
    hint: 'Publications hint',
  ),
  ProfileSection(
    key: 'patents',
    title: 'Patents',
    description: 'Patents section',
    hint: 'Patents hint',
  ),
  ProfileSection(
    key: 'courses',
    title: 'Courses',
    description: 'Courses section',
    hint: 'Courses hint',
  ),
  ProfileSection(
    key: 'organizations',
    title: 'Organizations',
    description: 'Organizations section',
    hint: 'Organizations hint',
  ),
  ProfileSection(
    key: 'services',
    title: 'Services',
    description: 'Services section',
    hint: 'Services hint',
  ),
  ProfileSection(
    key: 'causes',
    title: 'Causes',
    description: 'Causes section',
    hint: 'Causes hint',
  ),
  ProfileSection(
    key: 'recommendations_given',
    title: 'Recommendations given',
    description: 'Recommendations given section',
    hint: 'Recommendations given hint',
  ),
  ProfileSection(
    key: 'activity',
    title: 'Activity',
    description: 'Activity section',
    hint: 'Activity hint',
  ),
  ProfileSection(
    key: 'creator_newsletter',
    title: 'Creator & newsletter',
    description: 'Creator section',
    hint: 'Creator hint',
  ),
];
