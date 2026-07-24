import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

import '../models/profile_section.dart';
import 'linkedin_import_parser.dart';

/// Parses LinkedIn "Get a copy of your data" ZIP (CSVs) and nested JSON exports.
class LinkedInDataExportParser {
  Map<String, String> parseZipBytes(List<int> bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final csvByNormName = <String, String>{};
    Map<String, dynamic>? rootJson;

    for (final file in archive) {
      if (file.isFile != true) continue;
      final name = file.name;
      final norm = _normalizeName(name);
      final content = utf8.decode(file.content as List<int>, allowMalformed: true);
      if (norm.endsWith('.csv')) {
        csvByNormName[norm] = content;
      } else if (norm.endsWith('.json')) {
        try {
          final decoded = jsonDecode(content);
          if (decoded is Map<String, dynamic>) {
            rootJson ??= decoded;
          }
        } catch (_) {}
      }
    }

    final result = <String, String>{};
    if (csvByNormName.isNotEmpty) {
      result.addAll(_parseCsvBundle(csvByNormName));
    }
    if (rootJson != null) {
      result.addAll(_parseJsonExport(rootJson));
    }
    return _onlyKnownKeys(result);
  }

  Map<String, String> parseJsonExport(Map<String, dynamic> json) {
    return _onlyKnownKeys(_parseJsonExport(json));
  }

  /// Flat section map plus nested LinkedIn export keys.
  Map<String, String> parseAnyJson(Map<String, dynamic> json) {
    final flat = LinkedInImportParser().parseJson(json);
    final nested = _parseJsonExport(json);
    return _onlyKnownKeys({...nested, ...flat});
  }

  Map<String, String> _parseCsvBundle(Map<String, String> csvByNormName) {
    final out = <String, String>{};

    void merge(String sectionKey, String? text) {
      if (text == null || text.trim().isEmpty) return;
      final existing = out[sectionKey];
      if (existing == null || existing.isEmpty) {
        out[sectionKey] = text.trim();
      } else {
        out[sectionKey] = '$existing\n\n${text.trim()}';
      }
    }

    for (final entry in csvByNormName.entries) {
      final norm = entry.key;
      final rows = _parseCsv(entry.value);
      if (rows.isEmpty) continue;

      final section = _sectionForCsvName(norm);
      if (section == 'profile') {
        merge('headline', _profileField(rows, ['Headline', 'headline']));
        merge('about', _profileField(rows, ['Summary', 'summary', 'About']));
        merge(
          'location_industry',
          _profileField(rows, [
            'Industry',
            'industry',
            'Geo Location',
            'Location',
            'Address',
          ]),
        );
        merge(
          'contact_links',
          _profileField(rows, [
            'Websites',
            'Website',
            'Twitter Handles',
            'Email Address',
            'Phone Numbers',
            'Instant Messengers',
          ]),
        );
        merge(
          'open_to_work',
          _profileField(rows, [
            'Open to work',
            'Open To Work',
            'Job seeker',
          ]),
        );
        continue;
      }

      if (section == 'contact_links') {
        merge('contact_links', _formatTable(rows));
        continue;
      }

      if (section != null) {
        merge(section, _formatTable(rows));
      }
    }

    return out;
  }

  Map<String, String> _parseJsonExport(Map<String, dynamic> json) {
    final out = <String, String>{};

    void putText(String key, String text) {
      if (text.trim().isEmpty) return;
      final existing = out[key];
      out[key] = existing == null ? text.trim() : '${existing.trim()}\n\n${text.trim()}';
    }

    void put(String key, dynamic value) {
      final text = _stringifyJsonValue(value);
      if (text != null) putText(key, text);
    }

    for (final entry in json.entries) {
      final normKey = _normalizeName(entry.key);
      final section = _sectionForJsonKey(normKey);
      if (section == null) continue;
      put(section, entry.value);
    }

    final profile = json['profile'] ?? json['Profile'];
    if (profile is Map) {
      put('headline', profile['headline'] ?? profile['Headline']);
      put('about', profile['summary'] ?? profile['Summary'] ?? profile['about']);
      put(
        'location_industry',
        [
          profile['industry'],
          profile['location'],
          profile['geoLocation'],
          profile['address'],
        ],
      );
      put(
        'contact_links',
        [
          profile['websites'],
          profile['email'],
          profile['phone'],
        ],
      );
    }

    return out;
  }

  Map<String, String> _onlyKnownKeys(Map<String, String> input) {
    final keys = linkedInSections.map((s) => s.key).toSet();
    return Map.fromEntries(
      input.entries.where((e) => keys.contains(e.key) && e.value.trim().isNotEmpty),
    );
  }

