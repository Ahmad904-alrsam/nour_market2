// lib/controllers/bottom_nav_conttroller.dart
import 'package:get/get.dart';

class BottomNavConttroller extends GetxController {
  // متغير observable لحفظ الفهرس الحالي
  var currentIndex = 0.obs;

  /// دالة لتغيير الصفحة عند الضغط على زر التنقل
  void changePage(int index) {
    currentIndex.value = index;
  }
}
