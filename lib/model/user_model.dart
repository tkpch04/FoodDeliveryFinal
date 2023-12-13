import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Dapatkan data pengguna dari Firestore berdasarkan UID
  static Future<UserModel?> getUserFromFirestore(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data());
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }
}
