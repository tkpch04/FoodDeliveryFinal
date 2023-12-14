import 'package:flutter/material.dart';
import 'package:food_delivery_apps/utils/utils.dart';
import 'package:food_delivery_apps/pages/welcome_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Gunakan Future.delayed untuk menunda tampilan Splash Page
    Future.delayed(Duration(seconds: 3), () {
      // Navigasi ke halaman berikutnya setelah penundaan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SplashHomePage()), // Gantilah dengan halaman berikutnya
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFFFFA500),
      body: Center(
        child: Image.asset(
          'assets/splash/iconBurgerSplash.png',
        ),
      ),
    );
  }
}

class SplashHomePage extends StatelessWidget {
  const SplashHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gambar di tengah
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/splash/intro-bg.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                alignment: AlignmentDirectional.center,
              ),
            ),
          ),

          // Lapisan hitam transparan di setengah bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Tombol di tengah bawah
          Positioned(
            bottom: 48.0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '  Find and Get\n  Your Best Food',
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.1725,
                    color: Colors.white,
                  ),
                ),
                Container(height: 20),
                Text(
                  '     Find the most delicious food \n     with the best quality and free delivery here',
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    height: 1.1725,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 35),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aksi yang ingin dilakukan saat tombol ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomePage(),
                        ),
                      );
                    },
                    child: Image.asset('assets/splash/start-button.png'),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(9),
                        primary: Colors.orange),
                  ),
                ),
                SizedBox(height: 30), // Jarak antara ElevatedButton dan Text
                Center(
                  child: Text(
                    'Start',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
