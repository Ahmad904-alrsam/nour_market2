import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nour_market2/controllers/cart_controller.dart';
import 'package:nour_market2/models/product_model.dart';
import 'package:nour_market2/widgets/buildBannerNew.dart';

import '../controllers/bottom_nav_conttroller.dart';
import '../controllers/location_controller.dart';

// تأكد من وجود خاصية لتكلفة التوصيل في الـ LocationController مثلاً:
// RxDouble deliveryCost = 0.0.obs;

class CartPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController(), permanent: true);
  final controller = Get.find<CartController>();
  final LocationController locationController = Get.put(LocationController());

  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBarNew(title: 'السلة'),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Lottie.asset(
                        'assets/Animation - 1742014459251.json',
                        width: 250,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      "السلة فارغة",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey,fontFamily: 'Cairo'),),
                  ],
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 16.h),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          // الصورة
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: CachedNetworkImage(
                              imageUrl: (item.product.image != null &&
                                  item.product.image!.isNotEmpty)
                                  ? item.product.image!
                                  : 'https://example.com/default-image.png',
                              width: 80.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.error_outline),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // التفاصيل
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '${item.product.price} ليرة',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // التحكم بالكمية
                          Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add, size: 24.sp),
                                    onPressed: () {
                                      cartController.increaseQuantity(item.product);
                                      Get.find<BottomNavController>().cartItemCount.value++;
                                    },
                                  ),
                                  Obx(() => Text(
                                    '${item.quantity.value}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Obx(() => AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) => ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                    child: item.quantity.value > 1
                                        ? IconButton(
                                      key: const ValueKey('remove'),
                                      icon: Icon(Icons.remove, size: 24.sp),
                                      onPressed: () {
                                        cartController.decreaseQuantity(item.product);
                                        Get.find<BottomNavController>().cartItemCount.value--;
                                      },
                                    )
                                        : IconButton(
                                      key: const ValueKey('delete'),
                                      icon: Icon(
                                        Icons.delete_outline,
                                        size: 24.sp,
                                        color: Colors.red[400],
                                      ),
                                      onPressed: () {
                                        cartController.removeFromCart(item.product);
                                        Get.find<BottomNavController>().cartItemCount.value--;
                                      },
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          // المجموع والدفع ومعلومات التوصيل
          Obx(() {
            if (cartController.cartItems.isEmpty) return const SizedBox();
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // عرض المجموع الكلي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع الكلي',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${cartController.total.value.toStringAsFixed(2)} ليرة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // عرض معلومات التوصيل: المنطقة وتكلفة التوصيل
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المنطقة: ${locationController.selectedRegion.value} - ${locationController.selectedDistrict.value}',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Text(
                          'تكلفة التوصيل: ${locationController.deliveryCost.value.toStringAsFixed(2)} ليرة',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 16.h),
                  // زر إرسال الطلب
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: cartController.cartItems.isEmpty
                          ? null
                          : () async {
                        // تنسيق المنطقة بدمج اسم المنطقة والحي
                        final String area =
                            '${locationController.selectedRegion.value} - ${locationController.selectedDistrict.value}';
                        final double cost = locationController.deliveryCost.value;
                        await cartController.submitOrder(
                          deliveryArea: area,
                          deliveryCost: cost,
                          totalPrice: cartController.total.value,
                          whatsappPhoneNumber: '+963981541996',
                        );
                        Get.find<BottomNavController>().resetCartCount();
                      },

                      child:const Text(
                        'إرسال الطلب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
