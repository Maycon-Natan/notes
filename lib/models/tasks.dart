const String tableTask = 'Tasks';

class TasksFields {
  static final List<String> values = [id, idNote, title, description, isDone];

  static const String id = 'id';
  static const String idNote = 'idNote';
  static const String title = 'title';
  static const String description = 'description';
  static const String isDone = 'isDone';
}

class Task {
  int? id;
  int idNote;
  String title;
  String description;
  bool isDone;

  Task({
    this.id,
    required this.idNote,
    required this.title,
    required this.description,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idNote': idNote,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt() ?? 0,
      idNote: map['idNote'].toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  Map<String, Object?> toJson() => {
        TasksFields.id: id,
        TasksFields.idNote: idNote,
        TasksFields.title: title,
        TasksFields.description: description,
        TasksFields.isDone: isDone ? 1 : 0,
      };

  Task copy({
    int? id,
    int? idNote,
    String? title,
    String? description,
    bool? isDone,
  }) =>
      Task(
        id: id ?? this.id,
        idNote: idNote ?? this.idNote,
        title: title ?? this.title,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TasksFields.id] as int?,
        idNote: json[TasksFields.idNote] as int,
        title: json[TasksFields.title] as String,
        description: json[TasksFields.description] as String,
        isDone: json[TasksFields.isDone] == 1,
      );
}
