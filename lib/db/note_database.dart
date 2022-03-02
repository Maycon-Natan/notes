import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks_list/models/note.dart';
import 'package:tasks_list/models/tasks.dart';

class NotesDataBase {
  static final NotesDataBase instance = NotesDataBase._init();

  static Database? _database;

  NotesDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Note.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intAutoType = 'INTEGER';

    await db.execute('''
    CREATE TABLE $tableNotes(
      ${NotesFields.id} $idType,
      ${NotesFields.isImportant} $boolType,
      ${NotesFields.title} $textType,
      ${NotesFields.time} $textType
    )''');
    await db.execute('''
    CREATE TABLE $tableTask (
      ${TasksFields.id} $idType,
      ${TasksFields.idNote} $intType,
      ${TasksFields.title} $textType,
      ${TasksFields.description} $textType,
      ${TasksFields.isDone} $boolType,
      ${TasksFields.ordem} $intAutoType
    )''');
  }

  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(
      tableNotes,
      note.toJson(),
    );
    return note.copy(id: id);
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(
      tableTask,
      task.toJson(),
    );
    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTask,
      orderBy: '${TasksFields.ordem} ASC',
      columns: TasksFields.values,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Task>> readAllTask(int id) async {
    final db = await instance.database;

    final result = await db.query(
      tableTask,
      orderBy: '${TasksFields.ordem} ASC',
      columns: TasksFields.values,
      where: '${TasksFields.idNote} = ?',
      whereArgs: [id],
    );

    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;

    return db.update(
      tableTask,
      task.toJson(),
      where: '${TasksFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> updateTaskDone(Task task) async {
    Database db = await instance.database;
    return db.update(
      tableTask,
      task.toMap(),
      where: '${TasksFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteNotes(int id) async {
    final db = await instance.database;

    await db.rawDelete("DELETE FROM '$tableNotes' WHERE id = '$id' ");
    await db.rawDelete("DELETE FROM '$tableTask' WHERE id = '$id' ");
  }

  Future<void> deleteTask(int id) async {
    final db = await instance.database;

    await db.rawDelete("DELETE FROM '$tableTask' WHERE id = '$id' ");
  }

  Future<Note> readNotes(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NotesFields.values,
      where: '${NotesFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    final result = await db.query(tableNotes);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note notes) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      notes.toJson(),
      where: '${NotesFields.id} = ?',
      whereArgs: [notes.id],
    );
  }

  // Future<int> deleteNote(int id) async {
  //   final db = await instance.database;

  //   return await db.delete(
  //     tableNotes,
  //     where: '${NotesFields.id}= ?',
  //     whereArgs: [id],
  //   );
  // }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
