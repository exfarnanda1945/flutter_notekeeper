import 'package:flutter/material.dart';
import 'package:notekeeper/database/note_db.dart';
import 'package:notekeeper/models/note_model.dart';
import 'package:notekeeper/widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();

  late String description;
  late bool isImportant;
  late int number;
  late String title;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [buildButtonSave()]),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
            isImportant: isImportant,
            onChangeIsImportant: (value) {
              setState(() {
                isImportant = value;
              });
            },
            number: number,
            onChangeNumber: (value) {
              setState(() {
                number = value;
              });
            },
            title: title,
            onChangeTitle: (value) {
              title = value;
            },
            description: description,
            onChangeDescription: (value) {
              description = value;
            }),
      ),
    );
  }

  Widget buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
          onPressed: addOrEditNote,
          style: ElevatedButton.styleFrom(onPrimary: Colors.white),
          child: const Text("Save")),
    );
  }

  void addOrEditNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdate = widget.note != null;

      if (isUpdate) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.pop(context);
    }
  }

  Future addNote() async {
    final note = Note(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());

    await NoteDb.instance.create(note);
  }

  Future updateNote() async {
    final note = widget.note?.copy(
        title: title,
        isImportant: isImportant,
        number: number,
        description: description,
        createdTime: DateTime.now());

    await NoteDb.instance.update(note!);
  }
}
