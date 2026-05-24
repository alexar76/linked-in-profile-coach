import '../../models/ai_settings.dart';
import 'aimarket_client.dart';
import 'anthropic_client.dart';
import 'openai_compatible_client.dart';

class LlmService {
  Future<String> complete({
    required AiSettings settings,
    required String system,
    required String user,
    double temperature = 0.7,
  }) async {
    if (settings.provider == AiProvider.anthropic) {
      final client = AnthropicClient(
        apiKey: settings.apiKey,
        model: settings.effectiveModel,
        baseUrl: settings.effectiveBaseUrl,
      );
      return client.chat(
        system: system,
        user: user,
        temperature: temperature,
      );
    }

    if (settings.provider == AiProvider.aimarket) {
      final client = AimarketClient(
        hubUrl: settings.effectiveBaseUrl,
        walletKey: settings.apiKey,
      );
      return client.chat(
        system: system,
        user: user,
        temperature: temperature,
      );
    }

    final client = OpenAiCompatibleClient(
      baseUrl: settings.effectiveBaseUrl,
      apiKey: settings.apiKey,
      model: settings.effectiveModel,
    );
    return client.chat(
      system: system,
      user: user,
      temperature: temperature,
    );
  }

  Future<String> testConnection(AiSettings settings) async {
    return complete(
      settings: settings,
      system: 'You are a helpful assistant.',
      user: 'Reply with exactly: OK',
    );
  }
}
