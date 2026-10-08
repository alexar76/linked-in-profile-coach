import 'package:flutter/material.dart';

import '../models/ai_generation_prefs.dart';
import '../utils/l10n_ext.dart';

/// Pre-generation modal: focus, variant count, creativity, don't ask again.
class AiGenerationOptionsDialog extends StatefulWidget {
  const AiGenerationOptionsDialog({
    super.key,
    required this.initial,
  });

  final AiGenerationPrefs initial;

  @override
  State<AiGenerationOptionsDialog> createState() =>
      _AiGenerationOptionsDialogState();
}

class _AiGenerationOptionsDialogState extends State<AiGenerationOptionsDialog> {
  late double _creativity = widget.initial.creativity;
  late int _variantCount = widget.initial.variantCount;
  late ProfileAiFocus _focus = widget.initial.focus;
  late bool _skipDialog = widget.initial.skipGenerationDialog;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.aiGenOptionsTitle),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.aiGenOptionsSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.aiGenFocusLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...ProfileAiFocus.values.map(
                (f) => RadioListTile<ProfileAiFocus>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(_focusTitle(l10n, f)),
                  subtitle: Text(
                    _focusSubtitle(l10n, f),
                    style: const TextStyle(fontSize: 12),
                  ),
                  value: f,
                  groupValue: _focus,
                  onChanged: (v) => setState(() => _focus = v!),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.aiGenVariantCountLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.aiCreativityLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${(_creativity * 100).round()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _creativity,
                min: 0,
                max: 1,
                divisions: 20,
                label: '${(_creativity * 100).round()}%',
                onChanged: (v) => setState(() => _creativity = v),
              ),
              Text(
                l10n.aiCreativityHint,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(l10n.aiGenSkipDialogLabel),
                value: _skipDialog,
                onChanged: (v) => setState(() => _skipDialog = v ?? false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.btnCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(
              context,
              AiGenerationPrefs(
                creativity: _creativity,
                variantCount: _variantCount,
                focus: _focus,
                skipGenerationDialog: _skipDialog,
              ),
            );
          },
          child: Text(l10n.btnGenerateAi),
        ),
      ],
    );
  }

  String _focusTitle(dynamic l10n, ProfileAiFocus f) => switch (f) {
        ProfileAiFocus.jobSearch => l10n.aiGenFocusJobSearch,
        ProfileAiFocus.networking => l10n.aiGenFocusNetworking,
        ProfileAiFocus.thoughtLeadership => l10n.aiGenFocusThoughtLeadership,
        ProfileAiFocus.freelance => l10n.aiGenFocusFreelance,
      };

  String _focusSubtitle(dynamic l10n, ProfileAiFocus f) => switch (f) {
        ProfileAiFocus.jobSearch => l10n.aiGenFocusJobSearchDesc,
        ProfileAiFocus.networking => l10n.aiGenFocusNetworkingDesc,
        ProfileAiFocus.thoughtLeadership =>
          l10n.aiGenFocusThoughtLeadershipDesc,
        ProfileAiFocus.freelance => l10n.aiGenFocusFreelanceDesc,
      };
}
