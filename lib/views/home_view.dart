// lib/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../controllers/bottom_nav_conttroller.dart';
import '../widgets/custom_app_bar.dart';

// استيراد الصفحات الفرعية
import 'home_page.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class HomeView extends GetView<BottomNavConttroller> {
  final List<Widget> pages = [
    HomePage(),
    CategoriesPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;
      return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white,
          color: Colors.black,
          height: 55,
          top: -20,
          curveSize: 80,
          items: [
            TabItem(
              icon: Image.asset("assets/icons/img_15.png", width: 20),
              activeIcon: Image.asset("assets/icons/img_15.png", width: 10),
              title: "الرئيسية",
            ),
            TabItem(
              icon: Image.asset("assets/icons/img_16.png", width: 20),
              activeIcon: Image.asset("assets/icons/img_16.png", width: 10),
              title: "الاقسام",
            ),
            TabItem(
              icon: Image.asset("assets/icons/img_13.png", width: 20),
              activeIcon: Image.asset("assets/icons/img_13.png", width: 10),
              title: "السلة",
            ),
            TabItem(
              icon: Image.asset("assets/icons/img_14.png", width: 20),
              activeIcon: Image.asset("assets/icons/img_14.png", width: 10),
              title: "ملف",
            ),
          ],
          initialActiveIndex: currentIndex,
          onTap: controller.changePage,
        ),
      );
    });
  }
}
