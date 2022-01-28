import 'package:tasks_list/models/tasks.dart';

const String tableNotes = 'Note';

class NotesFields {
  static final List<String> values = [id, isImportant, title, time];

  static const String id = '_id';
  static const String isImportant = 'isImportant';

  static const String title = 'name';
  static const String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final String title;
  final DateTime createdTime;
  final List<Task>? task;

  Note({
    this.task,
    this.id,
    required this.isImportant,
    required this.title,
    required this.createdTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    String? title,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      isImportant: isImportant ?? this.isImportant,
      title: title ?? this.title,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, Object?> toJson() => {
        NotesFields.id: id,
        NotesFields.title: title,
        NotesFields.isImportant: isImportant,
        NotesFields.time: createdTime.toIso8601String(),
      };

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NotesFields.id] as int?,
        title: json[NotesFields.title] as String,
        isImportant: json[NotesFields.isImportant] == 1,
        createdTime: DateTime.parse(json[NotesFields.time] as String),
      );
}
