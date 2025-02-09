import 'package:firebase_database/firebase_database.dart';
import '../models/note_model.dart';

class FirebaseNoteServices {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('notes');

  Future<void> saveNote(NoteModel note) async {
    await _database.child(note.userId).child(note.id).set(note.toMap());
  }
}
