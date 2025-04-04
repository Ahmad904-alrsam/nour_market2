import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nour_market2/controllers/fav_product_controller.dart';
import 'package:nour_market2/controllers/search_controller.dart';
import 'package:nour_market2/controllers/home_controller.dart';
import 'package:nour_market2/controllers/cart_controller.dart';
import 'package:nour_market2/models/Recommended.dart';
import 'package:nour_market2/views/product_detailPage.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchControllerApi searchController = Get.put(SearchControllerApi());
  final HomeController homeController = Get.find<HomeController>();
  final CartController cartController = Get.find<CartController>();
  final TextEditingController searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // متغير لتخزين التصنيف المختار (الـ mainCategoryId)
  final RxString selectedCategoryId = ''.obs;

  @override
  void initState() {
    super.initState();
    // مستمع التمرير لتحميل المزيد من النتائج عند اقتراب المستخدم من نهاية القائمة
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !searchController.isMoreLoading.value) {
        searchController.loadMoreProducts(
          searchTextController.text,
          mainCategoryId: selectedCategoryId.value.isEmpty
              ? null
              : selectedCategoryId.value,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('بحث عن المنتجات'),
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: searchTextController,
                onSubmitted: (value) {
                  // عند تقديم النص يتم البحث باستخدام النص والتصنيف المختار (إن وجد)
                  searchController.searchProducts(
                    value,
                    mainCategoryId: selectedCategoryId.value.isEmpty
                        ? null
                        : selectedCategoryId.value,
                  );
                },
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  hintText: "هل تبحث عن شيء...",
                  hintStyle:
                  const TextStyle(color: Colors.grey, fontSize: 12),
                  border: InputBorder.none,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  // زر الفلترة يمكن تعديله لعرض نافذة خيارات مثلاً
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: Colors.orange,
                      size: 20,
                    ),
                    onPressed: () {
                      // يمكنك إضافة منطق لعرض خيارات الفلترة
                    },
                  ),
                ),
              ),
            ),
          ),
          // شريط التصنيفات الرئيسية (أفقي) من HomeController
          _buildCategorySelector(context),
          // عرض نتائج البحث مع دعم تحميل المزيد
          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (searchController.searchResults.isEmpty) {
                return const Center(child: Text("لا توجد منتجات."));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: searchController.searchResults.length +
                    (searchController.isMoreLoading.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < searchController.searchResults.length) {
                    final product = searchController.searchResults[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          Get.to(() =>
                              ProductDetailPage(productId: product.id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              // الصورة على اليسار
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.image ?? "",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.error,
                                            color: Colors.red),
                                      ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              // معلومات المنتج بالوسط
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'السعر: ${product.price}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87),
                                    ),
                                    if (product.isDiscount)
                                      Text(
                                        'السعر المخفض: ${product
                                            .discountPrice}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent),
                                      ),
                                    Text(
                                      'النوع: ${product.type}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              // أزرار المفضلة والسلة على اليمين
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GetBuilder<FavProductController>(
                                    builder: (favController) {
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(
                                          product.isFavorite == 1
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: product.isFavorite == 1
                                              ? Colors.red
                                              : Colors.grey[600],
                                          size: 16.w,
                                        ),
                                        onPressed: () =>
                                            favController.toggleFavorite(
                                                product),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      cartController.addProduct(product);
                                      Get.snackbar(
                                        'تمت الإضافة',
                                        'تم إضافة المنتج إلى السلة',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.black87,
                                        colorText: Colors.white,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // مؤشر تحميل المزيد
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Obx(() {
      if (homeController.mainCategories.isEmpty) {
        return const SizedBox();
      }
      return Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeController.mainCategories.length,
          itemBuilder: (context, index) {
            final category = homeController.mainCategories[index];
            // لف كل عنصر داخل Obx لضمان تحديثه فور تغير المتغير
            return Obx(() {
              final bool isSelected =
                  selectedCategoryId.value == category.id.toString();
              return GestureDetector(
                onTap: () {
                  // عند الضغط يتم تعيين التصنيف المختار
                  selectedCategoryId.value = category.id.toString();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    // تغيير لون الخلفية والحدود في حال كان العنصر مختارًا
                    color: isSelected ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: isSelected
                            ? Colors.orange
                            : Colors.grey.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }
}
