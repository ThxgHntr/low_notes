import 'package:flutter/material.dart';
import '../widgets/edit_note.dart'; // Add this import

/// Displays detailed information about a SampleItem.
class NoteDetailsView extends StatelessWidget {
  const NoteDetailsView({super.key});

  static const routeName = '/note-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      // body: const EditNote(),
    );
  }
}
