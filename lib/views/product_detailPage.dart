import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nour_market2/models/Recommended.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nour_market2/models/product_model.dart';
import '../controllers/bottom_nav_conttroller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/fav_product_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/productdetail_controller.dart';
import '../controllers/products_controller.dart';
import '../widgets/productunitconversionwidget.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  final ProductDetailController controller = Get.put(ProductDetailController());
  final HomeController homeController = Get.find<HomeController>();
  final CartController cartController = Get.find<CartController>();

  // متغيرات لتخزين الوزن وسعر الكمية من الإدخال
  final RxDouble userWeight = 0.0.obs;
  final RxDouble userUnitPrice = 0.0.obs;

  // إضافة TextEditingController لحقل الملاحظات
  final TextEditingController notesController = TextEditingController();

  ProductDetailPage({Key? key, required this.productId}) : super(key: key) {
    controller.fetchProductDetails(productId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerSkeleton();
          }
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }
          if (controller.product.value == null) {
            return const Center(child: Text('لا يوجد بيانات للمنتج'));
          }

          final product = controller.product.value!;
          return _buildProductContent(context, product);
        }),
      ),
    );
  }

  Widget _buildProductContent(BuildContext context, Product product) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج مع حواف دائرية وتأثير ظل
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: product.image ?? 'https://via.placeholder.com/300',
                width: MediaQuery.of(context).size.width * 0.8,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildImageShimmer(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 25.h),

          // عنوان المنتج بتنسيق أنيق
          Text(
            product.name,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 15.h),

          // قسم السعر والوحدة
          _buildPriceSection(context, product),
          const SizedBox(height: 25),

          // الخيارات البديلة
          _buildAlternativeOptions(),
          const SizedBox(height: 25),

          // حقل الملاحظات
          _buildNotesField(),
          const SizedBox(height: 30),

          // التحكم بالكمية والإضافة للسلة
          _buildBottomControls(context, product),
          const SizedBox(height: 25),

          // قسم "قد يعجبك أيضا" مع 15 منتج عشوائي
          _buildRelatedProductsSection(product),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context, Product product) {
    return Column(
      children: [
        // ودجت تحويل الوحدة (الوزن وسعر الكمية)
        ProductUnitConversionWidget(
          product: product,
          onWeightChanged: (weight) {
            userWeight.value = weight;
          },
          onPriceChanged: (price) {
            userUnitPrice.value = price;
          },
        ),
        SizedBox(height: 15.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: product.isDiscount == 1
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض السعر المخفض
              Obx(() => Text(
                '${product.discountPrice} ليرة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )),
              // عرض السعر الأصلي مع خط يشطبه
              Text(
                '${product.price} ليرة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.sp,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          )
              : Obx(() => Text(
            '${controller.currentPrice.value} ليرة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        SizedBox(height: 20.h),
        // حساب المجموع باستخدام السعر المُدخل أو السعر الافتراضي للمنتج

      ],
    );
  }

  Widget _buildAlternativeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'في حال عدم توفر هذا العنصر',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: [
            _buildChoiceChip('استبداله بمنتج آخر'),
            _buildChoiceChip('المتابعة بدونه'),
            _buildChoiceChip('تواصل معي'),
            _buildChoiceChip('إلغاء الطلب'),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label) {
    return Obx(() {
      final isSelected = controller.selectedAlternativeOption.value == label;
      return ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12.sp,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        selected: isSelected,
        selectedColor: Colors.teal,
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        onSelected: (selected) {
          controller.selectedAlternativeOption.value = selected ? label : "";
        },
      );
    });
  }


  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملاحظاتك',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.teal, width: 1),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: TextField(
            controller: notesController,
            onChanged: (value) {
              controller.userNote.value = value;
            },
            maxLines: 3,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12.w),
              hintText: 'النكهة المطلوبة ... او اي شي',
              hintStyle: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.grey,
                fontSize: 14.sp,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(BuildContext context, Product product) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المجموع',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            Obx(() {
              final double unitPrice = userUnitPrice.value > 0
                  ? userUnitPrice.value
                  : double.tryParse(product.price.toString()) ?? 0;
              return Text(
                '${(unitPrice * controller.quantity.value)} ليرة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              );
            }),
          ],
        ),
        SizedBox(height: 20.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ElevatedButton(
              onPressed: () {
                cartController.addProduct(
                  product,
                  initialQuantity: controller.quantity.value,
                  note: controller.userNote.value,
                  alternativeOption: controller.selectedAlternativeOption.value,
                  weight: userWeight.value,
                  userQuantityPrice: userUnitPrice.value,
                );
                Get.find<BottomNavController>().cartItemCount.value++;

                Get.snackbar(
                  'تمت الإضافة',
                  'تم إضافة المنتج إلى السلة',
                  backgroundColor: Colors.teal[100],
                  colorText: Colors.teal[900],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w), // تقليل الحشو الأفقي
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: FittedBox( // تغليف المحتوى لتصغير الحجم تلقائيًا إن لزم الأمر
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_checkout_rounded, size: 22.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'أضف إلى السلة',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 6.w), // تقليل المسافة بين الزرين
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.teal, width: 1),
              ),
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w), // تقليل الحشو الأفقي
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.teal),
                    onPressed: controller.decrement,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(width: 4.w),
                  Obx(() => Text(
                    controller.quantity.value.toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  )),
                  SizedBox(width: 4.w),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.teal),
                    onPressed: controller.increment,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

          ],
        ),
      ],
    );
  }




  Widget _buildRelatedProductsSection(Product product) {
    // إنشاء instance جديد من ProductsController باستخدام subCategoryId للمنتج الحالي
    final ProductsController productsController = Get.put(
      ProductsController(subcategoryId: product.subCategoryId),
      tag: 'related_${product.subCategoryId}',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'قد يعجبك أيضًا',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: Obx(() {
            if (productsController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (productsController.products.isEmpty) {
              return const Center(child: Text('لا توجد منتجات'));
            }
            // اختيار 15 منتج عشوائي
            final List<Product> randomProducts = List<Product>.from(productsController.products);
            randomProducts.shuffle();
            final List<Product> displayProducts = randomProducts.take(15).toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: displayProducts.length,
              itemBuilder: (context, index) {
                final prod = displayProducts[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () => Get.to(() => ProductDetailPage(productId: prod.id)),
                  child: Container(
                    width: 135.w,
                    margin: EdgeInsets.only(right: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // استخدام Stack لعرض الصورة مع badge الخصم إن وجد
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: CachedNetworkImage(
                                imageUrl: 'https://nour-market.site${prod.image}',
                                fit: BoxFit.contain,
                                height: 100.h,
                                width: double.infinity,
                                placeholder: (context, url) => buildImagePlaceholder(),
                                errorWidget: (context, url, error) => buildImageError(),
                              ),
                            ),
                            if (prod.isDiscount == 1)
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
                        // اسم المنتج
                        Text(
                          prod.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                        ),
                        // عرض السعر والـ Favorite Icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            prod.isDiscount == 1
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${prod.discountPrice} ل.س',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  '${prod.price} ل.س',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            )
                                : Text(
                              '${prod.price} ل.س',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue[800],
                              ),
                            ),
                            GetBuilder<FavProductController>(
                              builder: (controller) {
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    prod.isFavorite == 1 ? Icons.favorite : Icons.favorite_border,
                                    color: prod.isFavorite == 1 ? Colors.red : Colors.grey[600],
                                    size: 16.w,
                                  ),
                                  onPressed: () => controller.toggleFavorite(prod),
                                );
                              },
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
      ],
    );
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


  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 250,
        color: Colors.white,
      ),
    );
  }

  Widget _buildShimmerSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // هيكل الصورة
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.white,
            ),
            const SizedBox(height: 25),
            // هيكل العنوان
            Container(
              width: 200,
              height: 28,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            // هيكل السعر
            Container(
              width: 150,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 25),
            // هيكل الوحدة
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 25),
            // هيكل الخيارات
            Column(
              children: List.generate(
                4,
                    (index) => const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // هيكل الملاحظات
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 30),
            // هيكل الأزرار
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
