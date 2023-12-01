import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollectionConstant {
  static CollectionReference getUserCollection() {
    return FirebaseFirestore.instance.collection('users');
  }
}
