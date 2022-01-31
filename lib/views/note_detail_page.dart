import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tasks_list/db/helpers_database.dart';
import 'package:tasks_list/db/note_database.dart';
import 'package:tasks_list/models/note.dart';
import 'package:tasks_list/models/tasks.dart';
import 'package:tasks_list/views/edit_note_page.dart';
import 'package:tasks_list/views/edit_task_page.dart';
import 'package:tasks_list/widgets/task_form_widget.dart';

class NotesDetailPage extends StatefulWidget {
  final int notesId;
  const NotesDetailPage({Key? key, required this.notesId}) : super(key: key);

  @override
  State<NotesDetailPage> createState() => _NotesDetailPageState();
}

class _NotesDetailPageState extends State<NotesDetailPage> {
  Note? note;
  List<Task>? task;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshTask();
    refreshNote();
  }

  Future refreshTask() async {
    setState(() => isLoading = true);
    task = await NotesDataBase.instance.readAllTask(widget.notesId);
    setState(() => isLoading = false);
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDataBase.instance.readNotes(widget.notesId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading || note == null || task == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note!.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      DateFormat.yMMM().format(note!.createdTime),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    buildTask(),
                  ],
                ),
              ),
            ),
      floatingActionButton: addButtonTask(),
    );
  }

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await NotesDataBase.instance.deleteNote(widget.notesId);

          Navigator.of(context).pop();
        },
      );

  Widget addButtonTask() => FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => AddEditTaskPage(
                        taskId: widget.notesId,
                      )))
              .then((value) {
            refreshTask();
          });
        },
      );

  Widget buildTask() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: task!.length,
      itemBuilder: (context, index) {
        final tasks = task![index];

        return Slidable(
            key: UniqueKey(),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tasks.title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(tasks.description),
                      ],
                    ),
                    Checkbox(
                      value: tasks.isDone,
                      onChanged: (value) {
                        setState(() {
                          tasks.isDone = value!;
                          updateTask(tasks);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            endActionPane: ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                onPressed: (context) async {
                  if (isLoading) return;
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddEditTaskPage(
                      task: tasks,
                      taskId: tasks.id!,
                    ),
                  ));

                  refreshNote();
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: (context) async {
                  await NotesDataBase.instance.deleteTask(widget.notesId);

                  refreshTask();
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Delete',
              )
            ]));
      });

  Widget editButtonTask(Task task, int taskId) => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditTaskPage(
            task: task,
            taskId: taskId,
          ),
        ));

        refreshNote();
      });

  Widget deleteButtonTask() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await NotesDataBase.instance.deleteTask(widget.notesId);

          Navigator.of(context).pop();
        },
      );
}
