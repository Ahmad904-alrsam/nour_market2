import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/models/product.dart';
import '../controllers/productdetail_controller.dart';
import '../widgets/productunitconversionwidget.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  final ProductDetailController controller = Get.put(ProductDetailController());

  ProductDetailPage({Key? key, required this.productId}) : super(key: key) {
    controller.fetchProductDetail(productId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else if (controller.product.value == null) {
            return const Center(child: Text('لا يوجد بيانات للمنتج'));
          } else {
            final product = controller.product.value!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة المنتج
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // اسم المنتج
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  // عرض وحدة المنتج
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "الواحدة",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 8),

// عرض نوع الوحدة
                  Center(
                    child: Text(
                      product.unit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 16),

// إذا كانت الوحدة "فرط"، عرض حقل السعر والوزن
                  if (product.unit == "فرط") ProductUnitConversionWidget(product: product),

                  const Text(
                    'في حال عدم توفر هذا العنصر',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: const [
                      Chip(label: Text('استبداله بمنتج آخر')),
                      Chip(label: Text('المتابعة بدونه')),
                      Chip(label: Text('تواصل معي')),
                      Chip(label: Text('إلغاء الطلب')),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Text('ملاحظاتك'),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'اكتب النكهة مثل...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Obx(
                        () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: controller.decrement,
                        ),
                        Text(
                          controller.quantity.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: controller.increment,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // يمكنك هنا تنفيذ منطق إضافة المنتج إلى السلة
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'أرسل إلى السلة',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
