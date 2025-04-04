import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import 'package:http/http.dart' as http;

class CompanisController extends GetxController {
  // متغير لتتبع حالة التحميل للمنتجات
  var isLoadingProducts = false.obs;
  // قائمة المنتجات القابلة للملاحظة
  var products = <Product>[].obs;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> getProducts(int companyId) async {
    isLoadingProducts.value = true; // بدء التحميل
    try {
      final token = await secureStorage.read(key: 'jwt');

      // التحقق من وجود التوكن
      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على رمز الدخول");
        return;
      }

      final response = await http.get(
        Uri.parse("https://nour-market.site/api/companies/$companyId/products"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // تحقق إذا كان المفتاح "products" موجود ويحتوي على بيانات
        if (responseData.containsKey('products') && responseData['products'] != null) {
          dynamic productsJson = responseData['products'];
          List<dynamic> productList = [];

          // إذا كان products عبارة عن قائمة مباشرةً
          if (productsJson is List) {
            productList = productsJson;
          }
          // إذا كان products عبارة عن Map يحتوي على مفتاح "data"
          else if (productsJson is Map && productsJson.containsKey('data')) {
            productList = productsJson['data'] as List;
          }

          // فلترة المنتجات بحيث تُعرض فقط تلك التي تخص الشركة
          final List<dynamic> filteredProducts = productList.where((data) {
            return data['company_id'] == companyId;
          }).toList();

          products.assignAll(
            filteredProducts.map((data) => Product.fromJson(data)).toList(),
          );
        } else {
          products.clear();
          print('Error: No products found.');
          Get.snackbar("خطأ", "لا توجد منتجات متاحة");
        }
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        Get.snackbar("خطأ", "فشل جلب المنتجات");
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoadingProducts.value = false; // إيقاف التحميل
    }
  }
}
