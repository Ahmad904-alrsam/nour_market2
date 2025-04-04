import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class SearchControllerApi extends GetxController {
  var isLoading = false.obs;
  var isMoreLoading = false.obs; // حالة تحميل المزيد
  final RxList<Product> searchResults = <Product>[].obs;
  var isSearching = false.obs;
  final String baseUrl = 'https://nour-market.site';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  int currentPage = 1;
  String? nextPageUrl;

  /// دالة البحث مع إمكانية تمرير mainCategoryId
  Future<void> searchProducts(String content, {String? mainCategoryId}) async {
    try {
      // إعادة تعيين بيانات التجزئة عند بدء بحث جديد
      currentPage = 1;
      nextPageUrl = null;
      isLoading(true);
      final token = await secureStorage.read(key: 'jwt');

      final response = await http.post(
        Uri.parse('$baseUrl/api/products/search'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': content,
          if (mainCategoryId != null) 'mainCategoryId': mainCategoryId,
        }),
      );

      if (response.statusCode == 200) {
        // فك تشفير الاستجابة مع مراعاة الترميز
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        // قراءة الرسالة والنص العام إذا لزم الأمر
        final message = decodedData['message'] ?? 'تم الأمر بنجاح';
        final bodyMsg = decodedData['body'] ?? '';

        List<dynamic> productsData = [];
        if (decodedData is Map<String, dynamic>) {
          final products = decodedData['products'];
          if (products is Map<String, dynamic> && products.containsKey('data')) {
            productsData = products['data'];
            currentPage = products['current_page'] ?? 1;
            nextPageUrl = products['next_page_url'];
          }
        }

        // تحويل بيانات المنتجات إلى نموذج Product وتحديث القائمة
        searchResults.value = productsData
            .map((item) => Product.fromJson(item))
            .toList();

        isSearching(true);
        // عرض رسالة النجاح مع عدد النتائج والرسائل المرسلة من السيرفر إن وُجدت
        Get.snackbar('نجاح', '$message\n$bodyMsg\nتم العثور على ${searchResults.length} نتيجة');
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء البحث: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  /// دالة تحميل المزيد من النتائج مع إمكانية تمرير mainCategoryId
  Future<void> loadMoreProducts(String content, {String? mainCategoryId}) async {
    if (nextPageUrl == null) return;
    try {
      isMoreLoading(true);
      final token = await secureStorage.read(key: 'jwt');

      final response = await http.post(
        Uri.parse(nextPageUrl!),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': content,
          if (mainCategoryId != null) 'mainCategoryId': mainCategoryId,
        }),
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(utf8.decode(response.bodyBytes));

        List<dynamic> productsData = [];
        if (decodedData is Map<String, dynamic>) {
          final products = decodedData['products'];
          if (products is Map<String, dynamic> && products.containsKey('data')) {
            productsData = products['data'];
            currentPage = products['current_page'] ?? currentPage;
            nextPageUrl = products['next_page_url'];
          }
        }

        // إضافة النتائج الجديدة إلى القائمة الحالية
        searchResults.addAll(
          productsData.map((item) => Product.fromJson(item)).toList(),
        );
        Get.snackbar('نجاح', 'تم تحميل المزيد من النتائج');
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل المزيد: ${e.toString()}');
    } finally {
      isMoreLoading(false);
    }
  }

  /// معالجة الاستجابات ذات الأخطاء بناءً على رمز الحالة
  void _handleErrorResponse(http.Response response) {
    switch (response.statusCode) {
      case 400:
        Get.snackbar('خطأ', 'طلب غير صحيح');
        break;
      case 401:
        Get.snackbar('خطأ', 'غير مصرح بالوصول');
        break;
      case 404:
        Get.snackbar('خطأ', 'لم يتم العثور على نتائج');
        break;
      default:
        Get.snackbar('خطأ', 'خطأ غير معروف: ${response.statusCode}');
    }
  }

  /// إعادة تعيين البحث وإفراغ القائمة
  void clearSearch() {
    isSearching(false);
    searchResults.clear();
    currentPage = 1;
    nextPageUrl = null;
  }

  /// تحميل المزيد عند التمرير (مثلاً عند الوصول لنهاية القائمة)
  Future<void> loadMoreIfNeeded(String content, {String? mainCategoryId, required double currentScroll}) async {
    if (nextPageUrl != null && currentScroll > 0.9) {
      await loadMoreProducts(content, mainCategoryId: mainCategoryId);
    }
  }
}
