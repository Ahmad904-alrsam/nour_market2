import 'package:get/get.dart';
import '../models/Company.dart';
import '../services/home_provide.dart';

class HomeController extends GetxController {
  final ApiService apiService = ApiService();

  var categories = <String>[].obs;
  var companies = <Company>[].obs;
  var recommended = <String>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchCompanies();
    fetchRecommended();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await apiService.fetchCategories();
      if (response.statusCode == 200) {
        if (response.body is List) {
          categories.value = (response.body as List)
              .map((item) => item['name'].toString())
              .toList();
        } else {
          Get.snackbar('خطأ', 'بيانات التصنيفات غير متوقعة');
        }
      } else {
        Get.snackbar('خطأ', 'فشل في جلب التصنيفات (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر جلب التصنيفات: $e');
    }
  }

  Future<void> fetchCompanies() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 2));

      var dummyData = [
        Company(
          name: 'شركة ألف',
          logoUrl: 'https://via.placeholder.com/60',
        ),
        Company(
          name: 'شركة باء',
          logoUrl: 'https://via.placeholder.com/60',
        ),
        Company(
          name: 'شركة جيم',
          logoUrl: 'https://via.placeholder.com/60',
        ),
      ];

      companies.assignAll(dummyData);
    } catch (e) {
      print('Error fetching companies: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchRecommended() async {
    try {
      // محاكاة تأخير استدعاء API كما في الشركات
      await Future.delayed(const Duration(seconds: 2));

      // بيانات وهمية لعنصر الموصى بها
      var dummyData = [
        'منتج مميز 1',
        'منتج مميز 2',
        'منتج مميز 3',
      ];

      recommended.assignAll(dummyData);
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر جلب الموصى بها: $e');
    }
  }
}
