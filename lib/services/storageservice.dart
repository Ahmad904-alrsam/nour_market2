import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final _storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  static Future<void> setUserId(String userId) async {
    await _storage.write(key: 'userId', value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  static Future<void> setToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'userId');
  }
}
