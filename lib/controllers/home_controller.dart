import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/Company.dart';
import '../models/banner.dart';
import '../models/maincateagory.dart';
import '../models/section.dart';
import '../models/product_model.dart'; // تم استخدام موديل Product هنا
import '../models/storeSettings.dart';
import 'fav_product_controller.dart'; // تأكد من استيراد الكنترولر للمفضلة

class HomeController extends GetxController {
  final Rx<StoreSettings?> storeSettings = Rx<StoreSettings?>(null);

  final RxBool isShowPrice = false.obs;

  RxInt selectedSubcategoryId = 0.obs;
  var isLoadingMore = false.obs;
  var isLoading = true.obs;
  var companies = <Company>[].obs;
  var banners = <BannerModel>[].obs;
  // تغيير نوع القائمة للمُوصى بها لتصبح من نوع Product
  RxList<Product> recommendedProducts = <Product>[].obs;
  var mainCategories = <MainCategory>[].obs;
  var sections = <Section>[].obs;
  var hasMoreRecommendedProducts = false;
  var bodyMessage = ''.obs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  var favoriteProductIds = <int>[].obs;

  // متغيرات لتخزين روابط الصفحات التالية
  String? companiesNextPageUrl;
  String? recommendedProductsNextPageUrl;
  String? mainCategoriesNextPageUrl;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    fetchInitialData();
  }
  Future<void> fetchInitialData() async {
    await fetchStoreSettings();
    await fetchHomeData();
  }


  void checkForUpdates() {
    ever(storeSettings, (settings) {
      if (settings != null) {
        isShowPrice.value = settings.isShowPrice == 1;
      }
    });
  }
  Future<void> fetchStoreSettings() async {
    try {
      StoreSettings? settings = await fetchStoreSettingsFromAPI();
      if (settings != null) {
        storeSettings.value = settings;
        isShowPrice.value = settings.isShowPrice == 1;
      }
    } catch (e) {
      print('Error fetching store settings: $e');
    }
  }

  Future<StoreSettings?> fetchStoreSettingsFromAPI() async {
    try {
      final response = await http.get(Uri.parse("https://nour-market.site/api/settings"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["message"] == "successful") {
          return StoreSettings.fromJson(data["setting"]);
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      String? token = await secureStorage.read(key: 'jwt');

      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكين، يرجى تسجيل الدخول.");
        return;
      }

      var response = await http.get(
        Uri.parse("https://nour-market.site/api/home"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // تحديث بيانات الإعلانات (banners)
        banners.value = (data['banners']['data'] as List)
            .map((json) => BannerModel.fromJson(json))
            .where((banner) => banner.isActive == 1)
            .toList();

        // تحديث بيانات الشركات مع حفظ رابط الصفحة التالية
        companies.value = (data['companies']['data'] as List)
            .map((json) => Company.fromJson(json))
            .toList();
        companiesNextPageUrl = data['companies']['next_page_url'];

        // تحديث بيانات المُوصى بها باستخدام موديل Product مع حفظ رابط الصفحة التالية
        recommendedProducts.value = (data['recommended_products']['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();
        recommendedProductsNextPageUrl = data['recommended_products']['next_page_url'];

        // تحديث بيانات الفئات الرئيسية (main categories) مع حفظ رابط الصفحة التالية
        mainCategories.assignAll(
          (data['main_categories']['data'] as List)
              .map((json) => MainCategory.fromJson(json))
              .where((category) => category.isActive)
              .toList(),
        );
        mainCategoriesNextPageUrl = data['main_categories']['next_page_url'];

        // معالجة بيانات الأقسام (sections)
        if (data.containsKey('sections') &&
            data['sections'] != null &&
            data['sections']['data'] != null &&
            (data['sections']['data'] as List).isNotEmpty) {
          sections.value = (data['sections']['data'] as List)
              .map((json) => Section.fromJson(json))
              .toList();
        } else {
          sections.clear();
        }

        bodyMessage.value = data['body'] ?? '';

        // تحديث المفضلة بناءً على المنتجات المُوصى بها
        final favController = Get.find<FavProductController>();
        favController.refreshFavorites();
      } else {
        Get.snackbar("Error", "فشل في جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "حدث خطأ غير متوقع: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // دالة لتحديث البيانات (refresh) كاملة
  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      await fetchHomeData();
    } catch (e) {
      Get.snackbar("Error", "فشل في التحديث: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // دالة تحميل المزيد من الشركات (pagination)
  Future<void> loadMoreCompanies() async {
    if (companiesNextPageUrl == null) return;
    try {
      isLoading.value = true;
      String? token = await secureStorage.read(key: 'jwt');
      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكين، يرجى تسجيل الدخول.");
        return;
      }
      var response = await http.get(
        Uri.parse(companiesNextPageUrl!),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var newCompanies = (data['companies']['data'] as List)
            .map((json) => Company.fromJson(json))
            .toList();
        companies.addAll(newCompanies);
        companiesNextPageUrl = data['companies']['next_page_url'];
      } else {
        Get.snackbar("Error", "فشل في جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "حدث خطأ غير متوقع: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // دالة تحميل المزيد من المنتجات المُوصى بها (pagination)
  Future<void> loadMoreRecommendedProducts() async {
    if (recommendedProductsNextPageUrl == null || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true; // تم تفعيل حالة التحميل
      String? token = await secureStorage.read(key: 'jwt');

      var response = await http.get(
        Uri.parse(recommendedProductsNextPageUrl!),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var newProducts = (data['recommended_products']['data'] as List)
            .map((json) => Product.fromJson(json))
            .toList();

        recommendedProducts.addAll(newProducts);
        recommendedProductsNextPageUrl = data['recommended_products']['next_page_url'];
        hasMoreRecommendedProducts = recommendedProductsNextPageUrl != null;

        // تحديث حالة المفضلة للمنتجات الجديدة
        final favController = Get.find<FavProductController>();
        favController.refreshFavorites();
      }
    } catch (e) {
      print('Error loading more products: $e');
    } finally {
      isLoadingMore.value = false; // إلغاء حالة التحميل
    }
  }
  // دالة تحميل المزيد من الفئات الرئيسية (pagination)
  Future<void> loadMoreMainCategories() async {
    if (mainCategoriesNextPageUrl == null) return;
    try {
      isLoading.value = true;
      String? token = await secureStorage.read(key: 'jwt');
      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكين، يرجى تسجيل الدخول.");
        return;
      }
      var response = await http.get(
        Uri.parse(mainCategoriesNextPageUrl!),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var newCategories = (data['main_categories']['data'] as List)
            .map((json) => MainCategory.fromJson(json))
            .where((category) => category.isActive)
            .toList();
        mainCategories.addAll(newCategories);
        mainCategoriesNextPageUrl = data['main_categories']['next_page_url'];
      } else {
        Get.snackbar("Error", "فشل في جلب البيانات: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "حدث خطأ غير متوقع: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
