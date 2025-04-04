// models/location.dart
class Region {
  final String name;
  final String governorateName;

  Region({required this.name, required this.governorateName});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['name'],
      governorateName: json['governorateName'],
    );
  }
}

class District {
  final String name;
  final String cost;
  final String regionName;

  District({required this.name, required this.cost, required this.regionName});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['name'],
      cost: json['cost'],
      regionName: json['regionName'],
    );
  }
}
