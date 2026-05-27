import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/profile_section.dart';
import '../services/experience_structure_parser.dart';
import '../utils/l10n_ext.dart';

class SectionEditScreen extends StatefulWidget {
  const SectionEditScreen({
    super.key,
    required this.section,
    required this.onSave,
    this.fieldLabel,
    this.initialText,
  });

  final ProfileSection section;
  final Future<void> Function(ProfileSection section) onSave;
  final String? fieldLabel;
  final String? initialText;

  @override
  State<SectionEditScreen> createState() => _SectionEditScreenState();
}

class _SectionEditScreenState extends State<SectionEditScreen> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialText ?? widget.section.content,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final updated = widget.section.copyWith(
      content: _controller.text,
      updatedAt: DateTime.now(),
    );
    await widget.onSave(updated);
    if (!mounted) return;
    Navigator.of(context).pop(updated);
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _controller.text = data.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chars = _controller.text.trim().length;
    final label = widget.fieldLabel ?? l10n.sectionEditDefaultLabel;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.section.title),
        actions: [
          TextButton.icon(
            onPressed: _pasteFromClipboard,
            icon: const Icon(Icons.content_paste),
            label: Text(l10n.sectionEditPaste),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.btnSave),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.section.description),
            const SizedBox(height: 8),
            Text(
              '${l10n.sectionEditHintPrefix} ${widget.section.hint}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            if (widget.section.key == 'experience') ...[
              Text(
                l10n.experienceRolesTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...ExperienceStructureParser()
                  .parse(_controller.text)
                  .take(6)
                  .map(
                    (role) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(role.title),
                        subtitle: Text(
                          [
                            if (role.company.isNotEmpty) role.company,
                            if (role.period.isNotEmpty) role.period,
                          ].join(' · '),
                        ),
                        isThreeLine: role.body.isNotEmpty,
                      ),
                    ),
                  ),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: widget.section.hint,
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sectionCharCount(chars),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
