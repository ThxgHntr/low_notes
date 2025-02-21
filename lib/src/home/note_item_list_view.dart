import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:low_notes/src/models/note_model.dart';
import 'package:low_notes/src/services/firebase_auth_services.dart';
import 'package:low_notes/src/services/firebase_note_services.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/note_item.dart';
import 'note_edit_view.dart'; // Add this import

import '../settings/settings_view.dart';
import '../login/login_view.dart';

class NoteItemListView extends StatefulWidget {
  const NoteItemListView({
    super.key,
  });

  static const routeName = '/';

  @override
  NoteItemListViewState createState() => NoteItemListViewState();
}

class NoteItemListViewState extends State<NoteItemListView> {
  final FirebaseAuthServices authServices = FirebaseAuthServices();
  final FirebaseNoteServices noteServices = FirebaseNoteServices();
  String _searchQuery = '';
  Stream<List<NoteModel>>? _notesStream;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await authServices.isLoggedIn();
    if (isLoggedIn) {
      String userId = await authServices.getUserId();
      setState(() {
        _notesStream = noteServices.fetchNotes(userId);
      });
    } else {
      if (mounted) Navigator.pushReplacementNamed(context, LoginView.routeName);
    }
  }

  @override
  void dispose() {
    noteServices.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final searchFieldColor = isDarkTheme ? Colors.grey[800] : Colors.grey[100];
    final searchFieldTextColor = isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
        title: Center(
          child: Container(
            decoration: BoxDecoration(
              color: searchFieldColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: searchFieldTextColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              style: TextStyle(color: searchFieldTextColor),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading notes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notes available'));
          } else {
            final notes = snapshot.data!
                .where((item) => item.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();
            return Padding(
              padding: const EdgeInsets.all(8),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NoteEditView(note: notes[index]),
                        ),
                      );
                    },
                    onLongPress: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Note'),
                            content: const Text(
                                'Are you sure you want to delete this note?'),
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
                        await noteServices.deleteNote(
                            notes[index].id, notes[index].userId);
                      }
                    },
                    child: NoteItem(note: notes[index]),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: const ExpandableFab(),
    );
  }
}
