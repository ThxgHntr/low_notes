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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final toolbarColor = isDarkTheme ? Colors.grey[800] : Colors.grey[300];
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
                  minHeight: screenHeight / 2,
                ),
                child: QuillEditor.basic(
                  controller: widget.contentController,
                ),
              ),
            ),
          ],
        ),
        
        Container(
          color: toolbarColor,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QuillToolbarHistoryButton(
                    isUndo: true,
                    controller: widget.contentController,
                  ),
                  QuillToolbarHistoryButton(
                    isUndo: false,
                    controller: widget.contentController,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: widget.contentController,
                    attribute: Attribute.bold,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: widget.contentController,
                    attribute: Attribute.italic,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: widget.contentController,
                    attribute: Attribute.underline,
                  ),
                  QuillToolbarToggleCheckListButton(
                    controller: widget.contentController,
                  ),
                  QuillToolbarFontSizeButton(
                    controller: widget.contentController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
