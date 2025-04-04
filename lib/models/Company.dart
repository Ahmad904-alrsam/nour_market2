class Company {
  final int id;
  final String name;
  final String? image;
  final String? is_active;
  final String created_at;
  final String updated_at;
  // باقي الحقول...

  Company({required this.id, required this.name, this.image,this.is_active,required this.created_at,required this.updated_at});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
        image: json['image'],
        is_active: json['is_active'] != null ? json['is_active'].toString() : null,
        created_at:json['created_at'],
      updated_at: json['updated_at']
    );
  }
}
