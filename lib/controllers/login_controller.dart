import 'package:get/get.dart';
import '../services/login_provider.dart';

class LoginController extends GetxController {
  final LoginProvider loginProvider = LoginProvider();

  // متغيرات لمراقبة حالة التحميل والرسائل
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// دالة تسجيل الدخول عبر استدعاء loginUser في الـ Provider
  Future<void> login(String name, String phone) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await loginProvider.loginUser({
      'name': name,
      'phone': phone,
    });

    if (response.statusCode == 200) {
      // تسجيل الدخول ناجح؛ يمكنك تخزين بيانات المستخدم أو التوكن هنا
      // مثال: final token = response.body['token'];
      Get.offAllNamed('/home'); // الانتقال للصفحة الرئيسية
    } else {
      errorMessage.value = response.body['message'] ?? 'حدث خطأ أثناء تسجيل الدخول';
    }
    isLoading.value = false;
  }
}
