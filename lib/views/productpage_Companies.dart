import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/companis_controller.dart';
import '../views/product_detailPage.dart';

class ProductPageCompanies extends StatelessWidget {
  ProductPageCompanies({Key? key}) : super(key: key);

  final CompanisController companisController = Get.find<CompanisController>();

  @override
  Widget build(BuildContext context) {
    final int companyId = Get.arguments['companyId'];
    // استدعاء دالة جلب المنتجات عند فتح الصفحة
    companisController.getProducts(companyId);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text('المنتجات'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Obx(() {
        if (companisController.isLoadingProducts.value) {
          // عرض تأثير shimmer أثناء تحميل البيانات
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: GridView.builder(
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (companisController.products.isEmpty) {
          return Center(
            child: Text(
              'لا توجد منتجات متاحة',
              style: TextStyle(fontSize: 16.sp),
            ),
          );
        }
        // عرض المنتجات بشكل شبكي GridView
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: GridView.builder(
            itemCount: companisController.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = companisController.products[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ProductDetailPage(productId: product.id));
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.r)),
                          child: product.image != null &&
                              product.image!.isNotEmpty
                              ? Image.network(
                            product.image!,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image,
                              size: 40.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'السعر: ${product.price} \$',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
