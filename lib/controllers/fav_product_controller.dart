import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class FavProductController extends GetxController {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // إذا أردت تنفيذ تحديث للقائمة، يمكنك إضافة المنطق هنا
  Future<void> refreshFavorites() async {
    // تنفيذ منطق التحديث إن وجد
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      isLoading.value = true;
      final token = await _storage.read(key: 'jwt');
      if (token == null) {
        Get.snackbar("Error", "Please login first");
        return;
      }

      final response = await http.get(
        Uri.parse("https://nour-market.site/api/products/${product.id}/toggle-favorite"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        // تبديل حالة التفضيل مباشرة على المُنتج
        product.isFavorite = product.isFavorite == 1 ? 0 : 1;
        update(); // تحديث الواجهة
        Get.snackbar("Success", "Favorite updated");
      } else {
        Get.snackbar("Error", "Failed to update favorite");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred");
    } finally {
      isLoading.value = false;
    }
  }

  // يُرجع true إذا كان المُنتج مفضل
  bool isFavorite(Product product) {
    return product.isFavorite == 1;
  }
}
