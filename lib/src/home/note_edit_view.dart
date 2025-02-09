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
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    contentController = QuillController(
      document: widget.note.note,
      selection: const TextSelection.collapsed(offset: 0),
    );
    imageUrl = widget.note.imageUrl;

    titleController.addListener(_updateNote);
    contentController.addListener(_updateNote);
  }

  Future<void> _pickImage() async {
    final url = await noteServices.pickImage(widget.note.id);
    if (url != null) {
      setState(() {
        imageUrl = url;
      });
      _updateNote();
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
      await noteServices.removeImage(widget.note.id);
      setState(() {
        imageUrl = null;
      });
      _updateNote();
    }
  }

  void _updateNote() {
    final updatedNote = NoteModel(
      id: widget.note.id,
      userId: widget.note.userId,
      title: titleController.text,
      note: contentController.document,
      imageUrl: imageUrl,
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
    final screenWidth = MediaQuery.of(context).size.width;

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
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await noteServices.deleteNote(widget.note.id, widget.note.userId);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (imageUrl != null)
            GestureDetector(
              onLongPress: _removeImage,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth,
                  maxHeight: 200,
                ),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
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
