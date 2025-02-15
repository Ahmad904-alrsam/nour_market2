import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/views/product_detailPage.dart';
import '../controllers/products_controller.dart';
import '../models/Product.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استلام الـ arguments الخاصة بالتصنيف الفرعي
    final int subcategoryId = Get.arguments['subcategoryId'];
    final String subcategoryName = Get.arguments['subcategoryName'];

    // تسجيل Controller وتمرير معرف التصنيف الفرعي
    final ProductsController controller = Get.put(
      ProductsController(subcategoryId: subcategoryId),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(subcategoryName),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.products.isEmpty) {
            return const Center(child: Text("لا توجد منتجات"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: product.imageUrl != null
                      ? Image.network(
                    product.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.image, size: 50, color: Colors.grey),
                  title: Text(product.title),
                  subtitle: Text("السعر: ${product.price} \$"),
                  onTap: () {
                    Get.to(() => ProductDetailPage(productId: product.id));
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
