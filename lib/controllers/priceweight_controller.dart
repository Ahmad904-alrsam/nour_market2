import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceWeightController extends GetxController {
  final double unitPrice; // سعر الوحدة (سعر المنتج لكل وحدة وزن)

  PriceWeightController({required this.unitPrice});

  final TextEditingController priceController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool _isUpdating = false; // لمنع التحديث المتكرر والدوري

  // عند تغير السعر، يتم حساب الوزن
  void onPriceChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    double? enteredPrice = double.tryParse(value);
    if (enteredPrice != null) {
      // الوزن = السعر المدخل / سعر الوحدة
      double weight = enteredPrice / unitPrice;
      weightController.text = weight.toStringAsFixed(2);
    } else {
      weightController.text = '';
    }

    _isUpdating = false;
  }

  // عند تغير الوزن، يتم حساب السعر
  void onWeightChanged(String value) {
    if (_isUpdating) return;
    _isUpdating = true;

    double? enteredWeight = double.tryParse(value);
    if (enteredWeight != null) {
      // السعر = الوزن المدخل * سعر الوحدة
      double price = enteredWeight * unitPrice;
      priceController.text = price.toStringAsFixed(2);
    } else {
      priceController.text = '';
    }

    _isUpdating = false;
  }

  @override
  void onClose() {
    priceController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
