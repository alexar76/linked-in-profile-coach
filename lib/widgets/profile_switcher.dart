import 'package:flutter/material.dart';

import '../models/managed_profile.dart';
import '../repositories/app_repository.dart';
import '../theme/theme_context.dart';
import '../utils/l10n_ext.dart';

/// Dropdown in the top bar to switch between managed profiles (recruiters).
class ProfileSwitcher extends StatefulWidget {
  const ProfileSwitcher({
    super.key,
    required this.repo,
    required this.onProfileChanged,
  });

  final AppRepository repo;
  final VoidCallback onProfileChanged;

  @override
  State<ProfileSwitcher> createState() => _ProfileSwitcherState();
}

class _ProfileSwitcherState extends State<ProfileSwitcher> {
  List<ManagedProfile> _profiles = [];
  int? _activeId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profiles = await widget.repo.listProfiles();
    final activeId = await widget.repo.getActiveProfileId();
    if (!mounted) return;
    setState(() {
      _profiles = profiles;
      _activeId = activeId;
      _loading = false;
    });
  }

  Future<void> _switchTo(int id) async {
    if (id == _activeId) return;
    await widget.repo.switchProfile(id);
    await _load();
    widget.onProfileChanged();
  }

  Future<void> _addProfile() async {
    final l10n = context.l10n;
    final name = await _promptName(
      title: l10n.profilesAddTitle,
      hint: l10n.profilesNameHint,
      confirm: l10n.profilesAddConfirm,
    );
    if (name == null) return;
    final id = await widget.repo.createProfile(name);
    await widget.repo.switchProfile(id);
    await _load();
    widget.onProfileChanged();
  }

  Future<void> _renameProfile(ManagedProfile profile) async {
    final l10n = context.l10n;
    final name = await _promptName(
      title: l10n.profilesRenameTitle,
      hint: l10n.profilesNameHint,
      confirm: l10n.btnSave,
      initial: profile.name,
    );
    if (name == null) return;
    await widget.repo.renameProfile(profile.id, name);
    await _load();
    if (profile.id == _activeId) widget.onProfileChanged();
  }

  Future<void> _deleteProfile(ManagedProfile profile) async {
    final l10n = context.l10n;
    if (_profiles.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profilesCannotDeleteLast)),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profilesDeleteTitle),
        content: Text(l10n.profilesDeleteBody(profile.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.profilesDeleteConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.repo.deleteProfile(profile.id);
      await _load();
      widget.onProfileChanged();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profilesCannotDeleteLast)),
      );
    }
  }

  Future<String?> _promptName({
    required String title,
    required String hint,
    required String confirm,
    String initial = '',
  }) async {
    final controller = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: hint),
          onSubmitted: (_) => Navigator.pop(ctx, controller.text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(confirm),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.isEmpty) return null;
    return result;
  }

  ManagedProfile? get _active {
    if (_activeId == null) return null;
    for (final p in _profiles) {
      if (p.id == _activeId) return p;
    }
    return _profiles.isNotEmpty ? _profiles.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    if (_loading) {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final active = _active;
    final label = active?.label ?? l10n.profilesSwitcherLabel;

    return PopupMenuButton<int>(
      tooltip: l10n.profilesSwitcherLabel,
      onSelected: (id) {
        if (id == -1) {
          _addProfile();
        } else if (id == -2) {
          if (active != null) _renameProfile(active);
        } else if (id == -3) {
          if (active != null) _deleteProfile(active);
        } else {
          _switchTo(id);
        }
      },
      itemBuilder: (ctx) {
        final items = <PopupMenuEntry<int>>[
          PopupMenuItem(
            enabled: false,
            child: Text(
              l10n.profilesSwitcherLabel,
              style: Theme.of(ctx).textTheme.labelSmall?.copyWith(
                    color: palette.textSecondary,
                  ),
            ),
          ),
          const PopupMenuDivider(),
        ];
        for (final p in _profiles) {
          items.add(
            PopupMenuItem(
              value: p.id,
              child: Row(
                children: [
                  Icon(
                    p.id == _activeId
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    size: 18,
                    color: p.id == _activeId
                        ? palette.primary
                        : palette.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (p.targetRole.trim().isNotEmpty)
                          Text(
                            p.targetRole,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                                  color: palette.textSecondary,
                                  fontSize: 11,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        items.addAll([
          const PopupMenuDivider(),
          PopupMenuItem(
            value: -1,
            child: Row(
              children: [
                const Icon(Icons.add, size: 18),
                const SizedBox(width: 10),
                Text(l10n.profilesAddAction),
              ],
            ),
          ),
          if (active != null)
            PopupMenuItem(
              value: -2,
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 18),
                  const SizedBox(width: 10),
                  Text(l10n.profilesRenameAction),
                ],
              ),
            ),
          if (active != null && _profiles.length > 1)
            PopupMenuItem(
              value: -3,
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
                  const SizedBox(width: 10),
                  Text(
                    l10n.profilesDeleteAction,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                ],
              ),
            ),
        ]);
        return items;
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          color: palette.surface.withValues(alpha: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 18, color: palette.primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more, size: 18, color: palette.textSecondary),
          ],
        ),
      ),
    );
  }
}
