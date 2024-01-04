import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? username;
  String? location;
  String? profileImageUrl;

  UserModel({
    this.uid,
    this.email,
    this.username,
    this.location,
    this.profileImageUrl,
  });

  // Data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      location: map['lokasi'],
      profileImageUrl: map['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'lokasi': location,
      'profileImageUrl': profileImageUrl,
    };
  }

  Future<void> updateAddress(String newAddress) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    try {
      await users.doc(uid).update({'address': newAddress});
    } catch (e) {
      print("Error updating address: $e");
    }
  }

  static Future<void> deleteUserFromFirestore(String uid) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(uid).delete();
    } catch (e) {
      print("Error deleting user from Firestore: $e");
      rethrow;
    }
  }

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

  // New method to add user to Firestore during registration with username and profile picture
  static Future<void> addUserToFirestoreWithUsername({
    required String userId,
    required String email,
    required String location,
    required String username,
    required String profileImageUrl, // Add profileImageUrl parameter
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(userId).set({
        'uid': userId,
        'email': email,
        'lokasi': location,
        'username': username,
        'profileImageUrl':
            profileImageUrl, // Store profile picture URL in Firestore
      });
    } catch (e) {
      print("Error adding user to Firestore: $e");
      rethrow;
    }
  }

  // New method to get user stream from Firestore
  static Stream<UserModel?> getUserStreamFromFirestore(String uid) {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      return users.doc(uid).snapshots().map(
            (snapshot) =>
                snapshot.exists ? UserModel.fromMap(snapshot.data()) : null,
          );
    } catch (e) {
      print("Error getting user stream: $e");
      rethrow;
    }
  }
}
