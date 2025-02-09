class UserModel {
  String uid;
  String email;
  String? displayName;
  String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
    );
  }
}
