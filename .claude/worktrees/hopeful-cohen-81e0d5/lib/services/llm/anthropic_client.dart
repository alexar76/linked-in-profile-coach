import 'dart:convert';

import 'package:http/http.dart' as http;

import 'openai_compatible_client.dart';

class AnthropicClient {
  AnthropicClient({
    required this.apiKey,
    required this.model,
    this.baseUrl = 'https://api.anthropic.com',
  });

  final String apiKey;
  final String model;
  final String baseUrl;

  Future<String> chat({
    required String system,
    required String user,
    int maxTokens = 4096,
  }) async {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final uri = Uri.parse('$base/v1/messages');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': model,
        'max_tokens': maxTokens,
        'system': system,
        'messages': [
          {'role': 'user', 'content': user},
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LlmHttpException(response.statusCode, response.body);
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final content = json['content'] as List<dynamic>?;
    if (content == null || content.isEmpty) {
      throw const LlmParseException('Пустой ответ Anthropic');
    }
    final first = content.first as Map<String, dynamic>;
    final text = first['text'];
    if (text is! String || text.trim().isEmpty) {
      throw const LlmParseException('Нет текста в ответе Anthropic');
    }
    return text.trim();
  }
}
