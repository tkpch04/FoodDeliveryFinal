import 'package:flutter/material.dart';
import 'package:food_delivery_apps/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  final String uid;

  AccountPage({Key? key, required this.uid}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserModel.getUserFromFirestore(widget.uid);
  }

  // Function to handle user logout
  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login page or any other page you want after logout
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Page'),
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text("User not found");
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username: ${snapshot.data!.username ?? "N/A"}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Email: ${snapshot.data!.email ?? "N/A"}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Lokasi: ${snapshot.data!.lokasi ?? "N/A"}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
