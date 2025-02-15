class Order {
  final String id;
  final String itemName;
  final int quantity;
  final double price;

  Order({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      itemName: json['itemName'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
    };
  }
}