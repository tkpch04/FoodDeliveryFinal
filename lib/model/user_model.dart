class UserModel {
  String? uid;
  String? email;
  String? username;
  String? lokasi;

  UserModel({this.uid, this.email, this.username, this.lokasi});

  // data dari server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        username: map['username'],
        lokasi: map['lokasi']);
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'username': username, 'lokasi': lokasi};
  }
}
