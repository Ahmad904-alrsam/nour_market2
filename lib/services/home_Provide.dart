import 'package:get/get.dart';

class ApiService extends GetConnect {
  Future<Response> fetchCategories() {
    return get('https://api.example.com/categories');
  }

  Future<Response> fetchCompanies() {
    return get('https://api.example.com/companies');
  }

  Future<Response> fetchRecommended() {
    return get('https://api.example.com/recommended');
  }
}