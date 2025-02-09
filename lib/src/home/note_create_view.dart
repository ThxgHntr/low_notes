import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final storageRef = FirebaseStorage.instance.ref().child('notes/$noteId');
      await storageRef.putFile(File(pickedFile.path));
      final url = await storageRef.getDownloadURL();
      setState(() {
        imageUrl = url;
      });
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      imageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          if (imageUrl != null)
            Stack(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 300,
                    maxHeight: 200,
                  ),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: _removeImage,
                  ),
                ),
              ],
            ),
          Expanded(
            child: EditNote(
              titleController: titleController,
              contentController: contentController,
            ),
          ),
        ],
      ),
    );
  }
}
