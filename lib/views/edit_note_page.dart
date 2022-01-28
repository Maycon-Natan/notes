import 'package:flutter/material.dart';
import 'package:tasks_list/db/note_database.dart';
import 'package:tasks_list/models/note.dart';
import 'package:tasks_list/widgets/companie_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late String title;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    title = widget.note?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          title: title,
          isImportant: isImportant,
          onChangedImportant: (isImportant) =>
              setState(() => this.isImportant = isImportant),
          onChangedTitle: (title) => setState(() => this.title = title),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(isImportant: isImportant, title: title);

    await NotesDataBase.instance.update(note);
  }

  Future addNote() async {
    final note =
        Note(isImportant: true, title: title, createdTime: DateTime.now());

    await NotesDataBase.instance.createNote(note);
  }
}
