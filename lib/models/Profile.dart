class Profile {
  final String name;
  final String phone;
  final String address;
  final String region;
  final String profileImage;

  Profile({
    required this.name,
    required this.phone,
    required this.address,
    required this.region,
    required this.profileImage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      region: json['region'],
      profileImage: json['profileImage'],
    );
  }
}
