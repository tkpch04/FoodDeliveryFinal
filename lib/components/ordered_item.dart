// ordered_item.dart
class OrderedItem {
  final String itemName;
  final double itemPrice;
  final bool isPaid;
  final int quantity;

  OrderedItem({
    required this.itemName,
    required this.itemPrice,
    this.isPaid = false,
    required this.quantity,
  });
}
