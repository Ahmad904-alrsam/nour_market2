class BannerModel {
  final int id;
  final String image;
  final String type;
  final String value;
  final int isActive; // إذا كان الـ API يستخدم is_active أو isActive

  BannerModel({
    required this.id,
    required this.image,
    required this.type,
    required this.value,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      image: _parseImageUrl(json['image']),
      type: json['type'] ?? '',
      value: json['value'] ?? '',
      isActive: json['is_active'] ?? 0, // استخدام snake_case كما في الـ API
    );
  }

  static String _parseImageUrl(dynamic image) {
    const String baseUrl = 'https://nour-market.site/';
    if (image is String) {
      return image.startsWith('http') ? image : baseUrl + image;
    }
    return '$baseUrl/default_banner.jpg';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'type': type,
      'value': value,
      'is_active': isActive,
    };
  }
}
