import 'dart:convert';

import 'package:http/http.dart' as http;

/// Best-effort import from a public LinkedIn profile URL.
/// LinkedIn may block automated requests; partial data is still useful.
class LinkedInPublicProfileService {
  static final _profilePath = RegExp(
    r'linkedin\.com/in/([a-zA-Z0-9\-_%]+)',
    caseSensitive: false,
  );

  String? normalizeProfileUrl(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final withScheme = trimmed.startsWith('http')
        ? trimmed
        : 'https://$trimmed';
    final uri = Uri.tryParse(withScheme);
    if (uri == null || !_profilePath.hasMatch(uri.host + uri.path)) {
      return null;
    }
    final match = _profilePath.firstMatch(uri.toString());
    if (match == null) return null;
    final slug = match.group(1)!;
    return 'https://www.linkedin.com/in/$slug/';
  }

  Future<Map<String, String>> fetchSections(String profileUrl) async {
    final url = normalizeProfileUrl(profileUrl);
    if (url == null) {
      throw FormatException('Invalid LinkedIn profile URL');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: const {
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml',
        'Accept-Language': 'en-US,en;q=0.9,ru;q=0.8',
      },
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw StateError('HTTP ${response.statusCode}');
    }

    final html = response.body;
    final fromJsonLd = _parseJsonLd(html);
    if (fromJsonLd.isNotEmpty) return fromJsonLd;

    final fromMeta = _parseMetaTags(html);
    if (fromMeta.isNotEmpty) return fromMeta;

    throw StateError('Could not parse public profile page');
  }

  Map<String, String> _parseJsonLd(String html) {
    final result = <String, String>{};
    final scripts = RegExp(
      r'<script[^>]*type="application/ld\+json"[^>]*>([\s\S]*?)</script>',
      caseSensitive: false,
    ).allMatches(html);

    for (final match in scripts) {
      final raw = match.group(1)?.trim();
      if (raw == null || raw.isEmpty) continue;
      try {
        final decoded = jsonDecode(raw);
        _collectPerson(decoded, result);
      } catch (_) {
        continue;
      }
    }
    return result;
  }

  void _collectPerson(dynamic node, Map<String, String> out) {
    if (node is List) {
      for (final item in node) {
        _collectPerson(item, out);
      }
      return;
    }
    if (node is! Map) return;

    final type = node['@type']?.toString().toLowerCase() ?? '';
    if (type == 'person' || node.containsKey('jobTitle')) {
      final name = node['name']?.toString();
      final jobTitle = node['jobTitle']?.toString();
      final description = node['description']?.toString();
      if (jobTitle != null && jobTitle.isNotEmpty) {
        out['headline'] = jobTitle;
      } else if (name != null && name.isNotEmpty && !out.containsKey('headline')) {
        out['headline'] = name;
      }
      if (description != null && description.trim().isNotEmpty) {
        out['about'] = description.trim();
      }
    }

    for (final value in node.values) {
      _collectPerson(value, out);
    }
  }

  Map<String, String> _parseMetaTags(String html) {
    final result = <String, String>{};
    String? meta(String property) {
      final re = RegExp(
        '<meta[^>]+property="$property"[^>]+content="([^"]*)"',
        caseSensitive: false,
      );
      final m = re.firstMatch(html);
      return m?.group(1)?.replaceAll('&amp;', '&').replaceAll('&#39;', "'");
    }

    String? metaName(String name) {
      final re = RegExp(
        '<meta[^>]+name="$name"[^>]+content="([^"]*)"',
        caseSensitive: false,
      );
      final m = re.firstMatch(html);
      return m?.group(1);
    }

    final title = meta('og:title') ?? metaName('title');
    final desc = meta('og:description') ?? metaName('description');
    if (title != null && title.isNotEmpty) {
      result['headline'] = title.split('|').first.trim();
    }
    if (desc != null && desc.isNotEmpty) {
      result['about'] = desc;
    }
    return result;
  }
}
