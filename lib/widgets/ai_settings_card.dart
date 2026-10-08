import 'package:flutter/material.dart';

import '../models/ai_generation_prefs.dart';
import '../models/ai_settings.dart';
import '../repositories/app_repository.dart';
import '../utils/l10n_ext.dart';
import '../utils/section_l10n.dart';
import 'profile_language_picker.dart';

class AiSettingsCard extends StatefulWidget {
  const AiSettingsCard({
    super.key,
    required this.repo,
    this.onLocaleChanged,
  });

  final AppRepository repo;
  final ValueChanged<Locale>? onLocaleChanged;

  @override
  State<AiSettingsCard> createState() => _AiSettingsCardState();
}

class _AiSettingsCardState extends State<AiSettingsCard> {
  AiProvider _provider = AiProvider.deepseek;
  final _apiKeyController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _modelController = TextEditingController();
  bool _useLlm = true;
  bool _obscureKey = true;
  bool _testing = false;
  bool _loaded = false;
  double _creativity = 0.7;
  int _variantCount = 1;
  ProfileAiFocus _focus = ProfileAiFocus.jobSearch;
  bool _skipGenDialog = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await widget.repo.getAiSettings();
    final prefs = await widget.repo.getAiGenerationPrefs();
    if (!mounted) return;
    setState(() {
      _provider = s.provider;
      _apiKeyController.text = s.apiKey;
      _baseUrlController.text = s.baseUrl;
      _modelController.text = s.model;
      _useLlm = s.useLlm;
      _creativity = prefs.creativity;
      _variantCount = prefs.variantCount;
      _focus = prefs.focus;
      _skipGenDialog = prefs.skipGenerationDialog;
      _loaded = true;
    });
  }

  AiSettings _currentSettings() => AiSettings(
        provider: _provider,
        apiKey: _apiKeyController.text.trim(),
        baseUrl: _baseUrlController.text.trim(),
        model: _modelController.text.trim(),
        useLlm: _useLlm,
      );

  void _applyPresetDefaults() {
    final preset = aiProviderPresets[_provider]!;
    if (_baseUrlController.text.trim().isEmpty ||
        aiProviderPresets.values
            .any((p) => p.baseUrl == _baseUrlController.text.trim())) {
      _baseUrlController.text = preset.baseUrl;
    }
    if (_modelController.text.trim().isEmpty) {
      _modelController.text = preset.defaultModel;
    }
  }

  Future<void> _save() async {
    await widget.repo.saveAiSettings(_currentSettings());
    await widget.repo.saveAiGenerationPrefs(
      AiGenerationPrefs(
        creativity: _creativity,
        variantCount: _variantCount,
        focus: _focus,
        skipGenerationDialog: _skipGenDialog,
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.snackSaved)),
    );
  }

  Future<void> _test() async {
    final l10n = context.l10n;
    setState(() => _testing = true);
    try {
      final reply = await widget.repo.testAiConnection(_currentSettings());
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.aiConnectionOkTitle),
          content: Text(l10n.aiConnectionReply(reply)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.btnClose),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final l10n = context.l10n;
    final preset = aiProviderPresets[_provider]!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileLanguagePicker(
              repo: widget.repo,
              compact: true,
              onLocaleChanged: widget.onLocaleChanged,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.smart_toy_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.adminAiSection,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch(
                  value: _useLlm,
                  onChanged: (v) => setState(() => _useLlm = v),
                ),
                Text(l10n.aiLlmToggle),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.aiSettingsSubtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const Divider(height: 32),
            Text(
              l10n.aiGenPrefsSection,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.aiGenPrefsSectionSubtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: InputDecoration(labelText: l10n.aiGenFocusLabel),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ProfileAiFocus>(
                  isExpanded: true,
                  value: _focus,
                  items: ProfileAiFocus.values
                      .map(
                        (f) => DropdownMenuItem(
                          value: f,
                          child: Text(_focusLabel(l10n, f)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _focus = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.aiGenVariantCountLabel),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 1, label: Text(l10n.aiGenVariantOne)),
                ButtonSegment(value: 2, label: Text(l10n.aiGenVariantTwo)),
                ButtonSegment(value: 3, label: Text(l10n.aiGenVariantThree)),
              ],
              selected: {_variantCount},
              onSelectionChanged: (s) =>
                  setState(() => _variantCount = s.first),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.aiCreativityLabel,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text('${(_creativity * 100).round()}%'),
              ],
            ),
            Slider(
              value: _creativity,
              min: 0,
              max: 1,
              divisions: 20,
              onChanged: (v) => setState(() => _creativity = v),
            ),
            Text(
              l10n.aiCreativityHint,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.aiGenSkipDialogLabel),
              value: _skipGenDialog,
              onChanged: (v) => setState(() => _skipGenDialog = v ?? false),
            ),
            const Divider(height: 32),
            InputDecorator(
              decoration: InputDecoration(labelText: l10n.aiProviderLabel),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AiProvider>(
                  isExpanded: true,
                  value: _provider,
                  items: AiProvider.values
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(aiProviderLabel(l10n, p.name)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _provider = v;
                      _applyPresetDefaults();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (preset.needsApiKey)
              TextField(
                controller: _apiKeyController,
                obscureText: _obscureKey,
                decoration: InputDecoration(
                  labelText: l10n.aiApiKeyLabel,
                  hintText: _provider == AiProvider.deepseek
                      ? 'sk-...'
                      : l10n.aiApiKeyStored,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureKey ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscureKey = !_obscureKey),
                  ),
                ),
              ),
            if (preset.needsApiKey) const SizedBox(height: 12),
            TextField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                labelText: l10n.aiBaseUrlLabel,
                hintText: preset.baseUrl,
                helperText: aiProviderPresetHint(l10n, _provider.name),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: l10n.aiModelLabel,
                hintText: preset.defaultModel,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: _save,
                  child: Text(l10n.btnSave),
                ),
                OutlinedButton.icon(
                  onPressed: _testing ? null : _test,
                  icon: _testing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.wifi_tethering),
                  label: Text(l10n.btnTest),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _baseUrlController.text = preset.baseUrl;
                      _modelController.text = preset.defaultModel;
                    });
                  },
                  child: Text(l10n.aiResetDefaults),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ProviderHints(provider: _provider),
          ],
        ),
      ),
    );
  }
}

String _focusLabel(dynamic l10n, ProfileAiFocus f) => switch (f) {
      ProfileAiFocus.jobSearch => l10n.aiGenFocusJobSearch,
      ProfileAiFocus.networking => l10n.aiGenFocusNetworking,
      ProfileAiFocus.thoughtLeadership => l10n.aiGenFocusThoughtLeadership,
      ProfileAiFocus.freelance => l10n.aiGenFocusFreelance,
    };

class _ProviderHints extends StatelessWidget {
  const _ProviderHints({required this.provider});

  final AiProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = switch (provider) {
      AiProvider.deepseek => l10n.aiProviderDeepseekSetupHint,
      AiProvider.openai => l10n.aiProviderOpenAiHint,
      AiProvider.openAiCompatible => l10n.aiProviderCompatibleHint,
      AiProvider.anthropic => l10n.aiProviderAnthropicHint,
      AiProvider.lmrouter => l10n.aiProviderLmRouterHint,
      AiProvider.ollama => l10n.aiProviderOllamaHint,
      AiProvider.aimarket => l10n.aiProviderAimarketHint,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
