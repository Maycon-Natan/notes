const String tableTask = 'Tasks';

class TasksFields {
  static final List<String> values = [id, title, description, isDone];

  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String isDone = 'done';
}

class Task {
  int? id;
  String title;
  String description;
  bool isDone;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  @override
  String toString() {
    return 'Task(tableTask: $tableTask, id: $id, title: $title, description: $description, isDone: $isDone)';
  }

  Map<String, dynamic> toMap() {
    return {
      'tableTask': tableTask,
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  Map<String, Object?> toJson() => {
        TasksFields.id: id,
        TasksFields.title: title,
        TasksFields.description: description,
        TasksFields.isDone: isDone ? 1 : 0,
      };

  Task copy({
    int? id,
    String? title,
    String? description,
    bool? isDone,
  }) =>
      Task(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          isDone: isDone ?? this.isDone);

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TasksFields.id] as int?,
        title: json[TasksFields.title] as String,
        description: json[TasksFields.description] as String,
        isDone: json[TasksFields.isDone] == 1,
      );
}
