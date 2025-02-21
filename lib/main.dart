import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:low_notes/firebase_options.dart';
import 'package:flutter/foundation.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  try {
    // Check if the app is running on the web
    if (kIsWeb) {
      // Initialize Firebase for web
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      // Initialize Firebase for mobile
      await Firebase.initializeApp(
        name: 'Low Notes',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    final settingsController = SettingsController(SettingsService());

    // Load the user's preferred theme while the splash screen is displayed.
    // This prevents a sudden theme change when the app is first displayed.
    await settingsController.loadSettings();

    // Run the app and pass in the SettingsController. The app listens to the
    // SettingsController for changes, then passes it further down to the
    // SettingsView.
    runApp(MyApp(settingsController: settingsController));
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error during Firebase initialization: $e');
      print(stackTrace);
    }
  }
}
