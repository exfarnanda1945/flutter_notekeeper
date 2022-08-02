import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/database/note_db.dart';
import 'package:notekeeper/models/note_model.dart';
import 'package:notekeeper/pages/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);
  final int? noteId;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });

    note = await NoteDb.instance.get(widget.noteId!);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [editBtn(), deleteBtn()]),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  DateFormat.yMMMd().format(note.createdTime),
                  style: TextStyle(color: Colors.white38),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  note.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                )
              ],
            ),
    );
  }

  deleteBtn() => IconButton(
      onPressed: () async {
        await NoteDb.instance.delete(widget.noteId!);
        Navigator.pop(context);
      },
      icon: const Icon(Icons.delete));

  editBtn() => IconButton(
      onPressed: () async {
        if (isLoading) return;

        final route = MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: note));
        await Navigator.push(context, route);
        refreshNote();
      },
      icon: const Icon(Icons.edit_outlined));
}
