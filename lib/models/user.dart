class User {
  final int id;
  final String name;
  final String phone; // Changed to String
  final String? image;
  final String? address;
  final String city;
  final String governorate;
  final String district;
  final String role;
  final String detailsLocation;
  final bool isFavorite; // Changed to bool
  final bool isActive; // Changed to bool
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.id = 0,
    this.name = '',
    this.phone = '',
    this.image,
    this.address,
    this.city = '',
    this.governorate = '',
    this.district = '',
    this.role = 'user',
    this.detailsLocation = '',
    this.isFavorite = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.empty() => User(
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      phone: _parsePhone(json['phone']),
      image: json['image'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      district: json['district'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      detailsLocation: json['details_location'] as String? ?? '',
      isFavorite: (json['is_favorite'] as int? ?? 0) == 1,
      isActive: (json['is_active'] as int? ?? 1) == 1,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static String _parsePhone(dynamic value) {
    if (value == null) return '';
    if (value is int) return value.toString();
    if (value is String) return value;
    return '';
  }

  static DateTime _parseDateTime(dynamic value) {
    try {
      return DateTime.parse(value as String);
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'image': image,
    'address': address,
    'city': city,
    'governorate': governorate,
    'district': district,
    'role': role,
    'details_location': detailsLocation,
    'is_favorite': isFavorite ? 1 : 0,
    'is_active': isActive ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  User copyWith({
    int? id,
    String? name,
    String? phone,
    String? image,
    String? address,
    String? city,
    String? governorate,
    String? district,
    String? role,
    String? detailsLocation,
    bool? isFavorite,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      address: address ?? this.address,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      district: district ?? this.district,
      role: role ?? this.role,
      detailsLocation: detailsLocation ?? this.detailsLocation,
      isFavorite: isFavorite ?? this.isFavorite,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User('
        'id: $id, '
        'name: $name, '
        'phone: $phone, '
        'image: $image, '
        'address: $address, '
        'city: $city, '
        'governorate: $governorate, '
        'district: $district, '
        'role: $role, '
        'detailsLocation: $detailsLocation, '
        'isFavorite: $isFavorite, '
        'isActive: $isActive, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt)';
  }
}