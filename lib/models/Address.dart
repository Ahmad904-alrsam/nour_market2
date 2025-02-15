class Address {
  final int id;
  final String street;
  final String city;

  Address({
    required this.id,
    required this.street,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
    };
  }
}
