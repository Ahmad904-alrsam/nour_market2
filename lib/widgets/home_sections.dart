import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';
import '../views/productpage_Companies.dart';
import 'companyList.dart';

class HomeSections extends StatelessWidget {
  final String title;
  final HomeController _homeController = Get.find<HomeController>();

  HomeSections({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context), // تمرير الـ context هنا
        SizedBox(height: 12.h),
        Obx(() => _buildContent()),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) { // استلام الـ context كمعامل
    return Obx(() => Container(
      width: double.infinity,
      height: 40.h,
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color:Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: _homeController.isLoading.value
          ? _ShimmerLoader(width: 120.w, height: 24.h)
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
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
            Icon(Icons.local_offer_outlined, size: 20.w),
          ],
        ),
      ),
    ));
  }


  Widget _buildContent() {
    if (_homeController.isLoading.value) return _buildShimmerLoader();
    if (_homeController.companies.isEmpty) return _buildEmptyState();
    return CompanyList(companies: _homeController.companies);
  }

  Widget _buildShimmerLoader() {
    return SizedBox(
      height: 120.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 8.w),
        itemCount: 5,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) => _ShimmerCompanyItem(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 80.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: 32.w,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 8.h),
            Text(
              "لا توجد شركات متاحة",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCompanyItem extends StatelessWidget {
  const _ShimmerCompanyItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 8.w),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              height: 12.h,
              width: 50.w,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  const _ShimmerLoader({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
