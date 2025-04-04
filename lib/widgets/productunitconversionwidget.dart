import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/priceweight_controller.dart';
import '../models/product_model.dart';

class ProductUnitConversionWidget extends StatefulWidget {
  final Product product;
  final Function(double)? onWeightChanged;
  final Function(double)? onPriceChanged;

  const ProductUnitConversionWidget({
    Key? key,
    required this.product,
    this.onWeightChanged,
    this.onPriceChanged,
  }) : super(key: key);

  @override
  _ProductUnitConversionWidgetState createState() =>
      _ProductUnitConversionWidgetState();
}

class _ProductUnitConversionWidgetState
    extends State<ProductUnitConversionWidget> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  late final PriceWeightController conversionController;

  // Flags لمنع التحديثات المتكررة (infinite loop)
  bool _isUpdatingPrice = false;
  bool _isUpdatingWeight = false;

  @override
  void initState() {
    super.initState();
    // تعيين قيمة افتراضية للوزن
    weightController.text = '0';

    // تسجيل المراقب مع tag خاص بالمنتج
    conversionController = Get.put(
      PriceWeightController(unitPrice: widget.product.price.toDouble()),
      tag: widget.product.id.toString(),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    priceController.dispose();
    super.dispose();
  }

  // دوال تحويل بسيطة بناءً على سعر الوحدة
  double _priceToWeight(double price) =>
      conversionController.unitPrice != 0
          ? price / conversionController.unitPrice
          : 0;

  double _weightToPrice(double weight) =>
      weight * conversionController.unitPrice;

  @override
  Widget build(BuildContext context) {
    // إذا كان نوع المنتج "piece" فلا يظهر هذا الودجت
    if (widget.product.type?.toLowerCase() == "piece") {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'سعر الكمية:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'سعر الكمية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 16),
                ),
                onChanged: (value) {
                  if (_isUpdatingPrice) return;
                  double? price = double.tryParse(value);
                  if (price != null) {
                    if (widget.onPriceChanged != null) {
                      widget.onPriceChanged!(price);
                    }
                    // حساب الوزن بناءً على السعر المدخل
                    double weight = _priceToWeight(price);
                    _isUpdatingWeight = true;
                    weightController.text = weight.toStringAsFixed(2);
                    _isUpdatingWeight = false;
                    if (widget.onWeightChanged != null) {
                      widget.onWeightChanged!(weight);
                    }
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الوزن:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: weightController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'الوزن',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 16),
                ),
                onChanged: (value) {
                  if (_isUpdatingWeight) return;
                  double? weight = double.tryParse(value);
                  if (weight != null) {
                    if (widget.onWeightChanged != null) {
                      widget.onWeightChanged!(weight);
                    }
                    // حساب السعر بناءً على الوزن المدخل
                    double price = _weightToPrice(weight);
                    _isUpdatingPrice = true;
                    priceController.text = price.toStringAsFixed(2);
                    _isUpdatingPrice = false;
                    if (widget.onPriceChanged != null) {
                      widget.onPriceChanged!(price);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
