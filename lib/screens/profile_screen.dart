import 'package:flutter/material.dart';

import '../models/profile_section.dart';
import '../repositories/app_repository.dart';
import 'section_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileSection> _sections = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sections = await widget.repo.getSections();
    if (!mounted) return;
    setState(() {
      _sections = sections;
      _loading = false;
    });
  }

  Future<void> _openSection(ProfileSection section) async {
    final updated = await Navigator.of(context).push<ProfileSection>(
      MaterialPageRoute(
        builder: (_) => SectionEditScreen(
          section: section,
          onSave: (s) => widget.repo.saveSection(s),
        ),
      ),
    );
    if (updated != null) {
      setState(() {
        _sections = _sections
            .map((s) => s.key == updated.key ? updated : s)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Разделы LinkedIn',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Вставьте текущее содержимое каждого раздела из вашего профиля LinkedIn.',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 16),
        ..._sections.map((section) {
          final filled = section.content.trim().isNotEmpty;
          final preview = filled
              ? section.content.trim()
              : 'Не заполнено — нажмите для редактирования';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: filled
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.15),
                child: Icon(
                  filled ? Icons.check : Icons.edit_outlined,
                  color: filled ? Colors.green.shade700 : Colors.grey,
                ),
              ),
              title: Text(
                section.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    section.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: filled ? null : Colors.grey.shade500,
                      fontStyle: filled ? FontStyle.normal : FontStyle.italic,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openSection(section),
            ),
          );
        }),
      ],
    );
  }
}
