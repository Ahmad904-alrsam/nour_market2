// lib/controllers/bottom_nav_controller.dart
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxInt cartItemCount = 0.obs;
  void resetCartCount() {
    cartItemCount.value = 0;
  }
  void changePage(int index) => currentIndex.value = index;
  void updateCartCount(int count) => cartItemCount.value = count;
}