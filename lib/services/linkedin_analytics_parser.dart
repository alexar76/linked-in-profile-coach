import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

import '../models/linkedin_analytics.dart';

/// Extracts time-series metrics from LinkedIn data-export CSV files.
class LinkedInAnalyticsParser {
  LinkedInAnalyticsBundle parseFromZipBytes(List<int> bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final csvByPath = <String, String>{};
    for (final file in archive) {
      if (file.isFile != true) continue;
      final norm = p.basename(file.name).toLowerCase();
      if (!norm.endsWith('.csv')) continue;
      csvByPath[norm] = utf8.decode(
        file.content as List<int>,
        allowMalformed: true,
      );
    }
    return parseFromCsvFiles(csvByPath);
  }

  LinkedInAnalyticsBundle parseFromCsvFiles(Map<String, String> csvByPath) {
    final series = <String, List<AnalyticsDataPoint>>{};

    for (final entry in csvByPath.entries) {
      final key = _metricKeyForFile(entry.key);
      if (key == null) continue;
      final points = _parseTimeSeriesCsv(entry.value);
      if (points.isNotEmpty) {
        series[key] = points;
      }
    }

    return LinkedInAnalyticsBundle(
      series: series,
      recordedAt: DateTime.now(),
    );
  }

  String? _metricKeyForFile(String normPath) {
    final n = normPath.toLowerCase();
    if (n.contains('profileview')) return 'profile_views';
    if (n.contains('searchappearance')) return 'search_appearances';
    if (n.contains('postanalytics') || n.contains('share')) {
      return 'post_impressions';
    }
    if (n.contains('follower')) return 'followers';
    if (n.contains('connection') && !n.contains('invitation')) {
      return 'connections';
    }
    if (n.contains('invitation')) return 'invitations';
    if (n.contains('endorsement')) return 'endorsements';
    return null;
  }

  List<AnalyticsDataPoint> _parseTimeSeriesCsv(String content) {
    final rows = _parseCsv(content);
    if (rows.length < 2) return [];

    final headers =
        rows.first.map((h) => h.trim().toLowerCase()).toList();
    final dateIdx = headers.indexWhere(
      (h) => h.contains('date') || h == 'day' || h == 'month',
    );
    if (dateIdx < 0) return [];

    var valueIdx = -1;
    for (var i = 0; i < headers.length; i++) {
      if (i == dateIdx) continue;
      final h = headers[i];
      if (h.contains('count') ||
          h.contains('views') ||
          h.contains('appearance') ||
          h.contains('impression') ||
          h.contains('total') ||
          h.contains('number')) {
        valueIdx = i;
        break;
      }
    }
    if (valueIdx < 0) valueIdx = headers.length > 1 ? (dateIdx == 0 ? 1 : 0) : -1;
    if (valueIdx < 0) return [];

    final points = <AnalyticsDataPoint>[];
    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];
      if (dateIdx >= row.length || valueIdx >= row.length) continue;
      final date = _parseDate(row[dateIdx].trim());
      final value = double.tryParse(
        row[valueIdx].replaceAll(RegExp(r'[^\d.]'), ''),
      );
      if (date == null || value == null) continue;
      points.add(AnalyticsDataPoint(date: date, value: value));
    }

    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
  }

  DateTime? _parseDate(String raw) {
    if (raw.isEmpty) return null;
    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;
    final parts = raw.split(RegExp(r'[/-]'));
    if (parts.length == 3) {
      final a = int.tryParse(parts[0]);
      final b = int.tryParse(parts[1]);
      final c = int.tryParse(parts[2]);
      if (a != null && b != null && c != null) {
        if (a > 31) return DateTime(a, b, c);
        return DateTime(c, b, a);
      }
    }
    return null;
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
        if (row.any((c) => c.trim().isNotEmpty)) rows.add(row);
        row = <String>[];
      } else {
        cell.write(ch);
      }
    }
    row.add(cell.toString());
    if (row.any((c) => c.trim().isNotEmpty)) rows.add(row);
    return rows;
  }
}
