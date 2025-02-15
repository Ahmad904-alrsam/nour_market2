import 'package:get/get.dart';
import '../models/sub_category_model.dart';
import '../services/category_provider.dart';

class SubCategoriesController extends GetxController {
  var isLoading = true.obs;
  var subCategories = <SubCategory>[].obs;

  // المعرف الخاص بالقسم الذي تم تمريره من صفحة الأقسام
  final int categoryId;

  final ApiService apiService = ApiService();

  SubCategoriesController({required this.categoryId});

  @override
  void onInit() {
    super.onInit();
    fetchSubCategories();
  }

  void fetchSubCategories() async {
    try {
      isLoading(true);
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 2));

      // بيانات وهمية للتصنيفات الفرعية
      final List<Map<String, dynamic>> fakeSubCategories = [
        {"id": 1, "name": "فرعي 1", "image": "https://via.placeholder.com/150"},
        {"id": 2, "name": "فرعي 2", "image": "https://via.placeholder.com/150"},
        {"id": 3, "name": "فرعي 3", "image": "https://via.placeholder.com/150"},
      ];

      subCategories.value = fakeSubCategories
          .map((json) => SubCategory.fromJson(json))
          .toList();
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading(false);
    }
  }

}

