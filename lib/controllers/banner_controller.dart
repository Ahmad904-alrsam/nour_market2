import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  var selectedIndex = 0.obs;
  var currentPage = 0.obs;

  PageController pageController = PageController();
  PageController bannerPageController = PageController();

  // قائمة الصور التي ستظهر في البانر
  RxList<String> bannerImages = <String>[].obs;

  // إنشاء مثيل من GetConnect لاستخدامه في جلب البيانات
  final GetConnect _getConnect = GetConnect();

  @override
  void onInit() {
    super.onInit();
    // جلب الصور من السيرفر عند بدء تشغيل الـ Controller
    fetchBannerImages();
    // بدء تدوير البانر بشكل دوري
    startBannerRotation();
  }

  /// دالة لجلب روابط الصور من السيرفر باستخدام GetConnect
  Future<void> fetchBannerImages() async {
    // عدل رابط الـ API الخاص بك أدناه
    final String url = 'https://api.example.com/banners';

    try {
      final response = await _getConnect.get(url);
      if (response.statusCode == 200) {
        // نفترض أن الـ API تُرجع بيانات بصيغة JSON تحتوي على قائمة من الروابط
        // مثال 1: إذا كانت البيانات عبارة عن قائمة مباشرة
        if (response.body is List) {
          bannerImages.assignAll(List<String>.from(response.body));
        }
        // مثال 2: إذا كانت البيانات مغلفة داخل مفتاح مثل "banners"
        else if (response.body['banners'] != null) {
          bannerImages.assignAll(List<String>.from(response.body['banners']));
        }
      } else {
        print('فشل جلب الصور. كود الخطأ: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ أثناء جلب الصور: $e');
    }
  }

  /// دالة لتغيير الصورة في البانر كل 3 ثوانٍ
  void startBannerRotation() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (bannerPageController.hasClients && bannerImages.isNotEmpty) {
        int currentPageIndex = bannerPageController.page?.toInt() ?? 0;
        int nextPage = currentPageIndex + 1;
        if (nextPage >= bannerImages.length) {
          nextPage = 0;
        }
        bannerPageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void onBanarChanged(int index) {
    currentPage.value = index;
  }

  void onNavItemTapped(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    bannerPageController.dispose();
    super.onClose();
  }
}
