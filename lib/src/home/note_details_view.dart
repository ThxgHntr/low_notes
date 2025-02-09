import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class NoteDetailsView extends StatelessWidget {
  const NoteDetailsView({super.key});

  static const routeName = '/note-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
