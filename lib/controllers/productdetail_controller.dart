import 'package:get/get.dart';

import '../models/Product.dart';
import '../services/product_details.dart';

class ProductDetailController extends GetxController {
  var product = Rxn<Product>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var quantity = 1.obs;

  final ProductService productService = ProductService();

  Future<void> fetchProductDetail(int productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await productService.fetchProductDetail(productId);
      if (response.statusCode == 200) {
        if (response.body != null && response.body is Map<String, dynamic>) {
          product.value = Product.fromJson(response.body);
        } else {
          errorMessage.value = 'البيانات غير صحيحة';
        }
      } else {
        errorMessage.value = 'حدث خطأ: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  void increment() => quantity++;
  void decrement() {
    if (quantity > 1) quantity--;
  }
}
