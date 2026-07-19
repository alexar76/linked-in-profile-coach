import 'dart:convert';

/// Extracts a JSON object from LLM text (strips markdown fences).
Map<String, dynamic> parseLlmJsonObject(String raw) {
  var text = raw.trim();
  if (text.startsWith('```')) {
    text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
    text = text.replaceFirst(RegExp(r'\s*```$'), '');
  }
  final start = text.indexOf('{');
  final end = text.lastIndexOf('}');
  if (start < 0 || end <= start) {
    throw const FormatException('JSON object not found in LLM response');
  }
  return jsonDecode(text.substring(start, end + 1)) as Map<String, dynamic>;
}

List<dynamic> parseLlmJsonArray(String raw) {
  var text = raw.trim();
  if (text.startsWith('```')) {
    text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
    text = text.replaceFirst(RegExp(r'\s*```$'), '');
  }
  final start = text.indexOf('[');
  final end = text.lastIndexOf(']');
  if (start < 0 || end <= start) {
    throw const FormatException('JSON array not found in LLM response');
  }
  return jsonDecode(text.substring(start, end + 1)) as List<dynamic>;
}
