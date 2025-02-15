import 'Address.dart';

class User {
  final int id;
  final String username;
  final String number;
  final List<Address> addresses;

  User({
    required this.id,
    required this.username,
    required this.number,
    required this.addresses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var addressesList = (json['addresses'] as List)
        .map((e) => Address.fromJson(e))
        .toList();
    return User(
      id: json['id'],
      username: json['username'],
      number: json['number'],
      addresses: addressesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'number': number,
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }
}
