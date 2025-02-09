import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:low_notes/src/services/firebase_auth_services.dart';
import '../models/note_model.dart';
import '../services/firebase_note_services.dart';
import '../widgets/edit_note.dart';
import 'package:uuid/uuid.dart';

class NoteCreateView extends StatefulWidget {
  const NoteCreateView({super.key});

  static const routeName = '/note-create';

  @override
  NoteCreateViewState createState() => NoteCreateViewState();
}

class NoteCreateViewState extends State<NoteCreateView> {
  final FirebaseAuthServices authServices = FirebaseAuthServices();
  final FirebaseNoteServices noteServices = FirebaseNoteServices();
  final TextEditingController titleController = TextEditingController();
  final QuillController contentController = QuillController.basic();
  String? imageUrl;
  String noteId = Uuid().v4();

  Future<void> _pickImage() async {
    final url = await noteServices.pickImage(noteId);
    if (url != null) {
      setState(() {
        imageUrl = url;
      });
    }
  }

  Future<void> _removeImage() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      await noteServices.removeImage(noteId);
      setState(() {
        imageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              String userId = await authServices.getUserId();
              final note = NoteModel(
                id: noteId,
                userId: userId,
                title: titleController.text,
                note: contentController.document,
                imageUrl: imageUrl,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              );
              await noteServices.saveNote(note);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (imageUrl != null)
              GestureDetector(
                onLongPress: _removeImage,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth,
                  ),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            EditNote(
              titleController: titleController,
              contentController: contentController,
            ),
          ],
        ),
      ),
    );
  }
}
