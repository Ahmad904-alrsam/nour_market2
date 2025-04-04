class RegisterModel {
  final String name;
  final String phone;
  final String city;
  final String detailsLocation;
  final String governorate;
  final String district;



  RegisterModel({
    required this.name,
    required this.phone,
    required this.city,
    required this.detailsLocation,
    required this.governorate,
    required this.district,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'city': city,
    'detailsLocation': detailsLocation,
    'governorate':governorate,
    'district':district,
  };
}