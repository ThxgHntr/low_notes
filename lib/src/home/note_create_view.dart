import 'package:flutter/material.dart';
import '../widgets/edit_note.dart';

class NoteCreateView extends StatelessWidget {
  const NoteCreateView({super.key});

  static const routeName = '/note-create';

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
      ),
      body: const EditNote(),
    );
  }
}
