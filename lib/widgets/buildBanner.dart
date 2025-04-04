import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/banner_controller.dart';
import '../controllers/home_controller.dart';
import '../routes/app_pages.dart';
import '../views/subcategories_page.dart';

class BuildBanner extends StatelessWidget {
  final BannerController bannerController = Get.find<BannerController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // تأكد من تهيئة ScreenUtil مع التصميم المناسب
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Obx(() {
      if (homeController.isLoading.value) return _buildBannerSkeleton();
      if (homeController.banners.isEmpty) return _buildEmptyState();
      return _buildBannerContent(context);
    });
  }

  Widget _buildBannerContent(context) {
    return Column(
      children: [
        _buildSectionHeader(context),
        SizedBox(height: 12.h),
        _buildCarouselWithIndicator(),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color:Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'جديدنا',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.blue[800],
            ),
          ),
          Icon(Icons.local_offer_rounded, size: 20.w),
        ],
      ),
    );
  }

  Widget _buildCarouselWithIndicator() {
    return SizedBox(
      height: 180.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildCarousel(),
          Positioned(bottom: 12.h, child: _buildDotsIndicator()),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: CarouselSlider(
        items: homeController.banners.map((banner) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.grey[200],
            ),
            child: GestureDetector(
              onTap: () {
                if (banner.type == 'product') {
                  // نتأكد من تحويل banner.value إلى String قبل التحويل إلى int
                  Get.toNamed(
                    Routes.PRODUCT_DEATILS,
                    arguments: int.parse(banner.value.toString()),
                  );
                } else if (banner.type == 'link') {
                  _launchURL(banner.value);
                } else if (banner.type == 'category') {
                  int subcategoryId;
                  String subcategoryName;

                  // إذا كانت القيمة int، فهي تمثل المعرف فقط
                  if (banner.value is int) {
                    subcategoryId = banner.value as int;
                    subcategoryName = 'تصنيفك'; // استبدلها بالاسم المناسب إن وُجد
                  }
                  // إذا كانت القيمة String، نحاول تحويلها إلى Map عبر jsonDecode
                  else if (banner.value is String) {
                    try {
                      final Map<String, dynamic> args = jsonDecode(banner.value);
                      if (args['subcategoryId'] == null || args['subcategoryName'] == null) {
                        // في حال كانت البيانات ناقصة، نفترض أن banner.value يحتوي على رقم فقط
                        subcategoryId = int.parse(banner.value);
                        subcategoryName = 'تصنيفك';
                      } else {
                        subcategoryId = int.parse(args['subcategoryId'].toString());
                        subcategoryName = args['subcategoryName'];
                      }
                    } catch (e) {
                      // في حال فشل التحويل، نفترض أن القيمة هي رقم فقط
                      subcategoryId = int.parse(banner.value);
                      subcategoryName = 'تصنيفك';
                    }
                  } else {
                    return;
                  }

                  Get.to(
                    SubCategoriesPage(),
                    arguments: {
                      'subcategoryId': subcategoryId,
                      'subcategoryName': subcategoryName,
                    },
                  );

                }
              },
              child: CachedNetworkImage(
                imageUrl: banner.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => _buildImageSkeleton(),
                errorWidget: (_, __, ___) => Icon(
                  Icons.image_not_supported_rounded,
                  size: 32.w,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 180.h,
          autoPlay: true,
          viewportFraction: 0.95,
          enlargeCenterPage: true,
          autoPlayInterval: Duration(seconds: 5),
          onPageChanged: (i, _) => bannerController.currentPage.value = i,
        ),
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return Obx(
          () => AnimatedSmoothIndicator(
        activeIndex: bannerController.currentPage.value,
        count: homeController.banners.length,
        effect: WormEffect(
          activeDotColor: Colors.blue[800]!,
          dotColor: Colors.grey.shade300,
          dotHeight: 6.w,
          dotWidth: 6.w,
          spacing: 5.w,
          strokeWidth: 1.5.w,
        ),
      ),
    );
  }

  Widget _buildBannerSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 160.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120.h,
      alignment: Alignment.center,
      child: Text(
        "لا توجد عروض حالية",
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('خطأ', 'لا يمكن فتح الرابط');
    }
  }

  Widget _buildImageSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}
