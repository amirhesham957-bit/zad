class Item {
  final String id;
  final String name;
  final int quantity;
  final int minQuantity;
  final double? price;

  Item({
    required this.id,
    required this.name,
    required this.quantity,
    this.minQuantity = 1,
    this.price,
  });

  bool get isLowStock => quantity <= minQuantity;
}
