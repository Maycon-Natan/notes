const String tableTask = 'Tasks';

class TasksFields {
  static final List<String> values = [
    id,
    idNote,
    title,
    description,
    isDone,
    ordem
  ];

  static const String id = 'id';
  static const String idNote = 'idNote';
  static const String title = 'title';
  static const String description = 'description';
  static const String isDone = 'isDone';
  static const String ordem = 'ordem';
}

class Task {
  int? id;
  int idNote;
  int? ordem;
  String title;
  String description;
  bool isDone;

  Task({
    this.id,
    this.ordem,
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
      'ordem': ordem
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt() ?? 0,
      idNote: map['idNote'].toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
      ordem: map['ordem']?.toInt() ?? 0,
    );
  }

  Map<String, Object?> toJson() => {
        TasksFields.id: id,
        TasksFields.idNote: idNote,
        TasksFields.title: title,
        TasksFields.description: description,
        TasksFields.isDone: isDone ? 1 : 0,
        TasksFields.ordem: ordem
      };

  Task copy(
          {int? id,
          int? idNote,
          String? title,
          String? description,
          bool? isDone,
          int? ordem}) =>
      Task(
        id: id ?? this.id,
        idNote: idNote ?? this.idNote,
        title: title ?? this.title,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        ordem: ordem ?? this.ordem,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TasksFields.id] as int?,
        idNote: json[TasksFields.idNote] as int,
        title: json[TasksFields.title] as String,
        description: json[TasksFields.description] as String,
        isDone: json[TasksFields.isDone] == 1,
        ordem: json[TasksFields.ordem] as int?,
      );
}
