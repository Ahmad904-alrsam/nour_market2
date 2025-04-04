import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nour_market2/views/subcategories_page.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';
import '../models/maincateagory.dart';
import '../routes/app_pages.dart';
import '../widgets/buildBannerNew.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({Key? key}) : super(key: key);
  final HomeController controller = Get.find<HomeController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // نستمع لتغيرات السحب لتفعيل تحميل المزيد
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoading.value &&
          controller.mainCategoriesNextPageUrl != null) {
        controller.loadMoreMainCategories();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBarNew(title: "تصنيفات المنتجات"),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        color: Colors.green,
        displacement: 40,
        edgeOffset: 20,
        child: Obx(() {
          if (controller.isLoading.value && controller.mainCategories.isEmpty)
            return _buildSkeletonLoader();
          if (controller.mainCategories.isEmpty) return _buildEmptyState();

          // إذا كان هناك المزيد من البيانات نضيف عنصر مؤشر التحميل
          final itemCount = controller.mainCategories.length +
              (controller.mainCategoriesNextPageUrl != null ? 1 : 0);

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: GridView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                if (index < controller.mainCategories.length) {
                  final category = controller.mainCategories[index];
                  return _CategoryCard(category: category);
                } else {
                  // العنصر الأخير: مؤشر تحميل
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) => _ShimmerCategoryCard(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 100.w, color: Colors.grey.shade300),
          SizedBox(height: 24.h),
          Text(
            "لا توجد تصنيفات متاحة",
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey.shade600,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "سيتم تحديث الأقسام قريباً",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade400,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final MainCategory category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20.r),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () => Get.to(
              () => SubCategoriesPage(),
          arguments: {
            'subcategoryId': category.id,
            'subcategoryName': category.name,
          },
          preventDuplicates: false,
        ),
        splashColor: Colors.green.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Column(
          children: [
            // الصورة
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Hero(
                  tag: 'category-image-${category.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: _buildImage(),
                  ),
                ),
              ),
            ),
            // الاسم
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: Colors.grey.shade800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() => CachedNetworkImage(
    imageUrl: category.image ?? '',
    fit: BoxFit.cover,
    width: double.infinity,
    placeholder: (_, __) => Container(
      color: Colors.grey.shade100,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.green.shade300,
        ),
      ),
    ),
    errorWidget: (_, __, ___) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image_rounded, size: 40.sp, color: Colors.grey.shade300),
        SizedBox(height: 8.h),
        Text(
          'تعذر تحميل الصورة',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    ),
  );
}

class _ShimmerCategoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                height: 14.h,
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
