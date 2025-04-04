


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

  const ProductCard({Key? key, required this.item}) : super(key: key);

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: 'https://nour-market.site${item.image}',
                fit: BoxFit.contain, // عرض الصورة بالكامل دون قص
                height: 100.h,
                // يمكنك إزالة خاصية height أو تحديد قيمة تتناسب مع التصميم
                placeholder: (context, url) => buildImagePlaceholder(),
                errorWidget: (context, url, error) => buildImageError(),
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              item.name ?? '',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.price} ل.س',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue[800],
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
