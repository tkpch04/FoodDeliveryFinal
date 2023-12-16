import 'package:flutter/material.dart';
import 'package:food_delivery_apps/pages/login_page.dart';
import 'package:food_delivery_apps/pages/registrasi_page.dart';
import 'package:food_delivery_apps/utils/theme_shared.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        bottom: false,
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            children: [
              Image.asset(
                'assets/images/fast_food.png',
                height: 333,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: welcomeTextStyle,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Pesan makanan ga perlu antri lama ',
                style: blackTextStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(
                height: 51,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width - 2 * defaultMargin,
                child: ElevatedButton(
                  onPressed: () {
                    // modal tampilan registrasi screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Registrasi()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Buat Akun',
                    style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width - 2 * defaultMargin,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(15))),
                  child: Text(
                    'Login',
                    style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
