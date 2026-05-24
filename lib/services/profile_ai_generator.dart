import '../models/profile_language.dart';
import '../models/profile_section.dart';

class ProfileAiGenerator {
  Map<String, String> generate({
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
    required String displayName,
    required String? resumeText,
    ProfileLanguage profileLanguage = ProfileLanguage.en,
  }) {
    final byKey = {for (final s in sections) s.key: s};
    final resume = resumeText ?? '';

    final result = <String, String>{
      'headline': _headline(byKey, targetRole, targetIndustry, resume),
      'about': _about(byKey, targetRole, targetIndustry, displayName, resume),
      'experience': _experience(byKey['experience']!, resume),
      'education': _passthroughOrEnhance(byKey['education']!),
      'skills': _skills(byKey['skills']!, resume, targetRole),
      'certifications': _passthroughOrEnhance(byKey['certifications']!),
      'projects': _projects(byKey['projects']!, resume),
      'featured': _featured(byKey['featured']!),
      'volunteer': _passthroughOrEnhance(byKey['volunteer']!),
      'recommendations_received':
          _recommendations(byKey['recommendations_received']!),
    };
    for (final section in sections) {
      result.putIfAbsent(
        section.key,
        () => section.content.trim(),
      );
    }
    return result;
  }

  String _headline(
    Map<String, ProfileSection> byKey,
    String role,
    String industry,
    String resume,
  ) {
    final current = byKey['headline']!.content.trim();
    if (role.isNotEmpty) {
      final parts = <String>[role];
      if (industry.isNotEmpty) parts.add(industry);
      final skills = _topSkills(byKey['skills']!.content, resume, 3);
      if (skills.isNotEmpty) parts.add(skills.join(' • '));
      final generated = parts.join(' | ');
      if (current.isEmpty || current.length < 50) return generated;
      if (!current.toLowerCase().contains(role.toLowerCase())) {
        return '$generated\n\n— Было: $current';
      }
    }
    if (current.isEmpty) return 'Укажите целевую роль в админке для генерации заголовка';
    return _improveHeadline(current);
  }

  String _improveHeadline(String current) {
    if (current.contains('|') || current.contains('•')) return current;
    return '$current | Добавьте специализацию и формат работы';
  }

  String _about(
    Map<String, ProfileSection> byKey,
    String role,
    String industry,
    String name,
    String resume,
  ) {
    final current = byKey['about']!.content.trim();
    final exp = byKey['experience']!.content.trim();
    final greeting = name.isNotEmpty ? 'Привет! Я $name.' : 'Привет!';

    final buffer = StringBuffer();
    buffer.writeln(greeting);
    buffer.writeln();

    if (role.isNotEmpty) {
      buffer.writeln(
        'Специализируюсь на позиции «$role»${industry.isNotEmpty ? ' в сфере $industry' : ''}.',
      );
    } else if (current.isNotEmpty) {
      buffer.writeln(current.split('\n').first);
    }

    buffer.writeln();
    if (exp.isNotEmpty) {
      final snippet = exp.length > 500 ? '${exp.substring(0, 500)}...' : exp;
      buffer.writeln('Ключевой опыт:');
      buffer.writeln(snippet);
      buffer.writeln();
    }

    if (resume.isNotEmpty && current.length < 400) {
      final resumeSnippet =
          resume.length > 600 ? resume.substring(0, 600) : resume;
      buffer.writeln('Из резюме: $resumeSnippet');
      buffer.writeln();
    } else if (current.length > 400) {
      buffer.writeln(current);
      buffer.writeln();
    }

    buffer.writeln(
      'Открыт(а) к обсуждению возможностей — напишите в LinkedIn или оставьте сообщение.',
    );

    return buffer.toString().trim();
  }

  String _experience(ProfileSection section, String resume) {
    final current = section.content.trim();
    if (current.isEmpty && resume.isNotEmpty) {
      return 'Перенесите из резюме (адаптируйте под LinkedIn):\n\n'
          '${resume.length > 2000 ? resume.substring(0, 2000) : resume}';
    }
    if (current.isEmpty) {
      return 'Добавьте опыт: компания — роль — период — 3–5 буллетов с метриками.';
    }

    final lines = current.split('\n');
    final improved = <String>[];
    for (final line in lines) {
      final t = line.trim();
      if (t.isEmpty) {
        improved.add('');
        continue;
      }
      if (t.startsWith('•') ||
          t.startsWith('-') ||
          t.startsWith('*') ||
          RegExp(r'^\d+\.').hasMatch(t)) {
        improved.add(_enhanceBullet(t));
      } else {
        improved.add(t);
      }
    }
    return improved.join('\n').trim();
  }

  String _enhanceBullet(String line) {
    if (RegExp(r'\d').hasMatch(line)) return line;
    return '$line (добавьте метрику: %, срок, объём)';
  }

  String _skills(ProfileSection section, String resume, String role) {
    final current = _splitSkills(section.content);
    final fromResume = _extractSkillsFromResume(resume);
    final merged = <String>{...current, ...fromResume};
    if (role.isNotEmpty) {
      for (final token in role.split(RegExp(r'[^\w+#.]+'))) {
        if (token.length > 2) merged.add(token);
      }
    }
    return merged.take(35).join(', ');
  }

  String _projects(ProfileSection section, String resume) {
    if (section.content.trim().isNotEmpty) return section.content.trim();
    if (resume.toLowerCase().contains('project') ||
        resume.toLowerCase().contains('проект')) {
      return 'Добавьте 1–2 проекта из резюме с ссылкой на GitHub/демо.';
    }
    return section.hint;
  }

  String _featured(ProfileSection section) {
    if (section.content.trim().isNotEmpty) return section.content.trim();
    return 'Закрепите лучший пост или портфолио в разделе Featured.';
  }

  String _recommendations(ProfileSection section) {
    if (section.content.trim().isNotEmpty) return section.content.trim();
    return 'План: запросить 2 рекомендации у коллег (лидерство + технический кейс).';
  }

  String _passthroughOrEnhance(ProfileSection section) {
    final c = section.content.trim();
    return c.isNotEmpty ? c : section.hint;
  }

  List<String> _splitSkills(String text) {
    return text
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  List<String> _topSkills(String skillsText, String resume, int n) {
    final all = {..._splitSkills(skillsText), ..._extractSkillsFromResume(resume)};
    return all.take(n).toList();
  }

  List<String> _extractSkillsFromResume(String resume) {
    const known = [
      'Flutter', 'Dart', 'Python', 'React', 'TypeScript', 'SQL',
      'Docker', 'AWS', 'Kubernetes', 'Git', 'Agile',
    ];
    final lower = resume.toLowerCase();
    return known.where((s) => lower.contains(s.toLowerCase())).toList();
  }
}
