import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/profile_snapshot.dart';
import '../repositories/app_repository.dart';
import '../utils/l10n_ext.dart';

class SnapshotsScreen extends StatefulWidget {
  const SnapshotsScreen({super.key, required this.repo});

  final AppRepository repo;

  @override
  State<SnapshotsScreen> createState() => _SnapshotsScreenState();
}

class _SnapshotsScreenState extends State<SnapshotsScreen> {
  List<ProfileSnapshot> _snapshots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await widget.repo.getSnapshots();
    if (!mounted) return;
    setState(() {
      _snapshots = list;
      _loading = false;
    });
  }

  Future<void> _restore(ProfileSnapshot snapshot) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.snapshotRestoreTitle),
        content: Text(l10n.snapshotRestoreBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.btnCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.snapshotRestoreConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await widget.repo.restoreSnapshot(snapshot);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.snapshotRestored)),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fmt = DateFormat.yMMMd().add_Hm();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.snapshotsTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _snapshots.isEmpty
              ? Center(child: Text(l10n.snapshotsEmpty))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _snapshots.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final s = _snapshots[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(fmt.format(s.capturedAt)),
                        subtitle: Text(s.source),
                        trailing: FilledButton(
                          onPressed: () => _restore(s),
                          child: Text(l10n.snapshotRestore),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
