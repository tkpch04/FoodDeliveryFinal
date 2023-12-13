import 'package:flutter/material.dart';

//import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/grocery_item_tile.dart';
import '../model/cart_model.dart';
import 'cart_page.dart';
import 'package:food_delivery_apps/utils/utils.dart';
import 'package:food_delivery_apps/model/user_model.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserModel?> _userFuture;
  @override
  void initState() {
    super.initState();
    _userFuture = UserModel.getUserFromFirestore(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CartPage();
            },
          ),
        ),
        child: const Icon(Icons.shopping_bag),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 11.5, 2),
                width: 17,
                height: 20,
                child: Image.asset(
                    'assets/design/images/iconly-bold-location.png'),
              ),
              FutureBuilder<UserModel?>(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: Text(
                        "Lokasi Tidak Diketahui",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1),
                          Text(
                            '${snapshot.data!.lokasi ?? "N/A"}',
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.1725,
                              color: Color(0xff0c0c0c),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(3, 0, 11.5, 0),
                width: 17,
                height: 20,
                child: Image.asset(
                    'assets/design/images/iconly-light-arrow-down-2-pcZ.png'),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 4.69, 4.69, 0),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 26.13, 0),
                    constraints: BoxConstraints(
                      maxWidth: 204,
                    ),
                    child: Text(
                      ' Order Your Food\n Fast And Free',
                      style: SafeGoogleFont('Roboto',
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          height: 1.1725,
                          color: Color(0xff0c0c0c)),
                    ),
                  ),
                ),
                Container(
                  width: 92.19,
                  height: 90.63,
                  child: Image.asset(
                    'assets/design/images/delivery-1.png',
                    width: 7,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 50),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Text(
              '   Categories',
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.1725,
                color: Color.fromARGB(255, 100, 68, 68),
              ),
            ),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xffff9431),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '🍔 Burger',
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(),
          ),

          // recent orders -> show last 3
          Expanded(
            child: Consumer<CartModel>(
              builder: (context, value, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  //physics: const NeverScrollableScrollPhysics(),
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
                      //onPressed: () {},
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
