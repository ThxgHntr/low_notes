# Low Notes

Low Notes is a cross-platform note-taking application built with Flutter. It allows users to create, edit, and delete notes with rich text formatting and image support. The application uses Firebase for authentication and data storage.

## Features

- Create, edit, and delete notes
- Rich text formatting with Flutter Quill
- Image support for notes
- Firebase authentication
- Firebase Realtime Database for storing notes
- Responsive design for different screen sizes

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase account: [Create a Firebase project](https://firebase.google.com/)

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/your-username/low_notes.git
   cd low_notes
   ```

2. Install dependencies:

   ```sh
   flutter pub get
   ```

3. Set up Firebase:

   - Follow the instructions to add Firebase to your Flutter app: [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup)
   - Download the `google-services.json` file for Android and place it in the `android/app` directory.
   - Download the `GoogleService-Info.plist` file for iOS and place it in the `ios/Runner` directory.

4. Run the app:
   ```sh
   flutter run
   ```

## Project Structure

```
lib/
├── src/
│   ├── app.dart                # Main application widget
│   ├── home/                   # Home screen and related widgets
│   ├── login/                  # Login screen and related widgets
│   ├── models/                 # Data models
│   ├── services/               # Firebase services
│   ├── settings/               # Settings screen and related widgets
│   ├── widgets/                # Reusable widgets
│   └── localization/           # Localization files
├── main.dart                   # Entry point of the application
```

## Localization

This project supports localization using arb files found in the `lib/src/localization` directory. To add support for additional languages, follow the [Internationalizing Flutter apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization) guide.

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/your-feature-name`.
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [Flutter Quill](https://pub.dev/packages/flutter_quill)
