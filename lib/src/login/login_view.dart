import 'package:flutter/material.dart';
import 'package:low_notes/src/services/firebase_auth_services.dart';

/// Displays detailed information about a SampleItem.
class NoteDetailsView extends StatefulWidget {
  const NoteDetailsView({super.key});

  static const routeName = '/login';

  @override
  NoteDetailsViewState createState() => NoteDetailsViewState();
}

class NoteDetailsViewState extends State<NoteDetailsView> {
  final FirebaseAuthServices authServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authServices.signInWithGoogle();
            if (context.mounted) {
              Navigator.pushNamed(context, '/');
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
