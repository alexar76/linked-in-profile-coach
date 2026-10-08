import 'package:flutter/material.dart';

import '../models/profile_language.dart';
import '../repositories/app_repository.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';

/// App language: UI, insights, AI text, and scoring use the same locale.
class ProfileLanguagePicker extends StatefulWidget {
  const ProfileLanguagePicker({
    super.key,
    required this.repo,
    this.compact = false,
    this.onChanged,
    this.onLocaleChanged,
  });

  final AppRepository repo;
  final bool compact;
  final ValueChanged<ProfileLanguage>? onChanged;
  final ValueChanged<Locale>? onLocaleChanged;

  @override
  State<ProfileLanguagePicker> createState() => _ProfileLanguagePickerState();
}

class _ProfileLanguagePickerState extends State<ProfileLanguagePicker> {
  ProfileLanguage _selected = ProfileLanguage.en;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final code = await widget.repo.getLocaleLanguageCode();
    if (!mounted) return;
    setState(() {
      _selected = ProfileLanguage.fromCode(code);
      _loaded = true;
    });
  }

  Future<void> _select(ProfileLanguage lang) async {
    setState(() => _selected = lang);
    await widget.repo.saveAppLanguage(lang.code);
    final locale = Locale(lang.code);
    widget.onLocaleChanged?.call(locale);
    widget.onChanged?.call(lang);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final l10n = context.l10n;
    final p = context.palette;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(widget.compact ? 16 : 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.primary.withValues(alpha: 0.35)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            p.primary.withValues(alpha: 0.14),
            p.surface,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.translate, color: p.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.profileLanguageTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileLanguageSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: p.textSecondary,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ProfileLanguage.values.map((lang) {
              final selected = _selected == lang;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _select(lang),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? p.primary
                            : p.textSecondary.withValues(alpha: 0.25),
                        width: selected ? 2 : 1,
                      ),
                      color: selected
                          ? p.primary.withValues(alpha: 0.12)
                          : p.backgroundElevated,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selected)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.check_circle,
                              size: 18,
                              color: p.primary,
                            ),
                          ),
                        Text(
                          lang.label(l10n),
                          style: TextStyle(
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected ? p.primary : p.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
