import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<List<dynamic>> _shopItems = const [
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
  final List<List<String>> _cartItems = [];

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  void addItemToCart(int index) {
    final List<String> itemToAdd = [
      _shopItems[index][0], // itemName
      _shopItems[index][1], // itemPrice
      _shopItems[index][2], // imagePath
      '1', // default quantity
    ];

    int existingIndex = _cartItems.indexWhere(
      (cartItem) => cartItem
          .sublist(0, 2)
          .every((element) => itemToAdd.contains(element)),
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex][3] =
          (int.parse(_cartItems[existingIndex][3]) + 1).toString();
    } else {
      _cartItems.add(itemToAdd);
    }

    notifyListeners();
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      String itemPrice = _cartItems[i][1];
      String quantity = _cartItems[i][3];

      itemPrice = itemPrice.replaceAll(',', '.');

      try {
        double price = double.parse(itemPrice);
        int qty = int.parse(quantity);

        totalPrice += price * qty;
      } catch (e) {
        print('Error parsing itemPrice or quantity: $e');
      }
    }
    return totalPrice.toStringAsFixed(3);
  }

  Map<List<String>, List<List<String>>> groupItemsByDetails() {
    Map<List<String>, List<List<String>>> groupedItems = {};

    for (List<String> cartItem in _cartItems) {
      List<String> itemDetails = cartItem.sublist(0, 2);

      if (groupedItems.containsKey(itemDetails)) {
        int existingIndex = groupedItems[itemDetails]!.indexWhere(
          (identicalItem) => identicalItem.contains(cartItem[1]),
        );

        if (existingIndex != -1) {
          groupedItems[itemDetails]![existingIndex][3] =
              (int.parse(groupedItems[itemDetails]![existingIndex][3]) + 1)
                  .toString();
        } else {
          groupedItems[itemDetails]!.add([...cartItem, '1']);
        }
      } else {
        groupedItems[itemDetails] = [cartItem];
      }
    }

    return groupedItems;
  }

  void removeItemFromCartByDetails(List<String> itemDetails) {
    int existingIndex = _cartItems.indexWhere(
      (cartItem) => cartItem
          .sublist(0, 2)
          .every((element) => itemDetails.contains(element)),
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex][3] =
          (int.parse(_cartItems[existingIndex][3]) - 1).toString();

      if (int.parse(_cartItems[existingIndex][3]) == 0) {
        _cartItems.removeAt(existingIndex);
      }
    }

    notifyListeners();
  }

  void addnumbercart(int menuId, bool isAdd) {
    int existingIndex = _cartItems.indexWhere(
      (cartItem) => cartItem
          .sublist(0, 2)
          .every((element) => _shopItems[menuId].contains(element)),
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex][3] =
          (int.parse(_cartItems[existingIndex][3]) + (isAdd ? 1 : -1))
              .toString();

      if (int.parse(_cartItems[existingIndex][3]) == 0) {
        _cartItems.removeAt(existingIndex);
      }
    } else {
      _cartItems.add([
        _shopItems[menuId][0], // itemName
        _shopItems[menuId][1], // itemPrice
        _shopItems[menuId][2], // imagePath
        (isAdd ? 1 : 0).toString(), // quantity
      ]);
    }

    notifyListeners();
  }
}
