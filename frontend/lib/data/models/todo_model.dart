class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
  });

  // Deserialize from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?, // nullable
      isCompleted: json['isCompleted'] as bool,
    );
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
