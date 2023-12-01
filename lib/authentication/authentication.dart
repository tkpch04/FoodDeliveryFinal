import 'dart:developer';

import 'package:food_delivery_apps/constant/constant_firebase.dart';
import 'package:food_delivery_apps/models/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AuthController extends GetxController {
  final namaTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final lokasiTextController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();
  final CollectionReference userCollection =
      FirebaseCollectionConstant.getUserCollection();

  Future<bool> _checkDuplicateUser() async {
    final users = await userCollection.get();
    return users.docs
        .any((element) => element['email'] == emailTextController.text);
  }

  Future<void> signUpUser() async {
    try {
      final isDuplicateEmail = await _checkDuplicateUser();

      if (isDuplicateEmail) {
        // Check if Get.context is not null before using it
        if (Get.context != null) {
          // Show the AlertDialog
          showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
              title: Text('Peringatan'),
              content: Text('Email sudah pernah dipakai, gunakan email lain.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      } else {
        // Menampilkan pesan bahwa registrasi berhasil menggunakan showDialog
        showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: Text('Info'),
            content: Text('Registrasi berhasil'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }

      final userModel = UserModel(
          id: '1',
          nama: namaTextController.text,
          email: emailTextController.text,
          password: passwordTextController.text,
          lokasi: lokasiTextController.text);
      final user = await userCollection.add(userModel.toJson());
      await userCollection.doc(user.id).update({'id': user.id});
    } catch (e, st) {
      log('Error for Sign Up $e, Stack Trace: $st');
    }
  }
}
