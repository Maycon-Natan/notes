import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_list/db/note_database.dart';
import 'package:tasks_list/models/tasks.dart';
import 'package:tasks_list/widgets/task_form_widget.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task;
  final int idNote;
  const AddEditTaskPage({Key? key, this.task, required this.idNote})
      : super(key: key);

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  int? id;
  String? title;
  String? description;
  // bool? done;

  @override
  void initState() {
    super.initState();

    id = widget.task?.id ?? 0;
    title = widget.task?.title ?? '';
    description = widget.task?.description ?? '';
    // done = widget.task?.isDone ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: TaskFormWidget(
          title: title,
          description: description,
          // done: done,
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) =>
              setState(() => this.description = description),
          // onChangedDone: (done) => setState(() => this.done = done),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: isFormValid ? null : Colors.grey.shade800),
        onPressed: addOrUpdateTask,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateTask() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.task != null;
      if (isUpdating) {
        await updateTask();
      } else {
        await addTask();
      }
      Navigator.of(context).pop();
    }
  }

  Future updateTask() async {
    final task = widget.task!.copy(title: title, description: description);

    await NotesDataBase.instance.updateTask(task);
  }

  Future addTask() async {
    final task = Task(
      id: null,
      idNote: widget.idNote,
      title: title!,
      description: description!,
      isDone: false,
    );

    await NotesDataBase.instance.createTask(task);
  }
}
