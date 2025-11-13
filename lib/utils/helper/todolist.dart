class TodoItem {
  final String id;
  String text;
  bool done;
  DateTime createdAt;

  TodoItem({
    required this.id,
    required this.text,
    this.done = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'done': done,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TodoItem.fromMap(Map<String, dynamic> m) => TodoItem(
    id: m['id'].toString(),
    text: (m['text'] ?? '').toString(),
    done: (m['done'] ?? false) as bool,
    createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
  );
}
