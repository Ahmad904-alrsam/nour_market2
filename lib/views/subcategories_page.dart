import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subcategories_controller.dart';

class SubCategoriesPage extends StatelessWidget {
  const SubCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استلام الـ arguments التي مررناها من صفحة الأقسام
    final int categoryId = Get.arguments['categoryId'];
    final String categoryName = Get.arguments['categoryName'];

    // تسجيل ال Controller وتمرير المعرف الخاص بالقسم
    final SubCategoriesController controller = Get.put(
      SubCategoriesController(categoryId: categoryId),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.subCategories.isEmpty) {
            return const Center(child: Text("لا توجد تصنيفات فرعية"));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: controller.subCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عمودين
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final subCategory = controller.subCategories[index];
                return InkWell(
                  onTap: () {
                    // الانتقال إلى صفحة المنتجات الخاصة بهذا التصنيف الفرعي
                    Get.toNamed('/products', arguments: {
                      'subcategoryId': subCategory.id,
                      'subcategoryName': subCategory.name,
                    });
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: subCategory.imageUrl != null
                              ? Image.network(
                            subCategory.imageUrl!,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.category,
                              size: 50,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Text(
                            subCategory.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
      ),
    );
  }
}
