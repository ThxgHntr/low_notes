import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteModel {
  String id;
  String userId;
  String title;
  quill.Document note; // Change to quill.Document
  String? imageUrl;
  int createdAt;
  int updatedAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.note,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'note': note.toDelta().toJson(), // Convert to JSON
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      note: quill.Document.fromJson(map['note']), // Convert from JSON
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
