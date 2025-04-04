class Order {
  final int id;
  final String title;
  final String status;


  Order({
    required this.id,
    required this.title,
    required this.status,

  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'طلب جديد',
      status: json['status'] as String? ?? 'غير معروف',

    );
  }
}
