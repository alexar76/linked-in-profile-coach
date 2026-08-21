class ManagedProfile {
  const ManagedProfile({
    required this.id,
    required this.name,
    required this.createdAt,
    this.displayName = '',
    this.targetRole = '',
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final String displayName;
  final String targetRole;

  String get label {
    if (displayName.trim().isNotEmpty) return displayName.trim();
    if (name.trim().isNotEmpty) return name.trim();
    return 'Profile #$id';
  }

  factory ManagedProfile.fromMap(Map<String, dynamic> map) {
    return ManagedProfile(
      id: map['id'] as int,
      name: map['name'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      displayName: map['display_name'] as String? ?? '',
      targetRole: map['target_role'] as String? ?? '',
    );
  }
}
