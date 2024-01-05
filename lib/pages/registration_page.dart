// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_apps/model/user_model.dart';
import 'package:food_delivery_apps/pages/login_page.dart';

class Registrasi extends StatefulWidget {
  const Registrasi({super.key});

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  bool _isHiddenPassword = true;
  bool _isLoading = false;

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();
  final addressTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _registerAndSendVerificationEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Create user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // Get the current user
      User? user = _auth.currentUser;

      // Save additional user data to Firestore
      await UserModel.addUserToFirestoreWithUsername(
        userId: _auth.currentUser!.uid,
        email: emailTextController.text,
        location: addressTextController.text,
        username: nameTextController.text,
        profileImageUrl: '',
      );

      // Send email verification
      await user?.sendEmailVerification();

      // Redirect to a page that informs the user to check their email
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EmailVerificationInfoPage(),
        ),
      );
    } catch (e) {
      print('Failed to register and send verification email: $e');
      String errorMessage = 'Failed to register and send verification email';

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage =
              'The email address is already in use by another account.';
        } else {
          errorMessage = 'An error occurred: ${e.message}';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/taxi-fastfood.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email must be filled";
                          }
                          return null;
                        },
                        controller: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.email),
                          labelText: 'Email',
                          hintText: 'john.doe@example.com',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Address must be filled";
                          }
                          return null;
                        },
                        controller: addressTextController,
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.location_on),
                          labelText: 'Address',
                          hintText: '123 Main St, City',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name must be filled";
                          }
                          return null;
                        },
                        controller: nameTextController,
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.person),
                          labelText: 'Name',
                          hintText: 'John Doe',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password must be filled";
                          }
                          return null;
                        },
                        controller: passwordTextController,
                        decoration: InputDecoration(
                          prefix: const Icon(Icons.lock),
                          labelText: 'Password',
                          hintText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              _isHiddenPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: _isHiddenPassword,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password must be filled";
                          }
                          if (value != passwordTextController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        controller: konfirmasiPasswordController,
                        decoration: const InputDecoration(
                          prefix: Icon(Icons.lock),
                          labelText: 'Confirm Password',
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: _isHiddenPassword,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _registerAndSendVerificationEmail();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Already have an account? Login'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailVerificationInfoPage extends StatelessWidget {
  const EmailVerificationInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mail,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Registration Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Please check your email for a verification link. You need to verify your email to complete the registration process.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
