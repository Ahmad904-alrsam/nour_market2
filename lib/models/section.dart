import 'package:nour_market2/models/banner.dart';

class Section {
  final int id;
  final String name;
  final String type;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> products;
  final List<BannerModel> banners;

  Section({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
    required this.banners,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      isActive: json['is_active'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      products: json['products'] as List<dynamic>,
      banners: (json['banners'] as List)
          .map((bannerJson) => BannerModel.fromJson(bannerJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'products': products,
      'banners': banners.map((banner) => banner.toJson()).toList(),
    };
  }
}
