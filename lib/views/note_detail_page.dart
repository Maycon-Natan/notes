import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tasks_list/db/note_database.dart';
import 'package:tasks_list/models/note.dart';
import 'package:tasks_list/models/tasks.dart';
import 'package:tasks_list/views/edit_note_page.dart';
import 'package:tasks_list/views/edit_task_page.dart';

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
              padding: const EdgeInsets.all(8),
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
          await NotesDataBase.instance.deleteNotes(widget.notesId);

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
                        idNote: widget.notesId,
                      )))
              .then((value) {
            refreshTask();
          });
        },
      );

  Widget buildTask() => ReorderableListView(
        key: UniqueKey(),
        shrinkWrap: true,
        onReorder: (int oldIndex, int newIndex) => setState(() {
          final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

          final tasks = task?.removeAt(oldIndex);
          task!.insert(index, tasks!);
        }),
        children: [
          for (final tasks in task!)
            isLoading == false
                ? Slidable(
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
                            checkboxCustom(tasks),
                          ],
                        ),
                      ),
                    ),
                    endActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (context) async {
                          if (isLoading) return;
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddEditTaskPage(
                              task: tasks,
                              idNote: widget.notesId,
                            ),
                          ));

                          refreshTask();
                        },
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await NotesDataBase.instance.deleteTask(tasks.id!);

                          refreshTask();
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      )
                    ]))
                : const CircularProgressIndicator()
        ],
      );

  Widget editButtonTask(Task task, int idNote) => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditTaskPage(
            task: task,
            idNote: idNote,
          ),
        ));

        refreshTask();
      });

  Checkbox checkboxCustom(Task tasks) {
    return Checkbox(
      value: tasks.isDone,
      onChanged: (value) async {
        final task = tasks.copy(
            title: tasks.title, description: tasks.description, isDone: value);
        await NotesDataBase.instance.updateTaskDone(task);
        setState(() {
          tasks.isDone = value!;
        });
      },
    );
  }
}
