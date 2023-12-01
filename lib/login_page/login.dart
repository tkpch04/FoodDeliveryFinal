//import 'package:food_delivery_apps/home_screen/home.dart';
import 'package:food_delivery_apps/login_page/registrasi.dart';
import 'package:food_delivery_apps/login_page/theme_shared.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_apps/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHiddenPassword = true;
  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              SizedBox(
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
                  padding: EdgeInsets.symmetric(vertical: 20.0),
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
                        decoration: InputDecoration(
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
                          prefix: Icon(Icons.fingerprint),
                          labelText: ('Password'),
                          hintText: ("Password"),
                          border: OutlineInputBorder(),
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()));
                        },
                        child: Text(
                          "Login",
                          style: blackTextStyle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ).copyWith(
                          minimumSize: MaterialStateProperty.all(
                            Size(double.infinity,
                                50), // Atur tinggi sesuai kebutuhan
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Registrasi(),
                            ),
                          );
                        },
                        child: Text("Belum punya akun? Registrasi"),
                      )
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
