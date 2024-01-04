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

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _image = pickedFile;
        notifyListeners();
      } else {
        print("Image picking canceled by the user.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> uploadProfileImage(String userId, File imageFile) async {
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child("users/$userId/profile.jpg");
      await storageRef.putFile(imageFile);

      String downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImageUrl': downloadUrl});

      notifyListeners();
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
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _handleDeleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("User not signed in.");
        return;
      }

      AuthCredential credential;

      credential = EmailAuthProvider.credential(
        email: user.email!,
        password: "password",
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
        await user.delete();
        await UserModel.deleteUserFromFirestore(widget.uid);
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
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

      if (imageProvider.image != null) {
        CachedNetworkImageProvider(imageProvider.image!.path).evict();
      }

      await imageProvider.pickImage();

      if (imageProvider.image != null) {
        await imageProvider.uploadProfileImage(
            widget.uid, File(imageProvider.image!.path));
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
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          child: Center(
                            child: GestureDetector(
                              onTap: _handlePickImage,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: imageProvider.image != null
                                        ? FileImage(
                                            File(imageProvider.image!.path))
                                        : (snapshot.data?.profileImageUrl !=
                                                        null
                                                    ? NetworkImage(snapshot
                                                        .data!.profileImageUrl!)
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
                                      'Location  :  ${snapshot.data!.location ?? "N/A"}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '   Transactions',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Consumer<CartModel>(
                              builder: (context, value, child) {
                                if (value.orderHistory.isEmpty) {
                                  return const Card(
                                    margin: EdgeInsets.all(20),
                                    elevation: 8,
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Text(
                                          'Belum ada pesanan',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Card(
                                    margin: const EdgeInsets.all(20),
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Center(
                                            child: Text(
                                              'Pesanan Sedang Dikirim',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/design/images/delivery-1.png',
                                                width: 70,
                                                height: 100,
                                              ),
                                              const SizedBox(
                                                width: 250,
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.grey,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.blue),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: value.orderHistory
                                                .map<Widget>((item) {
                                              return ListTile(
                                                title: Text(
                                                  '${item[0]} x${item[5]}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Provider.of<CartModel>(context,
                                                        listen: false)
                                                    .clearOngoingDelivery();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TransactionSuccess(
                                                            orderedItems: [],
                                                            totalPrice: 0.0),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: const Text(
                                                "Pesanan Diterima",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
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

  EditAddressPage({Key? key}) : super(key: key);

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