  String? _sectionForCsvName(String normPath) {
    final base = p.basename(normPath);
    if (base.contains('profile') && !base.contains('summary')) return 'profile';
    if (base.contains('position') || base.contains('experience')) {
      return 'experience';
    }
    if (base.contains('education')) return 'education';
    if (base.contains('skill')) return 'skills';
    if (base.contains('certification')) return 'certifications';
    if (base.contains('language')) return 'languages';
    if (base.contains('course')) return 'courses';
    if (base.contains('project')) return 'projects';
    if (base.contains('publication')) return 'publications';
    if (base.contains('patent')) return 'patents';
    if (base.contains('honor') || base.contains('award')) return 'honors';
    if (base.contains('organization')) return 'organizations';
    if (base.contains('service')) return 'services';
    if (base.contains('volunteer')) return 'volunteer';
    if (base.contains('cause')) return 'causes';
    if (base.contains('recommendation') && base.contains('given')) {
      return 'recommendations_given';
    }
    if (base.contains('recommendation')) return 'recommendations_received';
    if (base.contains('email') ||
        base.contains('phone') ||
        base.contains('website')) {
      return 'contact_links';
    }
    if (base.contains('jobseeker') || base.contains('opentowork')) {
      return 'open_to_work';
    }
    if (base.contains('post') ||
        base.contains('share') ||
        base.contains('article') ||
        base.contains('richmedia')) {
      return 'activity';
    }
    if (base.contains('newsletter') || base.contains('creator')) {
      return 'creator_newsletter';
    }
    if (base.contains('featured')) return 'featured';
    return null;
  }

  String? _sectionForJsonKey(String normKey) {
    return switch (normKey) {
      'positions' || 'position' || 'experiences' || 'experience' =>
        'experience',
      'education' || 'educations' => 'education',
      'skills' || 'skill' => 'skills',
      'certifications' || 'certification' => 'certifications',
      'languages' || 'language' => 'languages',
      'courses' || 'course' => 'courses',
      'projects' || 'project' => 'projects',
      'publications' || 'publication' => 'publications',
      'patents' || 'patent' => 'patents',
      'honors' || 'honorsawards' || 'awards' => 'honors',
      'organizations' || 'organization' => 'organizations',
      'services' || 'service' => 'services',
      'volunteerexperiences' || 'volunteer' => 'volunteer',
      'causes' || 'causesyoucareabout' => 'causes',
      'recommendationsreceived' || 'recommendations_received' =>
        'recommendations_received',
      'recommendationsgiven' || 'recommendations_given' =>
        'recommendations_given',
      'posts' || 'shares' || 'articles' || 'activity' => 'activity',
      'newsletters' || 'creator' => 'creator_newsletter',
      'featured' || 'richmedia' => 'featured',
      'websites' || 'emailaddresses' || 'phonenumbers' => 'contact_links',
      'jobseekerpreferences' || 'opentowork' => 'open_to_work',
      'headline' => 'headline',
      'about' || 'summary' => 'about',
      'location' || 'industry' || 'locationindustry' => 'location_industry',
      _ => null,
    };
  }

  String? _profileField(List<List<String>> rows, List<String> headerNames) {
    if (rows.length < 2) return null;
    final headers = rows.first.map((h) => h.trim()).toList();
    final dataRow = rows[1];
    final parts = <String>[];
    for (final name in headerNames) {
      final idx = headers.indexWhere(
        (h) => h.toLowerCase() == name.toLowerCase(),
      );
      if (idx >= 0 && idx < dataRow.length) {
        final v = dataRow[idx].trim();
        if (v.isNotEmpty) parts.add('$name: $v');
      }
    }
    if (parts.isEmpty) return null;
    return parts.join('\n');
  }

  String _formatTable(List<List<String>> rows) {
    if (rows.isEmpty) return '';
    final headers = rows.first.map((e) => e.trim()).toList();
    final buffer = StringBuffer();
    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];
      if (row.every((c) => c.trim().isEmpty)) continue;
      for (var c = 0; c < headers.length && c < row.length; c++) {
        final value = row[c].trim();
        if (value.isEmpty) continue;
        final header = headers[c].isEmpty ? 'Field' : headers[c];
        buffer.writeln('$header: $value');
      }
      if (r < rows.length - 1) buffer.writeln('---');
    }
    return buffer.toString().trim();
  }

  String? _stringifyJsonValue(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    if (value is List) {
      final parts = value
          .map(_stringifyJsonValue)
          .whereType<String>()
          .where((s) => s.trim().isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join('\n---\n');
    }
    if (value is Map) {
      final buffer = StringBuffer();
      for (final e in value.entries) {
        final v = _stringifyJsonValue(e.value);
        if (v == null || v.trim().isEmpty) continue;
        buffer.writeln('${e.key}: $v');
      }
      return buffer.toString().trim();
    }
    return value.toString();
  }

  List<List<String>> _parseCsv(String content) {
    final text = content.startsWith('\uFEFF')
        ? content.substring(1)
        : content;
    final rows = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (inQuotes) {
        if (ch == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          cell.write(ch);
        }
        continue;
      }

      if (ch == '"') {
        inQuotes = true;
      } else if (ch == ',') {
        row.add(cell.toString());
        cell.clear();
      } else if (ch == '\n' || ch == '\r') {
        if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') {
          i++;
        }
        row.add(cell.toString());
        cell.clear();
        if (row.any((c) => c.trim().isNotEmpty)) {
          rows.add(row);
        }
        row = <String>[];
      } else {
        cell.write(ch);
      }
    }

    row.add(cell.toString());
    if (row.any((c) => c.trim().isNotEmpty)) {
      rows.add(row);
    }
    return rows;
  }

  String _normalizeName(String path) =>
      p.basename(path).toLowerCase().replaceAll(RegExp(r'[\s_\-]'), '');
}
