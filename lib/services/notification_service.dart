import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService extends GetConnect {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    // تعيين baseUrl مع شرطة مائلة واحدة في النهاية
    httpClient.baseUrl = 'https://nour-market.site/api/';
    httpClient.timeout = const Duration(seconds: 30);

    // إعدادات الطلب الأساسية
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) async {
      // إضافة الرؤوس العامة
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';

      // إضافة التوكن إذا كان موجوداً
      final token = await _storage.read(key: 'jwt');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // معالجة تحديث التوكن التلقائي
    httpClient.addAuthenticator<dynamic>((request) async {
      final newToken = await _refreshToken();
      if (newToken != null) {
        request.headers['Authorization'] = 'Bearer $newToken';
      }
      return request;
    });
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return null;

      final response = await post(
        'refresh-token',
        {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.body['access_token'];
        await _storage.write(key: 'jwt', value: newToken);
        return newToken;
      } else {
        Get.snackbar('خطأ', 'فشل في تحديث التوكن: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث التوكن: $e');
    }
    return null;
  }
}
