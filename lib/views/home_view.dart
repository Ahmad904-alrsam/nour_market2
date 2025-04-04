// lib/views/home_view.dart
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nour_market2/controllers/user_controller.dart';
import 'package:nour_market2/views/favorite_view.dart';

import '../controllers/bottom_nav_conttroller.dart';
import 'home_page.dart';
import 'categories_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';


class HomeView extends GetView<BottomNavController> {
  final List<Widget> pages = [
    HomePage(),
    CategoriesPage(),
    CartPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;
      return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: _buildBottomNavBar(context, currentIndex),
      );
    });
  }

  ConvexAppBar _buildBottomNavBar(BuildContext context, int currentIndex) {
    return ConvexAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      color: Colors.grey,
      activeColor: Theme
          .of(context)
          .primaryColor,
      height: 60.h,
      curveSize: 100,
      top: -15,
      style: TabStyle.react,
      items: [
        _buildTabItem(
          iconPath: "assets/icons/img_15.png",
          title: "الرئيسية",
        ),
        _buildTabItem(
          iconPath: "assets/icons/img_16.png",
          title: "الاقسام",
        ),
        _buildCartTabItem(),
        _buildTabItem(
          iconPath: "assets/icons/img_12.png",
          title: "مفضلة",
        ),
        _buildProfileTabItem(),
      ],
      initialActiveIndex: currentIndex,
      onTap: (index) {
        HapticFeedback.lightImpact();
        controller.changePage(index);
      },
    );
  }

  TabItem _buildTabItem({
    required String iconPath,
    required String title,
  }) {
    return TabItem(
      icon: Image.asset(iconPath, width: 24.w),
      activeIcon: Image.asset(iconPath, width: 24.w),
      title: title,
    );
  }

  TabItem _buildCartTabItem() {
    return TabItem(
      icon: Obx(
            () =>
            badges.Badge(
              badgeContent: Text(
                '${controller.cartItemCount.value}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
              showBadge: controller.cartItemCount.value > 0,
              position: badges.BadgePosition.topEnd(top: -10, end: -12),
              child: Image.asset(
                "assets/icons/img_13.png",
                width: 24.w,
              ),
            ),
      ),
      activeIcon: Obx(
            () =>
            badges.Badge(
              badgeContent: Text(
                '${controller.cartItemCount.value}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                ),
              ),
              showBadge: controller.cartItemCount.value > 0,
              position: badges.BadgePosition.topEnd(top: -10, end: -12),
              child: Image.asset(
                "assets/icons/img_13.png",
                width: 24.w,
              ),
            ),
      ),
      title: "السلة",
    );
  }

  TabItem _buildProfileTabItem() {
    return TabItem(
      icon: Obx(() {
        final imageUrl = userController.user.value.image;
        return CachedNetworkImage(
          imageUrl: imageUrl != null && imageUrl.isNotEmpty
              ? (imageUrl.startsWith('http')
              ? imageUrl
              : 'https://nour-market.site$imageUrl')
              : 'https://nour-market.site/assets/images/default_avatar.png',
          imageBuilder: (context, imageProvider) =>
              CircleAvatar(
                backgroundImage: imageProvider,
                radius: 20,
              ),
          placeholder: (context, url) =>
              CircleAvatar(
                child: CircularProgressIndicator(strokeWidth: 2),
                radius: 20,
              ),
          errorWidget: (context, url, error) =>
              CircleAvatar(
                backgroundImage:
                AssetImage('assets/images/default_avatar.png'),
                radius: 20,
              ),
        );
      }),
      title: "ملف",
    );
  }
}