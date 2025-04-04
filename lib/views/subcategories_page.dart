import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nour_market2/views/ProductsPage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/subcategories_controller.dart';
import '../models/sub_category_model.dart';

class SubCategoriesPage extends StatelessWidget {
  const SubCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int subcategoryId = Get.arguments['subcategoryId'];
    final String subcategoryName = Get.arguments['subcategoryName'];

    final SubCategoriesController controller = Get.put(
      SubCategoriesController(
        categoryId: subcategoryId,
        subcategoryName: subcategoryName,
      ),
      tag: subcategoryId.toString(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.categoryId != subcategoryId) {
        controller.updateCategory(subcategoryId);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text(subcategoryName),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(SubCategoriesController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshSubCategories(),
      child: Obx(() {
        if (controller.isLoading.value) return _buildShimmerGrid();
        if (controller.subCategories.isEmpty) return _buildEmptyState();
        return _buildGrid(controller);
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "لا توجد تصنيفات فرعية",
        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
      ),
    );
  }

  Widget _buildGrid(SubCategoriesController controller) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          return GridView.builder(
            itemCount: controller.subCategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) =>
                _buildCategoryCard(controller.subCategories[index]),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(SubCategory subCategory) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // استدعاء صفحة المنتجات وتمرير المعطيات باستخدام Get.arguments
          Get.to(() => ProductsPage(subcategoryId: subCategory.id,subcategoryName: subCategory.name ,));
        },
        child: Stack(
          children: [
            _buildImage(subCategory),
            _buildGradientOverlay(),
            _buildCategoryName(subCategory),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(SubCategory subCategory) {
    return Positioned.fill(
      child: subCategory.imageUrl != null
          ? CachedNetworkImage(
        imageUrl: subCategory.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
            Container(
              color: Colors.grey[200],
              child: Center(child: CircularProgressIndicator()),
            ),
        errorWidget: (_, __, ___) => Icon(Icons.broken_image, size: 40.w),
      )
          : Icon(Icons.category, size: 40.w),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
            stops: [0.2, 0.6],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryName(SubCategory subCategory) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Text(
          subCategory.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }


  Widget _buildShimmerGrid() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          return GridView.builder(
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) => const _ShimmerSubCategoryCard(),
          );
        },
      ),
    );
  }
}

class _ShimmerSubCategoryCard extends StatelessWidget {
  const _ShimmerSubCategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r)),
        clipBehavior: Clip.antiAlias,
        child: Container(color: Colors.white),
      ),
    );
  }
}