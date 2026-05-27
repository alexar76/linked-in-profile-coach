import 'package:flutter/material.dart';
import 'package:linkedin_profile_coach/l10n/app_localizations.dart';

import '../../theme/theme_context.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.compact = false,
  });

  final AppThemeId selected;
  final ValueChanged<AppThemeId> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!compact) ...[
          Text(
            l10n.themeSectionTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(l10n.themeSectionSubtitle),
          const SizedBox(height: 20),
        ],
        _ThemeGroup(
          title: l10n.themeGroupDark,
          ids: AppThemes.darkThemes,
          selected: selected,
          onSelected: onSelected,
          compact: compact,
        ),
        const SizedBox(height: 16),
        _ThemeGroup(
          title: l10n.themeGroupLight,
          ids: AppThemes.lightThemes,
          selected: selected,
          onSelected: onSelected,
          compact: compact,
        ),
        const SizedBox(height: 16),
        _ThemeGroup(
          title: l10n.themeGroupPink,
          ids: AppThemes.pinkThemes,
          selected: selected,
          onSelected: onSelected,
          compact: compact,
        ),
      ],
    );
  }
}

class _ThemeGroup extends StatelessWidget {
  const _ThemeGroup({
    required this.title,
    required this.ids,
    required this.selected,
    required this.onSelected,
    required this.compact,
  });

  final String title;
  final List<AppThemeId> ids;
  final AppThemeId selected;
  final ValueChanged<AppThemeId> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.palette.primary,
              ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: compact ? 10 : 12,
          runSpacing: compact ? 10 : 12,
          children: ids
              .map(
                (id) => _ThemeSwatch(
                  id: id,
                  selected: selected == id,
                  compact: compact,
                  onTap: () => onSelected(id),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.id,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final AppThemeId id;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppThemes.palette(id);
    final l10n = AppLocalizations.of(context);
    final name = _themeName(l10n, id);

    if (compact) {
      return Tooltip(
        message: name,
        child: Semantics(
          button: true,
          label: name,
          selected: selected,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? p.primary : Colors.transparent,
                  width: 2.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [p.backdropGradient.first, p.primary],
                ),
              ),
              child: selected
                  ? Icon(Icons.check, color: p.onPrimary, size: 20)
                  : null,
            ),
          ),
        ),
      );
    }

    return Semantics(
      button: true,
      label: name,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: 148,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? p.primary
                  : context.palette.textSecondary.withValues(alpha: 0.2),
              width: selected ? 2 : 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [p.backdropGradient.first, p.surface],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.primary,
                    ),
                  ),
                  const Spacer(),
                  if (selected)
                    Icon(Icons.check_circle, color: p.primary, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: p.textPrimary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _Dot(color: p.primary),
                  const SizedBox(width: 4),
                  _Dot(color: p.primaryLight),
                  const SizedBox(width: 4),
                  _Dot(color: p.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _themeName(AppLocalizations l10n, AppThemeId id) => switch (id) {
        AppThemeId.darkGold => l10n.themeDarkGold,
        AppThemeId.darkOcean => l10n.themeDarkOcean,
        AppThemeId.darkPlum => l10n.themeDarkPlum,
        AppThemeId.lightIvory => l10n.themeLightIvory,
        AppThemeId.lightCloud => l10n.themeLightCloud,
        AppThemeId.lightSage => l10n.themeLightSage,
        AppThemeId.lightPearl => l10n.themeLightPearl,
        AppThemeId.lightSand => l10n.themeLightSand,
        AppThemeId.lightMint => l10n.themeLightMint,
        AppThemeId.lightAmber => l10n.themeLightAmber,
        AppThemeId.pinkRose => l10n.themePinkRose,
        AppThemeId.pinkBlush => l10n.themePinkBlush,
        AppThemeId.pinkLilac => l10n.themePinkLilac,
      };
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
