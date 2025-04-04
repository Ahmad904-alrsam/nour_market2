import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductDetailController extends GetxController {
  // حالة التحميل ورسالة الخطأ
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  RxString selectedAlternativeOption = "".obs;
  RxString userNote ="".obs;
  // تخزين تفاصيل المنتج
  var product = Rxn<Product>();

  // السعر الحالي والكمية
  RxDouble currentPrice = 0.0.obs;
  RxInt quantity = 1.obs;

  final String baseUrl = 'https://nour-market.site';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> fetchProductDetails(int productId) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      final token = await secureStorage.read(key: 'jwt');

      // بناء الرابط بشكل صحيح
      final url = Uri.parse('$baseUrl/api/products/$productId/show');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      switch (response.statusCode) {
        case 200:
          print(response.body);
          final Map<String, dynamic> data = json.decode(response.body);
          product.value = Product.fromJson(data['product']);
          // افتراضاً أن نموذج المنتج يحتوي على خاصية price
          currentPrice.value = product.value!.price;

          break;

        case 401:
          Get.snackbar('خطأ مصادقة', 'يرجى إعادة تسجيل الدخول');
          await secureStorage.delete(key: 'jwt');
          Get.offAllNamed('/login');
          break;

        case 404:
          errorMessage.value = 'المنتج المطلوب غير متوفر';
          Get.snackbar('غير موجود', errorMessage.value);
          product.value = null;
          break;

        default:
          errorMessage.value = 'فشل جلب البيانات: ${response.body}';
          Get.snackbar('خطأ ${response.statusCode}', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = e is SocketException
          ? 'مشكلة في الاتصال بالإنترنت'
          : e.toString();
      Get.snackbar('خطأ غير متوقع', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // دوال تعديل الكمية
  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}
