import 'package:flutter/material.dart';
import 'package:low_notes/src/models/note_model.dart';
import 'package:low_notes/src/services/firebase_auth_services.dart'; // Add this import
import '../widgets/expandable_fab.dart'; // Add this import

import '../settings/settings_view.dart';
import '../login/login_view.dart'; // Add this import
import 'note_details_view.dart';

/// Displays a list of SampleItems.
class NoteItemListView extends StatefulWidget {
  const NoteItemListView({
    super.key,
    this.items = const [],
  });

  static const routeName = '/';

  final List<NoteModel> items;

  @override
  NoteItemListViewState createState() => NoteItemListViewState();
}

class NoteItemListViewState extends State<NoteItemListView> {
  final FirebaseAuthServices authServices = FirebaseAuthServices();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authServices.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, LoginView.routeName);
          });
          return const SizedBox.shrink();
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, SettingsView.routeName);
                  },
                ),
              ],
              title: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                  ),
                ),
              ),
            ),
            body: ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.items[index];
                if (item.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())) {
                  return ListTile(
                    title: Text(item.title),
                    onTap: () {
                      Navigator.restorablePushNamed(
                        context,
                        NoteDetailsView.routeName,
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            floatingActionButton: const ExpandableFab(),
          );
        }
      },
    );
  }
}
