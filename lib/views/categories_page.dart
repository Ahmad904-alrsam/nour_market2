import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/widgets/custom_app_bar.dart';
import '../controllers/categories_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/buildBannerNew.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({Key? key}) : super(key: key);

  // تسجيل ال Controller باستخدام Get.put
  final CategoriesController controller = Get.put(CategoriesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(title: "الاقسام"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.categories.isEmpty) {
          return const Center(child: Text("لا توجد أقسام"));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: controller.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عمودين
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1, // بطاقة مربعة تقريباً
            ),
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return InkWell(
                onTap: () {
                  if (category.id != null && category.name != null) {
                    Get.toNamed(Routes.SUBCATEGORIES, arguments: {
                      'categoryId': category.id,
                      'categoryName': category.name,
                    });
                  } else {
                    print("⚠️ Error: Category ID or Name is null");
                  }
                },

                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // خلفية الصورة أو بديلها في حال عدم وجود صورة
                      Positioned.fill(
                        child: category.imageUrl != null
                            ? Image.network(
                          category.imageUrl!,
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
                      // تراكب شفاف لمنح مظهر أنيق ونص واضح
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
                      // اسم القسم في أسفل البطاقة
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Text(
                          category.name,
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
    );
  }
}
