import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _storage = const FlutterSecureStorage();
  final isLoggedIn = false.obs;

  Future<void> init() async {
    final token = await _storage.read(key: 'jwt_token');
    isLoggedIn.value = token != null;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
    isLoggedIn.value = true;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
    isLoggedIn.value = false;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}