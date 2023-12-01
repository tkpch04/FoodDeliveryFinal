import 'package:flutter/material.dart';
import 'package:food_delivery_apps/login_page/login.dart';
import 'package:food_delivery_apps/login_page/theme_shared.dart';
import 'package:food_delivery_apps/authentication/authentication.dart';

class Registrasi extends StatefulWidget {
  Registrasi({super.key});

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  @override
  Widget build(BuildContext context) {
    bool _isHiddenPassword = true;
    void _togglePasswordView() {
      setState(() {
        _isHiddenPassword = !_isHiddenPassword;
      });
    }

    final controller = AuthController();
    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
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
                  'Silahkan Registrasi',
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
                              return "Nama harus disi";
                            }
                            return null;
                          },
                          controller: controller.namaTextController,
                          decoration: InputDecoration(
                              prefix: Icon(Icons.person_outline_rounded),
                              labelText: ('Nama'),
                              hintText: ("Adi nugroho"),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email harus disi";
                            }
                            return null;
                          },
                          controller: controller.emailTextController,
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
                            if (value!.isEmpty || value.length < 6) {
                              return "Password harus lebih dari 6 karakter";
                            }
                            return null;
                          },
                          controller: controller.passwordTextController,
                          decoration: InputDecoration(
                            prefix: Icon(Icons.fingerprint),
                            labelText: ('Password'),
                            hintText: ("Password"),
                            border: OutlineInputBorder(),
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
                              return "Password harus disi";
                            }

                            if (value !=
                                controller.passwordTextController.text) {
                              return "Password tidak sesuai";
                            }
                            return null;
                          },
                          controller: controller.konfirmasiPasswordController,
                          decoration: InputDecoration(
                            prefix: Icon(Icons.key_off_rounded),
                            labelText: ('Konfirmasi Password'),
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
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Lokasi harus disi";
                            }
                            return null;
                          },
                          controller: controller.lokasiTextController,
                          decoration: InputDecoration(
                              prefix: Icon(Icons.person_outline_rounded),
                              labelText: ('Lokasi'),
                              hintText: ("JL.Simpang raya no 17"),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await controller.signUpUser();
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
                            controller.emailTextController.clear();
                            controller.passwordTextController.clear();
                            controller.namaTextController.clear();
                            controller.konfirmasiPasswordController.clear();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text("Sudah punya akun? Login"),
                        )
                      ],
                    ),
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
