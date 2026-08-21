import '../models/profile_language.dart';
import '../models/profile_section.dart';
import '../models/recommendation_item.dart';
import 'analyzer_catalog.dart';

class ProfileAnalyzer {
  ProfileAnalyzer({ProfileLanguage language = ProfileLanguage.en})
      : _m = AnalyzerCatalog(language);

  final AnalyzerCatalog _m;

  List<RecommendationItem> analyze({
    required List<ProfileSection> sections,
    required String? resumeText,
    required String targetRole,
    required String targetIndustry,
    ProfileLanguage? language,
  }) {
    final catalog = language != null ? AnalyzerCatalog(language) : _m;
    final byKey = {for (final s in sections) s.key: s};
    final items = <RecommendationItem>[];

    items.addAll(_analyzeHeadline(byKey['headline']!, targetRole, catalog));
    items.addAll(_analyzeAbout(byKey['about']!, catalog));
    items.addAll(_analyzeExperience(byKey['experience']!, catalog));
    items.addAll(_analyzeEducation(byKey['education']!, catalog));
    items.addAll(_analyzeSkills(byKey['skills']!, targetRole, catalog));
    items.addAll(_analyzeCertifications(byKey['certifications']!, catalog));
    items.addAll(_analyzeProjects(byKey['projects']!, catalog));
    items.addAll(_analyzeFeatured(byKey['featured']!, catalog));
    items.addAll(_analyzeVolunteer(byKey['volunteer']!));
    items.addAll(_analyzeRecommendations(byKey['recommendations_received']!, catalog));

    const optionalKeys = [
      'location_industry',
      'contact_links',
      'open_to_work',
      'languages',
      'honors',
      'publications',
      'patents',
      'courses',
      'organizations',
      'services',
      'causes',
      'recommendations_given',
      'activity',
      'creator_newsletter',
    ];
    for (final key in optionalKeys) {
      final section = byKey[key];
      if (section != null) {
        items.addAll(_analyzeOptionalSection(section, catalog));
      }
    }

    items.addAll(
      _promotionTips(
        sections: sections,
        targetRole: targetRole,
        targetIndustry: targetIndustry,
        catalog: catalog,
      ),
    );

    if (resumeText != null && resumeText.trim().isNotEmpty) {
      items.addAll(
        _alignWithResume(
          sections: sections,
          resumeText: resumeText,
          targetRole: targetRole,
          catalog: catalog,
        ),
      );
    }

    return items;
  }

