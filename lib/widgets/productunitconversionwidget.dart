import 'package:flutter/material.dart';
import 'package:get/get.dart';import '../controllers/priceweight_controller.dart';

import '../models/Product.dart';

class ProductUnitConversionWidget extends StatelessWidget {
  final Product product; // يجب أن يحتوي على حقل unit وسعر المنتج (price)

  const ProductUnitConversionWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // إذا كانت الوحدة ليست "فرط"، يتم عرض النص فقط:
    if (product.unit != "فرط") {
      return Center(
        child: Text(
          product.unit,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    // إذا كانت الوحدة "فرط"، نقوم بإنشاء Controller للتحويل
    // نستخدم tag لضمان تمييز هذا الـ controller في حال ظهور أكثر من منتج بنفس الصفحة
    final PriceWeightController conversionController = Get.put(
      PriceWeightController(unitPrice: product.price),
      tag: product.id.toString(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: conversionController.priceController,
          decoration: const InputDecoration(
            labelText: "أدخل السعر",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: conversionController.onPriceChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: conversionController.weightController,
          decoration: const InputDecoration(
            labelText: "أدخل الوزن",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: conversionController.onWeightChanged,
        ),
      ],
    );
  }
}
