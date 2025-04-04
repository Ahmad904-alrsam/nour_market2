import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_market2/widgets/product_Card.dart';
import '../models/product_model.dart';
import '../models/section.dart';
import 'bannerCarouselWidget.dart';

class SectionWidget extends StatelessWidget {
  final Section section;
  const SectionWidget({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (section.type == 'banners') {
      return _buildBannerSection();
    }
    // وإلا نفترض أنه قسم منتجات
    return _buildProductSection();
  }

  Widget _buildBannerSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          _buildSectionHeader(),
          SizedBox(height: 23.h),
          // استخدام BannerCarouselWidget لعرض البانرات بشكل جذاب
          BannerCarouselWidget(
            header: section.name,
            banners: section.banners,
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          _buildSectionHeader(),
          SizedBox(height: 23.h),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            section.name,
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
    );
  }

  Widget _buildContent() {
    if (section.products.isEmpty) return _buildEmptyState();
    return SizedBox(
      height: 170.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        itemCount: section.products.length,
        itemBuilder: (_, i) {
          return ProductCard(
            item: Product.fromJson(section.products[i]),
          );


        },
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
}




