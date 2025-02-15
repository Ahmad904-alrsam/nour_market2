import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/banner_controller.dart';

class BuildBanner extends StatelessWidget {
  final BannerController homeController = Get.find<BannerController>();

  @override
  Widget build(BuildContext context) {
    // تهيئة ScreenUtil إذا كانت نسختك تحتاج إلى ذلك
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Container(
      height: 200.0.h,
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0.h,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          viewportFraction: 1.0, // عرض الصورة كاملة بدون حواف جانبية
          // يمكنك إزالة enlargeCenterPage وغيرها من الخيارات الإضافية
        ),
        items: homeController.bannerImages.map((image) {
          return Image.asset(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
          );
        }).toList(),
      ),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(25),
        color: Colors.grey
      ),
    );
  }
}
