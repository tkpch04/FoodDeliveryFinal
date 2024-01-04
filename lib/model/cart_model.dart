import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:food_delivery_apps/components/ordered_item.dart';

class FormatCurrency {
  static String convertToIdr(double number) {
    final formatter = NumberFormat('#,##0.000', 'id_ID');
    final formattedString = 'Rp${formatter.format(number)}';
    return formattedString.replaceAll(',', '.');
  }
}

class CartModel extends ChangeNotifier {
  final List<List<dynamic>> _shopItems = [
    [
      "Beef Burger",
      "14.000",
      "assets/images/burgerbeef.png",
      Colors.green,
      "Burger dibuat dari daging sapi asli",
      1,
    ],
    [
      "Double Beef Burger",
      "50.000",
      "assets/images/burgerdoublebeef.png",
      Colors.yellow,
      "Burger dibuat dari daging sapi asli dengan double beef",
      1,
    ],
    [
      "Chicken Burger",
      "20.000",
      "assets/images/burgerchicken.png",
      Colors.brown,
      "Burger dibuat dari daging ayam asli dengan selada dan saus",
      1,
    ],
    [
      "Cheese Burger",
      "17.000",
      "assets/images/burgercheese.png",
      Colors.blue,
      "Burger dibuat dari daging sapi asli dengan keju yang melimpah",
      1,
    ],
    [
      "Fish Burger",
      "25.000",
      "assets/images/burgerfish.png",
      Colors.red,
      "Burger dibuat dari daging ikan salmon dengan saos mayones",
      1,
    ],
    [
      "Kentang",
      "15.000",
      "assets/images/kentang.png",
      Colors.teal,
      "Kentang krispy original",
      1,
    ],
    [
      "Aqua",
      "5.000",
      "assets/images/water.png",
      Colors.orange,
      "Aqua Air Mineral Murni",
      1,
    ],
    [
      "Cola-Cola",
      "10.000",
      "assets/images/colacola.png",
      Colors.cyan,
      "Cola-Cola Seger",
      1,
    ],
  ];

  final List<List<dynamic>> _orderHistory = [];
  final List<List<dynamic>> _cartItems = [];

  List<OrderedItem> getOrderedItems() {
    List<OrderedItem> orderedItems = [];

    for (int i = 0; i < _cartItems.length; i++) {
      orderedItems.add(OrderedItem(
        itemName: _cartItems[i][0],
        itemPrice: double.parse(_cartItems[i][1]),
        quantity: _cartItems[i][5],
      ));
    }
    return orderedItems;
  }

  get cartItems => _cartItems;
  List<List<dynamic>> get orderHistory => _orderHistory;
  get shopItems => _shopItems;

  void addItemToCart(int index) {
    final item = List.from(_shopItems[index]);
    final int existingIndex = _findItemIndex(item[0]);

    if (existingIndex != -1) {
      _cartItems[existingIndex][5]++;
    } else {
      item.add(1); // Quantity is initially set to 1
      _cartItems.add(item);
    }

    notifyListeners();
  }

  void removeItemFromCart(int index) {
    _cartItems[index][5]--;

    if (_cartItems[index][5] == 0) {
      _cartItems.removeAt(index);
    }

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void clearOngoingDelivery() {
    _orderHistory.clear();
    notifyListeners();
  }

  double calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      totalPrice += double.parse(_cartItems[i][1]) * _cartItems[i][5];
    }
    return totalPrice;
  }

  String getFormattedTotal() {
    double totalPrice = calculateTotal();
    return FormatCurrency.convertToIdr(totalPrice);
  }

  void ongoingDelivery() {
    _orderHistory.addAll(List.from(_cartItems));
    print('Recorded Orders: $_orderHistory');
    clearCart();
    notifyListeners();
  }

  int _findItemIndex(String itemName) {
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i][0] == itemName) {
        return i;
      }
    }
    return -1;
  }
}
