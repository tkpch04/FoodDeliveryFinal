import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  // list of items on sale
  final List _shopItems = const [
    // [ itemName, itemPrice, imagePath, color, description ]
    [
      "Beef Burger",
      "14.000",
      "assets/images/burgerbeef.png",
      Colors.green,
      "Burger dibuat dari daging sapi asli",
    ],
    [
      "Double Beef Burger",
      "30.000",
      "assets/images/burgerdoublebeef.png",
      Colors.yellow,
      "Burger dibuat dari daging sapi asli dengan double beef",
    ],
    [
      "Chicken Burger",
      "20.000",
      "assets/images/burgerchicken.png",
      Colors.brown,
      "Burger dibuat dari daging ayam asli dengan selada dan saus",
    ],
    [
      "Cheese Burger",
      "17.000",
      "assets/images/burgercheese.png",
      Colors.blue,
      "Burger dibuat dari daging sapi asli dengan keju yang melimpah",
    ],
    [
      "Fish Burger",
      "25.000",
      "assets/images/burgerfish.png",
      Colors.red,
      "Burger dibuat dari daging ikan\n salmon dengan saos mayones",
    ],
    [
      "Kentang",
      "15.000",
      "assets/images/kentang.png",
      Colors.teal,
      "Kentang krispy original",
    ],
    [
      "Aqua",
      "5.000",
      "assets/images/water.png",
      Colors.orange,
      "Aqua Air Mineral Murni",
    ],
    [
      "Cola-Cola",
      "10.000",
      "assets/images/colacola.png",
      Colors.cyan,
      "Cola-Cola Seger",
    ],
  ];

  // list of cart items
  List _cartItems = [];

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  // add item to cart
  void addItemToCart(int index) {
    _cartItems.add(_shopItems[index]);
    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Untuk Clean di Cart
  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  // calculate total price
  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i][1]);
    }
    return totalPrice.toStringAsFixed(3);
  }
}
