enum AiProvider {
  deepseek,
  openai,
  openAiCompatible,
  anthropic,
  lmrouter,
  ollama,
}

class AiProviderPreset {
  const AiProviderPreset({
    required this.label,
    required this.baseUrl,
    required this.defaultModel,
    this.needsApiKey = true,
    this.hint,
  });

  final String label;
  final String baseUrl;
  final String defaultModel;
  final bool needsApiKey;
  final String? hint;
}

const aiProviderPresets = {
  AiProvider.deepseek: AiProviderPreset(
    label: 'DeepSeek',
    baseUrl: 'https://api.deepseek.com',
    defaultModel: 'deepseek-chat',
  ),
  AiProvider.openai: AiProviderPreset(
    label: 'OpenAI',
    baseUrl: 'https://api.openai.com/v1',
    defaultModel: 'gpt-4o-mini',
  ),
  AiProvider.openAiCompatible: AiProviderPreset(
    label: 'OpenAI-compatible',
    baseUrl: 'https://api.example.com/v1',
    defaultModel: 'gpt-4o-mini',
  ),
  AiProvider.anthropic: AiProviderPreset(
    label: 'Anthropic',
    baseUrl: 'https://api.anthropic.com',
    defaultModel: 'claude-sonnet-4-20250514',
  ),
  AiProvider.lmrouter: AiProviderPreset(
    label: 'LM Router',
    baseUrl: 'https://api.lmrouter.ai/v1',
    defaultModel: 'auto',
  ),
  AiProvider.ollama: AiProviderPreset(
    label: 'Ollama',
    baseUrl: 'http://127.0.0.1:11434/v1',
    defaultModel: 'llama3.2',
    needsApiKey: false,
  ),
};

class AiSettings {
  const AiSettings({
    this.provider = AiProvider.deepseek,
    this.apiKey = '',
    this.baseUrl = '',
    this.model = '',
    this.useLlm = true,
  });

  final AiProvider provider;
  final String apiKey;
  final String baseUrl;
  final String model;
  final bool useLlm;

  AiProviderPreset get preset => aiProviderPresets[provider]!;

  String get effectiveBaseUrl =>
      baseUrl.trim().isNotEmpty ? baseUrl.trim() : preset.baseUrl;

  String get effectiveModel =>
      model.trim().isNotEmpty ? model.trim() : preset.defaultModel;

  bool get canCallLlm {
    if (!useLlm) return false;
    if (!preset.needsApiKey) return true;
    return apiKey.trim().isNotEmpty;
  }

  Map<String, String> toSettingsMap() => {
        'ai_provider': provider.name,
        'ai_api_key': apiKey,
        'ai_base_url': baseUrl,
        'ai_model': model,
        'ai_use_llm': useLlm ? '1' : '0',
      };

  factory AiSettings.fromSettingsMap(Map<String, String?> map) {
    final providerName = map['ai_provider'] ?? 'deepseek';
    return AiSettings(
      provider: AiProvider.values.firstWhere(
        (p) => p.name == providerName,
        orElse: () => AiProvider.deepseek,
      ),
      apiKey: map['ai_api_key'] ?? '',
      baseUrl: map['ai_base_url'] ?? '',
      model: map['ai_model'] ?? '',
      useLlm: map['ai_use_llm'] != '0',
    );
  }
}
