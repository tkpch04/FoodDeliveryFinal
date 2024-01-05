// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_apps/components/ordered_item.dart';
import 'package:food_delivery_apps/model/cart_model.dart';
import 'package:food_delivery_apps/model/user_model.dart';
import 'package:food_delivery_apps/pages/transaction_success.dart';
import 'package:food_delivery_apps/theme_manager/day_night.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartNotifier extends ChangeNotifier {
  List<OrderedItem> orderedItems = [];

  void addOrderedItem(OrderedItem item) {
    orderedItems.add(item);
    notifyListeners();
  }
}

class ImageProviderModel extends ChangeNotifier {
  XFile? _image;

  XFile? get image => _image;

  void clearImage() {
    _image = null;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      _image = null; // Clear the previous image
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _image = pickedFile;
        notifyListeners(); // Notify listeners after updating image
      } else {
        print("Image picking canceled by the user.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> uploadProfileImage(String userId, File imageFile) async {
    try {
      print("UID: $userId, Storage Path: $userId/profile.jpg");

      Reference storageRef =
          FirebaseStorage.instance.ref().child("$userId/profile.jpg");
      await storageRef.putFile(imageFile);

      String downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('{DEFAULT}')
          .doc(userId)
          .update({'profileImageUrl': downloadUrl});

      notifyListeners(); // Notify listeners after updating profile image URL
    } catch (e) {
      print("Error uploading profile image: $e");
    }
  }
}

class AccountPage extends StatefulWidget {
  final String uid;

  const AccountPage({
    super.key,
    required this.uid,
    required List<OrderedItem> orderedItems,
    required double totalPrice,
  });

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Stream<UserModel?> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = UserModel.getUserStreamFromFirestore(widget.uid);
  }

  Future<void> _handleLogout() async {
    try {
      // Clear cached local image
      Provider.of<ImageProviderModel>(context, listen: false).clearImage();

      // Clear cached network image
      String? imageUrl =
          Provider.of<ImageProviderModel>(context, listen: false).image?.path;
      if (imageUrl != null) {
        await CachedNetworkImage.evictFromCache(imageUrl);
      }

      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<void> _handleDeleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("User not signed in.");
        return;
      }

      // Prompt the user to enter their current password
      String? password = await _promptForPassword();

      if (password == null || password.isEmpty) {
        // User canceled the password prompt or entered an empty password
        return;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
                "Are you sure you want to delete your account? This action is irreversible."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // Delete user information from Firestore
        await UserModel.deleteUserFromFirestore(widget.uid);

        // Delete user account
        await user.delete();

        // Sign out user
        await FirebaseAuth.instance.signOut();

        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  Future<String?> _promptForPassword() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController passwordController = TextEditingController();
        return AlertDialog(
          title: const Text("Enter Your Password"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(passwordController.text),
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _toggleDarkMode() {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  }

  Future<void> _handleEditAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressPage(),
      ),
    );

    if (result != null) {
      UserModel? user = await UserModel.getUserFromFirestore(widget.uid);
      await user?.updateAddress(result);
    }
  }

  Future<void> _handlePickImage() async {
    try {
      final imageProvider =
          Provider.of<ImageProviderModel>(context, listen: false);

      // Clear the cached profile image if it exists
      if (imageProvider.image != null) {
        CachedNetworkImageProvider(imageProvider.image!.path,
                cacheKey: UniqueKey().toString())
            .evict();
      }

      await imageProvider.pickImage();
      if (imageProvider.image != null) {
        await imageProvider.uploadProfileImage(
          widget.uid,
          File(imageProvider.image!.path),
        );

        // Trigger a rebuild of the widget tree
        setState(() {});
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: _toggleDarkMode,
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _handleLogout,
            ),
          ],
        ),
        body: Consumer<ImageProviderModel>(
          builder: (context, imageProvider, child) {
            return StreamBuilder<UserModel?>(
              stream: _userStream,
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
                  UserModel user = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: GestureDetector(
                              onTap: _handlePickImage,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    key: UniqueKey(),
                                    backgroundImage: imageProvider.image != null
                                        ? FileImage(
                                            File(imageProvider.image!.path))
                                        : (user.profileImageUrl != null &&
                                                        user.profileImageUrl!
                                                            .isNotEmpty
                                                    ? CachedNetworkImageProvider(
                                                        user.profileImageUrl!,
                                                        cacheKey: user
                                                            .profileImageUrl,
                                                      ).evict()
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
                        // Card for email and Location
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
                                    Expanded(
                                      child: Text(
                                        'Email       :  ${snapshot.data!.email ?? "N/A"}',
                                        style: const TextStyle(fontSize: 18),
                                        overflow: TextOverflow
                                            .ellipsis, // Truncate text if it overflows
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 20, color: Colors.green),
                                        const SizedBox(width: 7),
                                        Expanded(
                                          child: Text(
                                            'Location  :  ${snapshot.data!.location ?? "N/A"}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        const SizedBox(width: 220),
                                        InkWell(
                                          onTap: _handleEditAddress,
                                          child: const Row(
                                            children: [
                                              Icon(Icons.edit, size: 18),
                                              SizedBox(width: 5),
                                              Text(
                                                'Edit Address',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '   Transaksi',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            //SizedBox(height: 2),
                            Card(
                              margin: const EdgeInsets.all(20),
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          'assets/design/images/delivery-1.png', // Ganti dengan path gambar yang sesuai
                                          width: 50,
                                          height: 100,
                                        ),
                                        const SizedBox(
                                          width: 250,
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.grey,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue),
                                          ),
                                        ),
                                        //SizedBox(height: 6),
                                      ],
                                    ),
                                    Consumer<CartModel>(
                                      builder: (context, value, child) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: value.orderHistory.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                '${value.orderHistory[index][0]} x${value.orderHistory[index][5]}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'Rp. ${value.orderHistory[index][1]}', // x ${value.orderHistory[index][3]}
                                                style: const TextStyle(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //untuk hapus ongoingdelivery yg ada di list
                                          Provider.of<CartModel>(context,
                                                  listen: false)
                                              .clearOngoingDelivery();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const TransactionSuccess(),
                                              ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: const Text(
                                          "Pesanan Diterima",
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Set text color to white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: _handleDeleteAccount,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .red, // Change the color as needed
                                  ),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text(
                                      'Delete Account',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class EditAddressPage extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  EditAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit your address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String userId = user!.uid;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({'lokasi': _addressController.text});
                Navigator.pop(context, _addressController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
