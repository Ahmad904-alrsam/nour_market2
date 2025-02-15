class Product_Details {
  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final int subcategoryId;
  final String unit; // الخاصية الجديدة لتحديد الوحدة (مثال: قطعة أو فرط)


  Product_Details({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.subcategoryId,
    required this.unit, // إضافتها في المُنشئ

  });

  factory Product_Details.fromJson(Map<String, dynamic> json) {
    return Product_Details(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'عنوان غير متوفر',
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : 0.0,
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150', // صورة افتراضية
      subcategoryId: json['subcategoryId'] ?? 0,
      unit: json['unit'] as String? ?? "فرط", // إذا كانت القيمة غير موجودة، يتم استخدام القيمة الافتراضية
    );
  }
}
