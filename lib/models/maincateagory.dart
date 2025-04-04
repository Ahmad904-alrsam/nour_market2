class MainCategory {
  final int id;
  final String name;
  final String? image;
  final bool isActive;
  final DateTime createdAt;

  MainCategory({
    required this.id,
    required this.name,
    this.image,
    required this.isActive,
    required this.createdAt,
  });

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    return MainCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'غير معروف',
      image: _parseImageUrl(json['image']),
      isActive: (json['is_active'] ?? 0) == 1,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }

  static String? _parseImageUrl(dynamic image) {
    const String baseUrl = 'https://nour-market.site/';

    if (image is String) {
      return image.startsWith('http') ? image : baseUrl + image;
    }

    if (image is Map<String, dynamic>) {
      return image['url']?.toString();
    }

    return null;
  }
}