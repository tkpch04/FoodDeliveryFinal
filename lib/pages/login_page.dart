import 'package:flutter/material.dart';
import 'package:food_delivery_apps/pages/registration_page.dart';
import 'package:food_delivery_apps/controller/controller.dart';
import 'package:food_delivery_apps/utils/theme_shared.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHiddenPassword = true;
  String errorMessage = ''; // Added variable to store error message

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final Controller controller;

  @override
  void initState() {
    super.initState();
    controller = Controller(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(defaultMargin),
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
              Text(
                'Silahkan Login',
                style: blackTextStyle.copyWith(
                    fontSize: 30, fontWeight: FontWeight.w600),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email harus diisi";
                          }
                          return null;
                        },
                        controller: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            prefix: Icon(Icons.person_outline_outlined),
                            labelText: ('Email'),
                            hintText: ("1234@gmail.com"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password harus diisi";
                          }
                          return null;
                        },
                        controller: passwordTextController,
                        decoration: InputDecoration(
                          prefix: const Icon(Icons.fingerprint),
                          labelText: ('Password'),
                          hintText: ("Password"),
                          border: const OutlineInputBorder(),
                          suffixIcon: InkWell(
                            onTap:
                                _togglePasswordView, // Memanggil fungsi untuk mengganti tampilan password
                            child: Icon(
                              _isHiddenPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: _isHiddenPassword,
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Validate form
                          if (_formKey.currentState!.validate()) {
                            // Call the signIn method
                            controller.signIn(
                              emailTextController.text,
                              passwordTextController.text,
                              // Add a callback to handle login failure
                              onLoginFailure: (error) {
                                setState(() {
                                  errorMessage = error;
                                });
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ).copyWith(
                          minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity,
                                50), // Atur tinggi sesuai kebutuhan
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: blackTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
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
                              builder: (context) => const Registrasi(),
                            ),
                          );
                        },
                        child: const Text("Belum punya akun? Registrasi"),
                      ),

                      // Display error message
                      errorMessage.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                errorMessage,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
