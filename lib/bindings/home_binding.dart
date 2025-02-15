// lib/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:nour_market2/controllers/banner_controller.dart';
import 'package:nour_market2/controllers/bottom_nav_conttroller.dart';
import 'package:nour_market2/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // نقوم بحقن HomeController عند الحاجة (lazyPut: يُنشئه عند أول استخدام)
    Get.lazyPut<BannerController>(() => BannerController());
    Get.lazyPut<BottomNavConttroller>(() => BottomNavConttroller());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BannerController>(() => BannerController());
    Get.lazyPut<ProfileController>(() => ProfileController());





  }
}