  List<RecommendationItem> _analyzeHeadline(
    ProfileSection section,
    String targetRole,
    AnalyzerCatalog m,
  ) {
    final text = section.content.trim();
    final items = <RecommendationItem>[];

    if (text.isEmpty) {
      final msg = m.headlineEmpty();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
      return items;
    }

    if (text.length < 40) {
      final msg = m.headlineTooShort(text.length);
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
    }

    if (text.length > 220) {
      final msg = m.headlineTooLong();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.fill));
    }

    if (targetRole.isNotEmpty &&
        !text.toLowerCase().contains(targetRole.toLowerCase())) {
      final msg = m.headlineMissingRole(targetRole);
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.align));
    }

    if (!_hasSeparator(text)) {
      final msg = m.headlineStructure();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.fill));
    }

    return items;
  }

  List<RecommendationItem> _analyzeAbout(ProfileSection section, AnalyzerCatalog m) {
    final text = section.content.trim();
    final items = <RecommendationItem>[];

    if (text.isEmpty) {
      final msg = m.aboutEmpty();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
      return items;
    }

    if (text.length < 400) {
      final msg = m.aboutTooShort(text.length);
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
    }

    if (!_containsMetric(text)) {
      final msg = m.aboutMetrics();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
    }

    if (!_hasCallToAction(text)) {
      final msg = m.aboutCta();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.fill));
    }

    return items;
  }

  List<RecommendationItem> _analyzeExperience(ProfileSection section, AnalyzerCatalog m) {
    final text = section.content.trim();
    final items = <RecommendationItem>[];

    if (text.isEmpty) {
      final msg = m.experienceEmpty();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
      return items;
    }

    if (!_containsMetric(text)) {
      final msg = m.experienceMetrics();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
    }

    if (!_hasActionVerbs(text)) {
      final msg = m.experienceActionVerbs();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.fill));
    }

    return items;
  }

  List<RecommendationItem> _analyzeEducation(ProfileSection section, AnalyzerCatalog m) {
    if (section.content.trim().isEmpty) {
      final msg = m.educationEmpty();
      return [
        _item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.fill),
      ];
    }
    return [];
  }

  List<RecommendationItem> _analyzeSkills(
    ProfileSection section,
    String targetRole,
    AnalyzerCatalog m,
  ) {
    final text = section.content.trim();
    final items = <RecommendationItem>[];

    if (text.isEmpty) {
      final msg = m.skillsEmpty();
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.high, RecommendationCategory.fill));
      return items;
    }

    final skills = _splitList(text);
    if (skills.length < 8) {
      final msg = m.skillsTooFew(skills.length);
      items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.fill));
    }

    if (targetRole.isNotEmpty) {
      final roleTokens = _tokenize(targetRole);
      final missing = roleTokens
          .where((t) => t.length > 3 && !text.toLowerCase().contains(t))
          .take(3)
          .toList();
      if (missing.isNotEmpty) {
        final msg = m.skillsMissingRole(missing.join(', '));
        items.add(_item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.align));
      }
    }

    return items;
  }

  List<RecommendationItem> _analyzeCertifications(ProfileSection section, AnalyzerCatalog m) {
    if (section.content.trim().length < 20) {
      final msg = m.certificationsEmpty();
      return [
        _item(section, msg.$1, msg.$2, RecommendationPriority.low, RecommendationCategory.fill),
      ];
    }
    return [];
  }

  List<RecommendationItem> _analyzeProjects(ProfileSection section, AnalyzerCatalog m) {
    if (section.content.trim().isEmpty) {
      final msg = m.projectsEmpty();
      return [
        _item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.fill),
      ];
    }
    return [];
  }

  List<RecommendationItem> _analyzeFeatured(ProfileSection section, AnalyzerCatalog m) {
    if (section.content.trim().isEmpty) {
      final msg = m.featuredEmpty();
      return [
        _item(section, msg.$1, msg.$2, RecommendationPriority.medium, RecommendationCategory.promote),
      ];
    }
    return [];
  }

  List<RecommendationItem> _analyzeVolunteer(ProfileSection section) => [];

  List<RecommendationItem> _analyzeOptionalSection(
    ProfileSection section,
    AnalyzerCatalog m,
  ) {
    if (section.content.trim().isEmpty) {
      final msg = m.sectionEmpty(section.title);
      return [
        _item(
          section,
          msg.$1,
          msg.$2,
          RecommendationPriority.low,
          RecommendationCategory.fill,
        ),
      ];
    }
    return [];
  }

  List<RecommendationItem> _analyzeRecommendations(
    ProfileSection section,
    AnalyzerCatalog m,
  ) {
    if (section.content.trim().isEmpty) {
      final msg = m.recommendationsEmpty();
      return [
        _item(section, msg.$1, msg.$2, RecommendationPriority.low, RecommendationCategory.promote),
      ];
    }
    return [];
  }

  List<RecommendationItem> _promotionTips({
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required AnalyzerCatalog catalog,
  }) {
    final filled = sections.where((s) => s.content.trim().isNotEmpty).length;
    final total = sections.length;
    final completeness = (filled / total * 100).round();

    final completenessMsg = completeness < 70
        ? catalog.completenessLow(completeness)
        : catalog.completenessOk(targetIndustry);
    final searchMsg = catalog.recruiterSearch(targetRole);
    final networkMsg = catalog.networking();

    return [
      RecommendationItem(
        sectionKey: 'general',
        title: completenessMsg.$1,
        body: completenessMsg.$2,
        priority: completeness < 70
            ? RecommendationPriority.high
            : RecommendationPriority.low,
        category: RecommendationCategory.promote,
      ),
      RecommendationItem(
        sectionKey: 'general',
        title: searchMsg.$1,
        body: searchMsg.$2,
        priority: RecommendationPriority.medium,
        category: RecommendationCategory.promote,
      ),
      RecommendationItem(
        sectionKey: 'general',
        title: networkMsg.$1,
        body: networkMsg.$2,
        priority: RecommendationPriority.low,
        category: RecommendationCategory.promote,
      ),
    ];
  }

  List<RecommendationItem> _alignWithResume({
    required List<ProfileSection> sections,
    required String resumeText,
    required String targetRole,
    required AnalyzerCatalog catalog,
  }) {
    final items = <RecommendationItem>[];
    final resumeLower = resumeText.toLowerCase();
    final profileBlob = sections.map((s) => s.content).join(' ').toLowerCase();

    final resumeSkills = _extractLikelySkills(resumeText);
    final missingInProfile =
        resumeSkills.where((s) => !profileBlob.contains(s.toLowerCase())).take(8).toList();

    if (missingInProfile.isNotEmpty) {
      final msg = catalog.resumeSkillsMissing(missingInProfile.join(', '));
      items.add(
        RecommendationItem(
          sectionKey: 'skills',
          title: msg.$1,
          body: msg.$2,
          priority: RecommendationPriority.high,
          category: RecommendationCategory.align,
        ),
      );
    }

    final experienceSection = sections.firstWhere((s) => s.key == 'experience');
    if (experienceSection.content.trim().length < resumeText.length * 0.15) {
      final msg = catalog.experienceShorterThanResume();
      items.add(
        RecommendationItem(
          sectionKey: 'experience',
          title: msg.$1,
          body: msg.$2,
          priority: RecommendationPriority.high,
          category: RecommendationCategory.align,
        ),
      );
    }

    if (targetRole.isNotEmpty && !resumeLower.contains(targetRole.toLowerCase())) {
      final msg = catalog.roleResumeMismatch(targetRole);
      items.add(
        RecommendationItem(
          sectionKey: 'general',
          title: msg.$1,
          body: msg.$2,
          priority: RecommendationPriority.medium,
          category: RecommendationCategory.align,
        ),
      );
    }

    return items;
  }

  RecommendationItem _item(
    ProfileSection section,
    String title,
    String body,
    RecommendationPriority priority,
    RecommendationCategory category,
  ) {
    return RecommendationItem(
      sectionKey: section.key,
      title: title,
      body: body,
      priority: priority,
      category: category,
      source: RecommendationSource.rules,
    );
  }

  bool _hasSeparator(String text) => text.contains('|') || text.contains('•');

  bool _containsMetric(String text) => RegExp(
        r'\d+[%+]?|\d+\s*(years?|yrs?|лет|год|мес|month|чел|users?|k|K|млн|тыс|million)',
        caseSensitive: false,
      ).hasMatch(text);

  bool _hasCallToAction(String text) {
    final lower = text.toLowerCase();
    return lower.contains('связ') ||
        lower.contains('напиш') ||
        lower.contains('пишите') ||
        lower.contains('contact') ||
        lower.contains('reach out') ||
        lower.contains('email') ||
        lower.contains('telegram') ||
        lower.contains('message me') ||
        lower.contains('escríb') ||
        lower.contains('contáct');
  }

  bool _hasActionVerbs(String text) {
    final lower = text.toLowerCase();
    const verbs = [
      'разработ', 'внедр', 'оптимиз', 'руковод', 'создал', 'улучш',
      'built', 'led', 'developed', 'implemented', 'delivered', 'managed',
      'desarroll', 'implement', 'lider',
    ];
    return verbs.any(lower.contains);
  }

  List<String> _splitList(String text) {
    return text
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  List<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
        .where((t) => t.length > 2)
        .toList();
  }

  List<String> _extractLikelySkills(String text) {
    const known = [
      'Flutter', 'Dart', 'Python', 'Java', 'Kotlin', 'Swift', 'React',
      'TypeScript', 'JavaScript', 'SQL', 'SQLite', 'PostgreSQL', 'Docker',
      'Kubernetes', 'AWS', 'GCP', 'Azure', 'Git', 'CI/CD', 'Agile', 'Scrum',
      'Figma', 'REST', 'GraphQL', 'Machine Learning', 'TensorFlow', 'PyTorch',
      'Product Management', 'Project Management', 'Leadership', 'English', 'German',
    ];

    final found = <String>[];
    final lower = text.toLowerCase();
    for (final skill in known) {
      if (lower.contains(skill.toLowerCase())) {
        found.add(skill);
      }
    }
    return found;
  }
}
