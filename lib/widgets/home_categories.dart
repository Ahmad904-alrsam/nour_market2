import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';
import '../models/maincateagory.dart';
import '../routes/app_pages.dart';
import '../views/subcategories_page.dart';

class HomeCategories extends StatefulWidget {
  @override
  _HomeCategoriesState createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  final HomeController _homeController = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels != 0) {
        // وصلنا لنهاية القائمة، إذًا نحاول تحميل المزيد
        _homeController.loadMoreMainCategories();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 16.h),
        _homeController.isLoading.value ? _buildLoader() : _buildList(),
      ],
    ));
  }

  Widget _buildHeader() => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    decoration: BoxDecoration(
      color:Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('الاقسام',
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                fontFamily: 'Cairo')),
        Icon(Icons.local_offer_outlined, size: 20.w),
      ],
    ),
  );

  Widget _buildList() => SizedBox(
    height: 150.h,
    child: ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _homeController.mainCategories.length,
      itemBuilder: (_, index) => _CategoryItem(
          category: _homeController.mainCategories[index]),
    ),
  );

  Widget _buildLoader() => SizedBox(
    height: 160.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 5,
      itemBuilder: (_, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 120.w,
          margin: EdgeInsets.only(right: 16.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12.r)),
              ),
              SizedBox(height: 12.h),
              Container(
                height: 10.h,
                width: 70.w,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4.r)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _CategoryItem extends StatelessWidget {
  final MainCategory category;
  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.grey[350],
      elevation: 2,
      margin: EdgeInsets.only(right: 16.w),
      child: InkWell(
        onTap: () => Get.to(
              () => SubCategoriesPage(),
          arguments: {
            'subcategoryId': category.id,
            'subcategoryName': category.name,
          },
          preventDuplicates: false,
        ),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 120.w,
          padding: EdgeInsets.all(8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildImage()),
              SizedBox(height: 8.h),
              Text(
                category.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() => ClipRRect(
    borderRadius: BorderRadius.circular(12.r),
    child: CachedNetworkImage(
      imageUrl: category.image ?? '',
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.grey[200]),
      ),
      errorWidget: (_, __, ___) => Image.asset(
        'assets/images/photo_2025-02-04_16-43-45-removebg-preview.png',
        width: 30.sp,
      ),
    ),
  );
}
