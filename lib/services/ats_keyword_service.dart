import '../models/ats_match_result.dart';
import '../models/profile_section.dart';

class AtsKeywordService {
  AtsMatchResult analyze({
    required List<ProfileSection> sections,
    required String targetRole,
    required String targetIndustry,
  }) {
    final role = targetRole.trim();
    if (role.isEmpty) {
      return const AtsMatchResult(
        scorePercent: 0,
        matchedKeywords: [],
        missingKeywords: [],
        targetRole: '',
      );
    }

    final keywords = _extractKeywords(role, targetIndustry);
    if (keywords.isEmpty) {
      return AtsMatchResult(
        scorePercent: 0,
        matchedKeywords: const [],
        missingKeywords: const [],
        targetRole: role,
      );
    }

    final blob = sections
        .where((s) => _scoringKeys.contains(s.key))
        .map((s) => s.content.toLowerCase())
        .join(' ');

    final matched = <String>[];
    final missing = <String>[];
    for (final kw in keywords) {
      if (blob.contains(kw.toLowerCase())) {
        matched.add(kw);
      } else {
        missing.add(kw);
      }
    }

    final score = ((matched.length / keywords.length) * 100).round();

    return AtsMatchResult(
      scorePercent: score,
      matchedKeywords: matched,
      missingKeywords: missing,
      targetRole: role,
    );
  }

  static const _scoringKeys = {
    'headline',
    'about',
    'experience',
    'skills',
    'education',
    'certifications',
    'languages',
  };

  List<String> _extractKeywords(String role, String industry) {
    final raw = '$role $industry'
        .toLowerCase()
        .replaceAll(RegExp(r'[|/,•·]+'), ' ')
        .replaceAll(RegExp(r'[^\w\s+#.-]'), ' ');
    final stop = {
      'and',
      'or',
      'the',
      'a',
      'an',
      'for',
      'with',
      'senior',
      'junior',
      'lead',
      'remote',
      'и',
      'или',
      'для',
    };
    final words = raw
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2 && !stop.contains(w))
        .toSet()
        .toList();
    words.sort((a, b) => b.length.compareTo(a.length));
    return words.take(12).toList();
  }
}
