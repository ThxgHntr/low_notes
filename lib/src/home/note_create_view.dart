import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:low_notes/src/services/firebase_auth_services.dart';
import '../models/note_model.dart';
import '../services/firebase_note_services.dart';
import '../widgets/edit_note.dart';

class NoteCreateView extends StatelessWidget {
  const NoteCreateView({super.key});

  static const routeName = '/note-create';

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthServices authServices = FirebaseAuthServices();
    final FirebaseNoteServices noteServices = FirebaseNoteServices();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              // Handle image insertion
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              String userId = await authServices.getUserId();
              final note = NoteModel(
                id: 'fgqwgqg',
                userId: userId,
                title: 'Note Title',
                note: Document(),
                createdAt: DateTime.now().millisecondsSinceEpoch,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              );
              await noteServices.saveNote(note);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: const EditNote(),
    );
  }
}
