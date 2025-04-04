class SubCategory {
  final int id;
  final String name;
  final bool isActive;
  final String? imageUrl;

  SubCategory({
    required this.id,
    required this.name,
    required this.isActive,
    this.imageUrl
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'] == 1 || json['isActive'] == true,
      imageUrl: json['imageUrl']
    );
  }
}
