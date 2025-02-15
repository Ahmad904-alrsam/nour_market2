class SubCategory {
  final int id;
  final String name;
  final String? imageUrl;

  SubCategory({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'] ?? null,
    );
  }
}
