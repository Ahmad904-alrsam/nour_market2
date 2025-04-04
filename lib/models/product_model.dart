import 'package:get/get.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final double? discountPrice;
  final bool isDiscount; // int -> bool
  final String? image;
  final String type;
  final int? stock;
  final double weight;
  final int? companyId;
  final int mainCategoryId;
  final int subCategoryId;
  final bool isRecommended; // int -> bool
  final bool isActive; // int -> bool
  final DateTime createdAt;
  final DateTime updatedAt;
   int isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountPrice,
    required this.isDiscount,
    this.image,
    required this.type,
    this.stock,
    required this.weight,
    this.companyId,
    required this.mainCategoryId,
    required this.subCategoryId,
    required this.isRecommended,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString() == '1' || value.toString().toLowerCase() == 'true';
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value).toLocal();
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      price: _parseDouble(json['price']),
      discountPrice: json['discount_price'] != null ? _parseDouble(json['discount_price']) : null,
      isDiscount: _parseBool(json['is_discount']),
      image: json['image']?.toString(),
      type: json['type']?.toString() ?? 'general',
      stock: json['stock'] != null ? _parseInt(json['stock']) : null,
      weight: _parseDouble(json['weight']),
      companyId: json['company_id'] != null ? _parseInt(json['company_id']) : null,
      mainCategoryId: _parseInt(json['main_category_id']),
      subCategoryId: _parseInt(json['sub_category_id']),
      isRecommended: _parseBool(json['is_recommended']),
      isActive: _parseBool(json['is_active']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      isFavorite: _parseInt(json['is_favorite']),
    );
  }
}