import 'package:flutter/material.dart';
import 'package:food_delivery_apps/pages/login_page.dart';
import 'package:food_delivery_apps/controller/controller.dart';
import 'package:food_delivery_apps/utils/theme_shared.dart';

class Registrasi extends StatefulWidget {
  const Registrasi({super.key});

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  bool _isHiddenPassword = true;
  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Controller();
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
                            return "Nama harus diisi";
                          }
                          return null;
                        },
                        controller: controller.namaTextController,
                        decoration: InputDecoration(
                            prefix: Icon(Icons.person_2_outlined),
                            labelText: ('Nama'),
                            hintText: ("Adi Kuswanto"),
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email harus diisi";
                          }
                          return null;
                        },
                        controller: emailTextController,
                        decoration: InputDecoration(
                            prefix: Icon(Icons.messenger_outline_outlined),
                            labelText: ('Email'),
                            hintText: ("123@gmail.com"),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password harus diisi";
                          }
                          if (value != passwordTextController.text) {
                            return 'Password tidak sesuai';
                          }
                          return null;
                        },
                        controller: konfirmasiPasswordController,
                        decoration: InputDecoration(
                          prefix: Icon(Icons.key_off_rounded),
                          labelText: ('Konfirmasi Password'),
                          hintText: ("Konfirmasi Password"),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Lokasi harus diisi";
                          }
                          return null;
                        },
                        controller: controller.lokasiTextController,
                        decoration: InputDecoration(
                            prefix: Icon(Icons.location_city_outlined),
                            labelText: ('Lokasi'),
                            hintText: ("JL.Arif rahman hakim"),
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.signUp(context, emailTextController.text,
                                passwordTextController.text);
                          }
                        },
                        child: Text(
                          "Registrasi",
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
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text("Suda punya akun? Login"),
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
