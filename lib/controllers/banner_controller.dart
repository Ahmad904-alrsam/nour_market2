import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/banner.dart';

class BannerController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? _autoPlayTimer;

  @override
  void onInit() {
    super.onInit();
    ever(homeController.banners, _handleBannerUpdates);
    _startAutoPlay();
  }

  void _handleBannerUpdates(List<BannerModel> banners) {
    if (banners.isNotEmpty) {
      _stopAutoPlay();
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (homeController.banners.isEmpty || !pageController.hasClients) return;

      final nextPage = currentPage.value + 1;
      if (nextPage >= homeController.banners.length) {
        pageController.jumpToPage(0);
        currentPage.value = 0;
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    _stopAutoPlay();
    pageController.dispose();
    super.onClose();
  }
}