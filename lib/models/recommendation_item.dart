enum RecommendationPriority { high, medium, low }

enum RecommendationCategory { fill, promote, align }

enum RecommendationSource { rules, evaluator }

class RecommendationItem {
  const RecommendationItem({
    required this.sectionKey,
    required this.title,
    required this.body,
    required this.priority,
    required this.category,
    this.id,
    this.isDone = false,
    this.createdAt,
    this.source = RecommendationSource.rules,
  });

  final int? id;
  final String sectionKey;
  final String title;
  final String body;
  final RecommendationPriority priority;
  final RecommendationCategory category;
  final bool isDone;
  final DateTime? createdAt;
  final RecommendationSource source;

  RecommendationItem copyWith({bool? isDone}) {
    return RecommendationItem(
      id: id,
      sectionKey: sectionKey,
      title: title,
      body: body,
      priority: priority,
      category: category,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'section_key': sectionKey,
        'title': title,
        'body': body,
        'priority': priority.name,
        'category': category.name,
        'is_done': isDone ? 1 : 0,
        'created_at': (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
        'source': source.name,
      };

  factory RecommendationItem.fromMap(Map<String, dynamic> map) {
    return RecommendationItem(
      id: map['id'] as int?,
      sectionKey: map['section_key'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      priority: RecommendationPriority.values.byName(map['priority'] as String),
      category: RecommendationCategory.values.byName(map['category'] as String),
      isDone: (map['is_done'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      source: RecommendationSource.values.firstWhere(
        (s) => s.name == (map['source'] as String? ?? 'rules'),
        orElse: () => RecommendationSource.rules,
      ),
    );
  }
}
