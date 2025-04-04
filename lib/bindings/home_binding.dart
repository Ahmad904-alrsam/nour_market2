// lib/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:nour_market2/controllers/banner_controller.dart';
import 'package:nour_market2/controllers/cart_controller.dart';
import 'package:nour_market2/controllers/companis_controller.dart';
import 'package:nour_market2/controllers/fav_product_controller.dart';
import 'package:nour_market2/controllers/products_controller.dart';
import 'package:nour_market2/controllers/profile_controller.dart';
import '../controllers/bottom_nav_conttroller.dart';
import '../controllers/faq_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/register_controller.dart';
import '../controllers/user_controller.dart';
import '../services/category_provider.dart';
import '../services/register_provider.dart';

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    // الخدمات الأساسية (تهيئة فورية)
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<FavProductController>(FavProductController(),permanent: true);


    // المتحكمات (تهيئة عند الحاجة)
    Get.lazyPut<BannerController>(() => BannerController());
    Get.lazyPut<AuthService>(() => AuthService());





    Get.put<BottomNavController>( BottomNavController());
    Get.put<NotificationController>( NotificationController());
    Get.put<FaqController>( FaqController());




    Get.put<RegisterController>( RegisterController());
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<UserController>( UserController());
    Get.put<CompanisController>(CompanisController());



  }
}