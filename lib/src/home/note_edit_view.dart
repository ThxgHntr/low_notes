import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:low_notes/src/models/note_model.dart';
import 'package:low_notes/src/services/firebase_note_services.dart';
import 'package:intl/intl.dart';
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

  Future<void> _confirmDeleteNote() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
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
      await noteServices.deleteNote(widget.note.id, widget.note.userId);
      if (mounted) {
        Navigator.pop(context);
      }
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

  String _formatUpdatedAt(int updatedAt) {
    final updatedDate = DateTime.fromMillisecondsSinceEpoch(updatedAt);
    final now = DateTime.now();
    final difference = now.difference(updatedDate);

    if (difference.inDays == 0) {
      return 'Updated ${TimeOfDay.fromDateTime(updatedDate).format(context)}';
    } else if (difference.inDays == 1) {
      return 'Updated Yesterday ${TimeOfDay.fromDateTime(updatedDate).format(context)}';
    } else {
      return 'Updated ${DateFormat('MMM d, yyyy').format(updatedDate)}';
    }
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
          Text(
            _formatUpdatedAt(widget.note.updatedAt),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDeleteNote,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuillToolbarHistoryButton(
                    isUndo: true,
                    controller: contentController,
                  ),
                  QuillToolbarHistoryButton(
                    isUndo: false,
                    controller: contentController,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: contentController,
                    attribute: Attribute.bold,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: contentController,
                    attribute: Attribute.italic,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: contentController,
                    attribute: Attribute.underline,
                  ),
                  QuillToolbarToggleCheckListButton(
                    controller: contentController,
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
