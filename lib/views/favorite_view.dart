import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/fav_product_controller.dart';
import '../controllers/home_controller.dart';
import '../models/product_model.dart';
import '../views/product_detailPage.dart';
import '../widgets/buildBannerNew.dart';

class FavoritesPage extends StatelessWidget {
  final FavProductController favController = Get.find<FavProductController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBarNew(title: "قائمة المفضلة"),
      body: Obx(() {
        // فلترة المنتجات المفضلة من قائمة المنتجات في HomeController
        final favorites = homeController.recommendedProducts
            .where((p) => p.isFavorite == 1)
            .toList();

        if (favController.isLoading.value) {
          return _buildSkeletonLoader();
        }
        return favorites.isEmpty ? _buildEmptyState() : _buildFavoriteList(favorites);
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/fav_124.json',
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),
          Text(
            "القائمة فارغة!",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade700,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "اضغط على ♥ لإضافة منتجاتك المفضلة هنا",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade400,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteList(List<Product> favorites) {
    return RefreshIndicator(
      onRefresh: favController.refreshFavorites,
      color: Colors.green,
      backgroundColor: Colors.white,
      displacement: 30,
      edgeOffset: 20,
      child: ListView.separated(
        padding: EdgeInsets.all(12.w),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: favorites.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => _buildFavoriteItem(favorites[index]),
      ),
    );
  }

  Widget _buildFavoriteItem(Product item) {
    return Material(
      borderRadius: BorderRadius.circular(12.r),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => Get.to(() => ProductDetailPage(productId: item.id)),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(item),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductTitle(item),
                    SizedBox(height: 6.h),
                    _buildPriceRow(item),
                  ],
                ),
              ),
              _buildFavoriteButton(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(Product item) {
    return Hero(
      tag: 'product-image-${item.id}',
      child: Container(
        width: 60.w,
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: CachedNetworkImage(
            imageUrl: "https://nour-market.site${item.image}",
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: Colors.grey.shade100,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => Icon(
              Icons.shopping_bag_rounded,
              size: 24.sp,
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductTitle(Product item) {
    return Text(
      item.name,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Cairo',
        color: Colors.grey.shade800,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceRow(Product item) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            "${item.price.toDouble().toStringAsFixed(2)} ل.س",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.green.shade700,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(Product item) {
    return GetBuilder<FavProductController>(
      builder: (favCtrl) {
        bool isFav = favCtrl.isFavorite(item);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: IconButton(
            key: ValueKey(isFav),
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.redAccent : Colors.grey.shade400,
              size: 24.sp,
            ),
            onPressed: () => favCtrl.toggleFavorite(item),
            splashRadius: 20.r,
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: EdgeInsets.all(12.w),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(8.w),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: 70.w,
                      height: 10.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                width: 24.w,
                height: 24.h,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
