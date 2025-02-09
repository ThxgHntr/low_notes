import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditNote extends StatefulWidget {
  const EditNote({
    super.key,
    required this.titleController,
    required this.contentController,
  });

  final TextEditingController titleController;
  final QuillController contentController;

  @override
  EditNoteState createState() => EditNoteState();
}

class EditNoteState extends State<EditNote> {
  @override
  void dispose() {
    widget.titleController.dispose();
    widget.contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: widget.titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 24.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - 250,
                ),
                child: QuillEditor.basic(
                  controller: widget.contentController,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
