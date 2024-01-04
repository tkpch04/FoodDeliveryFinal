// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_apps/main.dart';
import 'package:food_delivery_apps/pages/login_page.dart';
import 'package:food_delivery_apps/model/user_model.dart';

class Controller {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final namaTextController = TextEditingController();
  final lokasiTextController = TextEditingController();
  final BuildContext context;

  Controller(this.context);

  Future<void> signIn(String email, String password,
      {Function(String)? onLoginFailure}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      User? user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } else {
        await signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email before logging in.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (onLoginFailure != null) {
        String errorMessage = _getFriendlyErrorMessage(e);
        onLoginFailure(errorMessage);
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  String _getFriendlyErrorMessage(dynamic error) {
    String errorMessage = 'Login failed. Please check your credentials.';

    if (error is FirebaseAuthException) {
      if (error.code == 'user-disabled') {
        errorMessage =
            "Access to this account has been temporarily disabled due to many failed login attempts. "
            "Please try again later. You can immediately restore it by resetting your password or you can try again later.";
      } else if (error.code == 'wrong-password') {
        errorMessage = "Wrong password. Please check your credentials.";

        // Check for too many unsuccessful attempts
        if (error.message?.contains('TOO_MANY_ATTEMPTS_TRY_LATER') == true) {
          errorMessage =
              "Too many unsuccessful attempts. Please try again later.";
        }
      } else if (error.code == 'invalid-email' ||
          error.code == 'user-not-found') {
        errorMessage = "Login failed. Please check your credentials.";
      } else if (error.code == 'operation-not-allowed') {
        errorMessage = "Access has been blocked due to unusual activity. "
            "Try again later or reset your password to restore access.";
      }
    }

    // Add the debug console message to the error message
    errorMessage += '\n${error.toString()}';

    // Print the error message to the console
    print('Firebase Authentication Error: $errorMessage');

    return errorMessage;
  }


  Future<void> signUp(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()});
      Fluttertoast.showToast(msg: "Akun berhasil dibuat");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      String errorMessage = _getFriendlyErrorMessage(e);
      Fluttertoast.showToast(msg: errorMessage);
    }
  }

  Future<void> postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    String? username = namaTextController.text;
    String? lokasi = lokasiTextController.text;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.username = username;
    userModel.location = lokasi;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Akun berhasil dibuat");
  }
}
