import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAiCompatibleClient {
  OpenAiCompatibleClient({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
  });

  final String baseUrl;
  final String apiKey;
  final String model;

  String get _endpoint {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    if (base.endsWith('/chat/completions')) return base;
    if (base.endsWith('/v1')) return '$base/chat/completions';
    return '$base/v1/chat/completions';
  }

  Future<String> chat({
    required String system,
    required String user,
    double temperature = 0.7,
    int maxTokens = 4096,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: headers,
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': system},
          {'role': 'user', 'content': user},
        ],
        'temperature': temperature,
        'max_tokens': maxTokens,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LlmHttpException(
        response.statusCode,
        response.body,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = json['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw const LlmParseException('Пустой ответ API');
    }
    final message = choices.first['message'] as Map<String, dynamic>?;
    final content = message?['content'];
    if (content is! String || content.trim().isEmpty) {
      throw const LlmParseException('Нет текста в ответе');
    }
    return content.trim();
  }
}

class LlmHttpException implements Exception {
  LlmHttpException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() {
    var msg = body;
    try {
      final j = jsonDecode(body) as Map<String, dynamic>;
      msg = j['error']?['message']?.toString() ?? body;
    } catch (_) {}
    return 'HTTP $statusCode: $msg';
  }
}

class LlmParseException implements Exception {
  const LlmParseException(this.message);
  final String message;

  @override
  String toString() => message;
}
