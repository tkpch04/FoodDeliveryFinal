// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_apps/pages/transaksi_done.dart';
import 'package:food_delivery_apps/pages/delivery_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_apps/model/user_model.dart';
import 'package:food_delivery_apps/utils/utils.dart';

import '../model/cart_model.dart';

class CartPage extends StatefulWidget {
  final String uid;
  const CartPage({super.key, required this.uid});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserModel.getUserFromFirestore(widget.uid);
  }

  Widget _buildUserInfo() {
    return FutureBuilder<UserModel?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              "User not found",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atas Nama: \n${snapshot.data!.username ?? "N/A"}',
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Akan di kirimkan ke Lokasi: ${snapshot.data!.lokasi ?? "N/A"}',
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 26),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildTotalAmount(CartModel cartModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Anda akan menyelesaikan pesanan dengan total:"),
        const SizedBox(height: 8),
        Text('Rp. ${cartModel.calculateTotal()}'),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context); // Close the dialog
      },
      child: const Text("Tidak"),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Clear the cart
        Provider.of<CartModel>(context, listen: false).clearCart();
        // Close the dialog
        Navigator.pop(context);
        // Navigate to the successful transaction page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeliveryPage(),
          ),
        );
      },
      child: const Text("Ya"),
    );
  }

  Widget _buildCartItem(List<dynamic> cartItem, int index) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Image.asset(
            cartItem[2],
            height: 36,
          ),
          title: Text(
            '${cartItem[0]} x${cartItem[5]}',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          subtitle: Text(
            '\Rp. ' + cartItem[1],
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          trailing: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.cancel),
            onPressed: () => Provider.of<CartModel>(context, listen: false)
                .removeItemFromCart(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(15),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(""),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "My Cart",
                  style: GoogleFonts.notoSerif(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: value.cartItems.isEmpty
                      ? const Center(
                          child: Text(
                            'Daftar pesananmu kosong, \n isi dengan pilihan menu lezat yuk',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: value.cartItems.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            final cartItem = value.cartItems[index];
                            if (cartItem is List<dynamic>) {
                              return _buildCartItem(cartItem, index);
                            } else {
                              return Container();
                            }
                          },
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(color: Colors.green[200]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp. ${value.calculateTotal()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Konfirmasi Pesanan"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildUserInfo(),
                                    const SizedBox(height: 20),
                                    _buildTotalAmount(value),
                                    const SizedBox(height: 20),
                                    const Text(
                                        "Apakah Anda yakin ingin melanjutkan?"),
                                  ],
                                ),
                                actions: [
                                  _buildCancelButton(context),
                                  _buildConfirmButton(context),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pay Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
