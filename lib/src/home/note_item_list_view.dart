import 'package:flutter/material.dart';
import 'package:low_notes/src/models/note_model.dart';
import 'package:low_notes/src/services/firebase_auth_services.dart'; // Add this import

import '../settings/settings_view.dart';
import '../login/login_view.dart'; // Add this import
import 'note_details_view.dart';

/// Displays a list of SampleItems.
class NoteItemListView extends StatelessWidget {
  const NoteItemListView({
    super.key,
    this.items = const [],
  });

  static const routeName = '/';

  final List<NoteModel> items;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthServices authServices = FirebaseAuthServices();

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
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.restorablePushNamed(
                        context, SettingsView.routeName);
                  },
                ),
              ],
            ),
            body: ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return ListTile(
                  title: Text('SampleItem ${item.id}'),
                  leading: const CircleAvatar(
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () {
                    Navigator.restorablePushNamed(
                      context,
                      NoteDetailsView.routeName,
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
