import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:low_notes/src/models/note_model.dart';
import 'package:low_notes/src/services/firebase_note_services.dart';
import '../widgets/edit_note.dart';

class NoteEditView extends StatefulWidget {
  const NoteEditView({super.key, required this.note});

  final NoteModel note;

  static const routeName = '/note-edit';

  @override
  NoteEditViewState createState() => NoteEditViewState();
}

class NoteEditViewState extends State<NoteEditView> {
  late TextEditingController titleController;
  late QuillController contentController;
  final FirebaseNoteServices noteServices = FirebaseNoteServices();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = QuillController(
      document: widget.note.note,
      selection: const TextSelection.collapsed(offset: 0),
    );

    titleController.addListener(_updateNote);
    contentController.addListener(_updateNote);
  }

  void _updateNote() {
    final updatedNote = NoteModel(
      id: widget.note.id,
      userId: widget.note.userId,
      title: titleController.text,
      note: contentController.document,
      createdAt: widget.note.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    noteServices.updateNote(updatedNote);
  }

  @override
  void dispose() {
    titleController.removeListener(_updateNote);
    contentController.removeListener(_updateNote);
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await noteServices.deleteNote(widget.note.id, widget.note.userId);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: EditNote(
        titleController: titleController,
        contentController: contentController,
      ),
    );
  }
}
