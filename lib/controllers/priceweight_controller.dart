import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceWeightController extends GetxController {
  final double unitPrice;
  late TextEditingController priceController;
  late TextEditingController weightController;

  // متغير للتحكم في تحديث الحقول لتجنب التكرار المتبادل
  bool _isUpdating = false;

  PriceWeightController({required this.unitPrice});

  @override
  void onInit() {
    super.onInit();
    priceController = TextEditingController();
    weightController = TextEditingController();
  }

  @override
  void onClose() {
    priceController.dispose();
    weightController.dispose();
    super.onClose();
  }

  // عند تغيير قيمة حقل السعر، يتم تحديث حقل الوزن
  void onPriceChanged(String value) {
    if (_isUpdating) return;
    double? price = double.tryParse(value);
    if (price != null) {
      // حساب الوزن بناءً على السعر والسعر للوحدة
      double weight = price / unitPrice;
      _isUpdating = true;
      weightController.text = weight.toStringAsFixed(2);
      _isUpdating = false;
    }
  }

  // عند تغيير قيمة حقل الوزن، يتم تحديث حقل السعر
  void onWeightChanged(String value) {
    if (_isUpdating) return;
    double? weight = double.tryParse(value);
    if (weight != null) {
      double price = weight * unitPrice;
      _isUpdating = true;
      priceController.text = price.toStringAsFixed(2);
      _isUpdating = false;
    }
  }
}
