import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import '../models/note_model.dart';

class FirebaseNoteServices {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('notes');
  final StreamController<List<NoteModel>> _notesController =
      StreamController<List<NoteModel>>.broadcast();

  Future<void> saveNote(NoteModel note) async {
    await _database.child(note.userId).child(note.id).set(note.toMap());
  }

  Future<void> updateNote(NoteModel note) async {
    await _database.child(note.userId).child(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String noteId, String userId) async {
    await _database.child(userId).child(noteId).remove();
  }

  Stream<List<NoteModel>> fetchNotes(String userId) {
    _database.child(userId).onValue.listen((event) {
      final notes = <NoteModel>[];
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          notes.add(NoteModel.fromMap(Map<String, dynamic>.from(value)));
        });
      }
      _notesController.add(notes);
    });
    return _notesController.stream;
  }

  void dispose() {
    _notesController.close();
  }
}
