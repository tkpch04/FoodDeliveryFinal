import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/grocery_item_tile.dart';
import '../model/cart_model.dart';
import 'cart_page.dart';
import 'package:food_delivery_apps/utils/utils.dart';
import 'package:food_delivery_apps/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<UserModel?> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = UserModel.getUserStreamFromFirestore(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(""),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              User? user = FirebaseAuth.instance.currentUser;
              String uid = user?.uid ?? '';
              return CartPage(uid: uid);
            },
          ),
        ),
        child: const Icon(Icons.shopping_bag),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Image.asset(
                    'assets/design/images/iconly-bold-location.png',
                  ),
                ),
                FutureBuilder<UserModel?>(
                  future: UserModel.getUserFromFirestore(widget.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text(
                          "Location Unknown",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else {
                      return StreamBuilder<UserModel?>(
                        stream: _userStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            UserModel? user = snapshot.data;
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 1),
                                  Text(
                                    user?.location ?? "N/A",
                                    style: SafeGoogleFont(
                                      'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      height: 1.1725,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    }
                  },
                ),
                SizedBox(
                  width: 13,
                  height: 20,
                  child: Image.asset(
                    'assets/design/images/iconly-light-arrow-down-2-pcZ.png',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4.69, 4.69, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 204,
                    ),
                    child: Text(
                      ' Order Your Food        \n Fast And Free',
                      style: SafeGoogleFont(
                        'Roboto',
                        fontSize: 27,
                        fontWeight: FontWeight.w500,
                        height: 1.1725,
                      ),
                    ),
                  ),
                ),
                const Stack(
                  children: [
                    SizedBox(
                      width: 190.98,
                      height: 70.70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/design/images/delivery-1.png'),
                            fit: BoxFit.contain, // Adjust the fit as needed
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 15),
            child: Text(
              ' Categories',
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.1725,
              ),
            ),
          ),
          Container(
            height: 30,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 216, 127, 44),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '🍔 Burger',
                style: SafeGoogleFont(
                  'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.1725,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(),
          ),
          Expanded(
            child: Consumer<CartModel>(
              builder: (context, value, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  physics: const ScrollPhysics(),
                  itemCount: value.shopItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.2,
                  ),
                  itemBuilder: (context, index) {
                    return GroceryItemTile(
                      itemName: value.shopItems[index][0],
                      itemPrice: value.shopItems[index][1],
                      imagePath: value.shopItems[index][2],
                      color: value.shopItems[index][3],
                      description: value.shopItems[index][4],
                      qty: ValueNotifier<int>(value.shopItems[index][5]),
                      onPressed: () =>
                          Provider.of<CartModel>(context, listen: false)
                              .addItemToCart(index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
