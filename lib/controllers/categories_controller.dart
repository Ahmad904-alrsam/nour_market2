import 'package:get/get.dart';
import '../models/category.dart';
import '../services/category_provider.dart';

class CategoriesController extends GetxController {
  final ApiService apiService = ApiService();

  // قائمة الأقسام
  var categories = <Category>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await apiService.fetchCategories();
      if (response.statusCode == 200) {
        // تأكد أن الـ response.body عبارة عن List
        if (response.body is List) {
          categories.value = (response.body as List)
              .map((item) => Category.fromJson(item))
              .toList();
        } else {
          Get.snackbar("خطأ", "بيانات الأقسام غير متوقعة");
        }
      } else {
        Get.snackbar("خطأ", "فشل في جلب الأقسام (${response.statusCode})");
      }
    } catch (e) {
      // في حالة وجود خطأ أو عدم جاهزية الـ backend، يمكن استخدام بيانات وهمية
      categories.assignAll([
        Category(
          id: 1,
          name: 'أقسام إلكترونيات',
          imageUrl: 'https://via.placeholder.com/50',
        ),
        Category(
          id: 2,
          name: 'أقسام ملابس',
          imageUrl: 'https://via.placeholder.com/50',
        ),
        Category(
          id: 3,
          name: 'أقسام أثاث',
          imageUrl: 'https://via.placeholder.com/50',
        ),
      ]);
      Get.snackbar("خطأ", "تعذر جلب الأقسام: $e");
    } finally {
      isLoading(false);
    }
  }
}
