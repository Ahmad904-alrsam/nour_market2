import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';
import 'fav_product_controller.dart';

class ProductsController extends GetxController {
  final int subcategoryId;
  ProductsController({required this.subcategoryId});

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxSet<int> favoriteProductIds = <int>{}.obs;
  final String _baseUrl = 'https://nour-market.site';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();


  String? productsNextPageUrl;

  @override
  void onReady() {
    super.onReady();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading(true);
      final token = await _storage.read(key: 'jwt');

      final response = await http.get(
        Uri.parse('$_baseUrl/api/products/$subcategoryId'),
        headers: _buildHeaders(token),
      );
      final favController = Get.find<FavProductController>();
      favController.refreshFavorites();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

         products.assignAll(
          (data['products']['data'] as List)
              .map((json) => Product.fromJson(json))
              .where((p) => p.subCategoryId == subcategoryId)
              .toList(),
        );

        productsNextPageUrl = data['products']['next_page_url'];
      } else {
        _handleError(response);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ في جلب البيانات: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  // دالة لتحميل المزيد من المنتجات عند التمرير (pagination)
  Future<void> loadMoreProducts() async {
    if (productsNextPageUrl == null) return;

    try {
      isLoading(true);
      final token = await _storage.read(key: 'jwt');
      final response = await http.get(
        Uri.parse(productsNextPageUrl!),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newProducts = (data['products']['data'] as List)
            .map((json) => Product.fromJson(json))
            .where((p) => p.subCategoryId == subcategoryId)
            .toList();

        products.addAll(newProducts);
        // تحديث رابط الصفحة التالية
        productsNextPageUrl = data['products']['next_page_url'];
      } else {
        _handleError(response);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل المزيد: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Map<String, String> _buildHeaders(String? token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  void _handleError(http.Response response) {
    final messages = {
      401: 'انتهت الجلسة، يرجى إعادة تسجيل الدخول',
      404: 'لم يتم العثور على المنتج',
      500: 'خطأ في الخادم الداخلي',
    };

    final message = messages[response.statusCode] ??
        'خطأ غير معروف (${response.statusCode})';

    Get.snackbar('خطأ', message);
  }
}
