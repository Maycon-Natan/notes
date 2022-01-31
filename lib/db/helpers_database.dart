import 'package:tasks_list/db/note_database.dart';
import 'package:tasks_list/models/tasks.dart';

Future updateTask(Task task) async {
  final taskEdit = task.copy(isDone: task.isDone);

  await NotesDataBase.instance.updateTask(taskEdit);
}
