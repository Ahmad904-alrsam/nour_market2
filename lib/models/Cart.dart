import 'package:get/get.dart';
import 'package:nour_market2/models/product_model.dart';

class CartItem {
  final Product product;
  final RxInt quantity;
  final RxString note;
  final RxString alternativeOption;
  final RxDouble weight; // خاصية الوزن
  final RxDouble quantityPrice; // خاصية سعر الكمية

  CartItem({
    required this.product,
    required int initialQuantity,
    String note = '',
    String alternativeOption = '',
    double weight = 0, // قيمة افتراضية للوزن
    double quantityPrice = 0, // قيمة افتراضية لسعر الكمية
  })  : quantity = initialQuantity.obs,
        note = note.obs,
        alternativeOption = alternativeOption.obs,
        weight = weight.obs,
        quantityPrice = quantityPrice.obs;
}
