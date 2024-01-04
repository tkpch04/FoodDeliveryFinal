import 'package:food_delivery_apps/components/ordered_item.dart';
import 'package:food_delivery_apps/model/cart_model.dart';

class OrderManager {
  static List<OrderedItem> _orderedItems = [];
  static double _totalPrice = 0;
  static CartModel? _cartModel;

  static void startOrder(
      List<OrderedItem> items, double totalPrice, CartModel cartModel) {
    _orderedItems = items;
    _totalPrice = totalPrice;
    _cartModel = cartModel;
  }

  static List<OrderedItem> get orderedItems => _orderedItems;
  static double get totalPrice => _totalPrice;
  static CartModel? get cartModel => _cartModel;

  static void clearOrder() {
    _orderedItems = [];
    _totalPrice = 0;
    _cartModel = null;
  }

  static Future<void> processOrder(List<OrderedItem> orderedItems) async {
    print("Processing Order:");
    for (var item in _orderedItems) {
      print("${item.itemName} x ${item.quantity}");
    }
  }
}
