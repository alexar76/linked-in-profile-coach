import '../models/profile_section.dart';

class LinkedInImportParser {
  static const _pastePatterns = <String, List<String>>{
    'headline': ['headline', 'заголовок', 'head line'],
    'about': ['about', 'о себе', 'summary', 'обо мне'],
    'location_industry': [
      'location & industry',
      'location and industry',
      'location',
      'industry',
      'локация',
      'отрасль',
    ],
    'contact_links': [
      'contact & links',
      'contact and links',
      'contact',
      'links',
      'websites',
      'контакты',
      'ссылки',
    ],
    'open_to_work': [
      'open to work',
      'career interests',
      'job preferences',
      'открыт к предложениям',
    ],
    'experience': ['experience', 'опыт', 'work experience'],
    'education': ['education', 'образование'],
    'skills': ['skills', 'навыки', 'skill'],
    'certifications': [
      'certifications',
      'сертификат',
      'licenses',
      'certifications & licenses',
    ],
    'languages': ['languages', 'языки', 'language'],
    'courses': ['courses', 'курсы', 'course'],
    'projects': ['projects', 'проекты'],
    'publications': ['publications', 'публикации'],
    'patents': ['patents', 'патенты'],
    'honors': ['honors', 'honors & awards', 'awards', 'награды'],
    'organizations': ['organizations', 'организации'],
    'services': ['services', 'услуги'],
    'featured': ['featured', 'избранное'],
    'volunteer': ['volunteer', 'волонтёр', 'volunteering'],
    'causes': ['causes', 'causes you care about', 'ценности'],
    'recommendations_given': [
      'recommendations given',
      'given recommendations',
      'рекомендации (данные)',
    ],
    'recommendations_received': [
      'recommendations received',
      'received recommendations',
      'recommendations',
      'рекомендации',
    ],
    'activity': ['activity', 'posts', 'recent activity', 'активность'],
    'creator_newsletter': [
      'creator',
      'newsletter',
      'creator & newsletter',
    ],
  };

  Map<String, String> parseBulkPaste(String text) {
    final result = <String, String>{};
    final lines = text.split('\n');
    String? currentKey;
    final buffer = StringBuffer();

    void flush() {
      if (currentKey != null && buffer.isNotEmpty) {
        result[currentKey] = buffer.toString().trim();
      }
      buffer.clear();
    }

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      String? matchedKey;
      for (final entry in _pastePatterns.entries) {
        for (final label in entry.value) {
          final regex = RegExp(
            r'^#*\s*' + RegExp.escape(label) + r'\s*:?\s*$',
            caseSensitive: false,
          );
          if (regex.hasMatch(trimmed)) {
            matchedKey = entry.key;
            break;
          }
        }
        if (matchedKey != null) break;
      }

      if (matchedKey != null) {
        flush();
        currentKey = matchedKey;
        continue;
      }

      if (currentKey != null) {
        if (buffer.isNotEmpty) buffer.writeln();
        buffer.write(line);
      }
    }
    flush();
    return result;
  }

  Map<String, String> parseJson(Map<String, dynamic> json) {
    final keys = linkedInSections.map((s) => s.key).toSet();
    final result = <String, String>{};
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        result[key] = value.trim();
      }
    }
    return result;
  }
}
