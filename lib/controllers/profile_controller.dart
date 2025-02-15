import 'package:get/get.dart';
import '../models/Profile.dart';
import '../services/profile_provider.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profile = Rxn<Profile>();
  final ProfileService profileService = ProfileService();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      isLoading(true);
      profile.value = await profileService.getProfile();
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void logout() {
    // هنا تضع منطق تسجيل الخروج (مثل مسح بيانات الجلسة)
    // ثم الانتقال إلى صفحة تسجيل الدخول
    Get.offAllNamed('/login');
  }
}
