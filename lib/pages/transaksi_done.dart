import 'package:flutter/material.dart';
import 'package:food_delivery_apps/main.dart';

class TransaksiBerhasil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Transaksi Berhasil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 100.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Warna latar belakang tombol biru
              ),
              child: Text(
                'Kembali ke Homepage',
                style: TextStyle(
                  color: Colors.white, // Warna teks putih
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
