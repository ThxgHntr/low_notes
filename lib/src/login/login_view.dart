import 'package:flutter/material.dart';
import 'package:low_notes/src/services/firebase_auth_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const routeName = '/login';

  @override
  LoginViewState createState() => LoginViewState(); // Rename state class
}

class LoginViewState extends State<LoginView> {
  // Rename state class
  final FirebaseAuthServices authServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await authServices.signInWithGoogle();
            if (context.mounted) {
              Navigator.pushNamed(context, '/');
            }
          },
          icon: const FaIcon(FontAwesomeIcons.google),
          label: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
