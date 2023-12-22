// ignore_for_file: unused_import, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:food_delivery_apps/components/order_history_page.dart';
import 'package:food_delivery_apps/model/user_model.dart';
import 'package:food_delivery_apps/pages/home_page.dart';
import 'package:food_delivery_apps/theme_manager/day_night.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviderModel extends ChangeNotifier {
  XFile? _image;

  XFile? get image => _image;

  void pickImage() async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _image = pickedFile;
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}

class AccountPage extends StatefulWidget {
  final String uid;

  const AccountPage({super.key, required this.uid});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<UserModel?> _userFuture;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _userFuture = UserModel.getUserFromFirestore(widget.uid);
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _toggleDarkMode() {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        // onPopInvoked: (bool didPop) {
        //   if (didPop) {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const HomePage(
        //             uid: '',
        //           ),
        //         ));
        //   }
        // },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: _toggleDarkMode,
              ),
              // IconButton(
              //   icon: const Icon(Icons.history),
              //   onPressed: () {
              //     // Navigate to the order history screen
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const OrderHistoryPage(),
              //       ),
              //     );
              //   },
              // ),
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: _handleLogout,
              ),
            ],
          ),
          body: Consumer<ImageProviderModel>(
            builder: (context, imageProvider, child) {
              return FutureBuilder<UserModel?>(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text(
                        "User not found",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  imageProvider.pickImage();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage: imageProvider.image !=
                                              null
                                          ? FileImage(
                                              File(imageProvider.image!.path))
                                          : (snapshot.data?.profileImageUrl !=
                                                          null
                                                      ? NetworkImage(
                                                          snapshot.data!
                                                              .profileImageUrl!)
                                                      : const AssetImage(
                                                          'assets/default-avatar.png'))
                                                  as ImageProvider<Object>? ??
                                              const AssetImage(
                                                  'assets/default-avatar.png'),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      snapshot.data!.username ?? "N/A",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(16),
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.email,
                                          size: 20, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Email       :  ${snapshot.data!.email ?? "N/A"}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 20, color: Colors.green),
                                      const SizedBox(width: 7),
                                      Text(
                                        'Location  :  ${snapshot.data!.lokasi ?? "N/A"}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
        ));
  }
}
