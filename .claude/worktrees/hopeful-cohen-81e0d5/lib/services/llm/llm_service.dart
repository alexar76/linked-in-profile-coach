import '../../models/ai_settings.dart';
import 'anthropic_client.dart';
import 'openai_compatible_client.dart';

class LlmService {
  Future<String> complete({
    required AiSettings settings,
    required String system,
    required String user,
  }) async {
    if (settings.provider == AiProvider.anthropic) {
      final client = AnthropicClient(
        apiKey: settings.apiKey,
        model: settings.effectiveModel,
        baseUrl: settings.effectiveBaseUrl,
      );
      return client.chat(system: system, user: user);
    }

    final client = OpenAiCompatibleClient(
      baseUrl: settings.effectiveBaseUrl,
      apiKey: settings.apiKey,
      model: settings.effectiveModel,
    );
    return client.chat(system: system, user: user);
  }

  Future<String> testConnection(AiSettings settings) async {
    return complete(
      settings: settings,
      system: 'You are a helpful assistant.',
      user: 'Reply with exactly: OK',
    );
  }
}
