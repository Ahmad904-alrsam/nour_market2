import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/fav_product_controller.dart';
import '../models/product_model.dart';
import '../views/product_detailPage.dart';

class ProductCard extends StatelessWidget {
  final Product item;
  final bool isShowPrice;

  const ProductCard({
    required this.item,
    required this.isShowPrice,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: () => Get.to(() => ProductDetailPage(productId: item.id)),
      child: Container(
        width: 123.w,
        margin: EdgeInsets.only(right: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Stack (unchanged)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: 'https://nour-market.site${item.image}',
                    fit: BoxFit.contain,
                    height: 100.h,
                    placeholder: (context, url) => buildImagePlaceholder(),
                    errorWidget: (context, url, error) => buildImageError(),
                  ),
                ),
                if (item.isDiscount)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "خصم",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Modified Price Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isShowPrice)
                  item.isDiscount
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.discountPrice} ل.س',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${item.price} ل.س',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    '${item.price} ل.س',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue[800],
                    ),
                  )
                else
                  Text(
                    'السعر غير متاح حالياً',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                GetBuilder<FavProductController>(
                  builder: (controller) {
                    bool isFav = controller.isFavorite(item);
                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey[600],
                        size: 16.w,
                      ),
                      onPressed: () => controller.toggleFavorite(item),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
