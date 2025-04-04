import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nour_market2/widgets/product_Card_rec.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';
import '../controllers/settings_controller.dart';
import '../models/storeSettings.dart';

class RecommendedSection extends StatelessWidget {
  final String title;
  const RecommendedSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          _buildSectionHeader(controller),
          SizedBox(height: 23.h),
          Obx(() => _buildContent(controller)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(HomeController controller) {
    return Obx(
          () => controller.isLoading.value
          ? _buildShimmerHeader()
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.blue[800],
                fontFamily: 'Cairo',
              ),
            ),
            Icon(Icons.local_offer_rounded, size: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeController controller) {
    if (controller.isLoading.value) return _buildLoadingList();
    if (controller.recommendedProducts.isEmpty) return _buildEmptyState();
    return _buildProductList(controller);
  }

  Widget _buildProductList(HomeController controller) {
    final itemCount = controller.hasMoreRecommendedProducts
        ? controller.recommendedProducts.length + 1
        : controller.recommendedProducts.length;

    return SizedBox(
      height: 180.h,
      child: ListView.builder(
        addAutomaticKeepAlives: true,
        itemExtent: 150.w, // تحديد حجم ثابت للعناصر
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (_, index) {
          if (index < controller.recommendedProducts.length) {
            return ProductCard(
              item: controller.recommendedProducts[index],
              isShowPrice: controller.isShowPrice.value, // ✅ القيمة المحدثة
            );
          }

          // عرض مؤشر التحميل فقط إذا كان هناك المزيد من البيانات
          if (controller.isLoadingMore.value) {
            return _buildLoadingItem(isLast: true);
          } else {
            return SizedBox.shrink(); // إخفاء العنصر إذا لم يكن هناك المزيد
          }
        },
      ),
    );
  }

  Widget _buildLoadingList() {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingItem({bool isLast = false}) {
    return SizedBox(
      width: 140.w,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 120.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_objects_outlined,
              size: 40.w,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 8.h),
            Text(
              "لا توجد توصيات متاحة حالياً",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(color: Colors.white),
      ),
    );
  }

  Widget buildImageError() {
    return Center(
      child: Icon(
        Icons.error_outline_rounded,
        size: 40.w,
        color: Colors.grey.shade400,
      ),
    );
  }
}