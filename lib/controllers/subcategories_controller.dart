import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sub_category_model.dart';

class SubCategoriesController extends GetxController {
  int categoryId; // تم تغييرها من final إلى متغير عادي
  final RxBool isLoading = true.obs;
  final RxList<SubCategory> subCategories = <SubCategory>[].obs;
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  SubCategoriesController({required this.categoryId, required String subcategoryName});

  @override
  void onInit() {
    super.onInit();
    fetchSubCategories();
  }

  Future<void> fetchSubCategories() async {
    try {
      isLoading(true);
      final token = await secureStorage.read(key: 'jwt');

      if (token == null) {
        throw 'لم يتم العثور على رمز الدخول';
      }

      final response = await http.get(
        Uri.parse('https://nour-market.site/api/sub-categories/$categoryId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        subCategories.assignAll(
          (data['subCategories']['data'] as List)
              .map((json) => SubCategory.fromJson(json))
              .toList(),
        );



      } else {
        throw _handleError(response);
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void updateCategory(int newCategoryId) {
    if (categoryId != newCategoryId) {
      categoryId = newCategoryId;
      subCategories.clear();
      fetchSubCategories();
    }
  }

  Future<void> refreshSubCategories() async {
    try {
      isLoading(true);
      subCategories.clear();
      await fetchSubCategories();
    } catch (e) {
      Get.snackbar("خطأ", "تعذر تحديث البيانات: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  String _handleError(http.Response response) {
    switch (response.statusCode) {
      case 401:
        return 'غير مصرح بالوصول، يرجى إعادة تسجيل الدخول';
      case 404:
        return 'لم يتم العثور على الأقسام الفرعية';
      case 500:
        return 'خطأ في الخادم الداخلي';
      default:
        return 'فشل جلب البيانات: ${response.statusCode}';
    }
  }
}