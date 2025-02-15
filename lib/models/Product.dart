class Product {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final int subcategoryId;
  final String unit; // الخاصية الجديدة

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.subcategoryId,
    required this.unit, // إضافتها في المُنشئ
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      subcategoryId: json['subcategoryId'] as int,
      unit: json['unit'] as String? ?? "فرط", // تعيين قيمة افتراضية في حال عدم وجودها
    );
  }
}
