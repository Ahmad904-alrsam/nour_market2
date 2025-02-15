// lib/models/company.dart
class Company {
  final String name;
  final String? logoUrl;

  Company({required this.name, this.logoUrl});

  // لتحويل البيانات من JSON (إذا احتجت ذلك)
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
    );
  }
}
