class NoteModel {
  String id;
  String userId;
  String title;
  String content;
  String? imageUrl;
  int createdAt;
  int updatedAt;

  NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
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
      content: map['content'],
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
