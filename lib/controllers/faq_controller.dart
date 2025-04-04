import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FaqController extends GetxController {
  // قائمة الأسئلة العامة (باستثناء الشروط وسياسة الخصوصية)
  var faqs = <dynamic>[].obs;
  // سؤال الشروط والأحكام
  Rxn<dynamic> termsFaq = Rxn<dynamic>();
  // سؤال سياسة الخصوصية
  Rxn<dynamic> privacyFaq = Rxn<dynamic>();
  // حالة التحميل
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchFaqs();
    super.onInit();
  }

  // دالة جلب البيانات من الـ API
  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;
      final response =
      await http.get(Uri.parse("https://nour-market.site/api/faqs"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // جلب قائمة الأسئلة من الحقل data ضمن faqs
        final List<dynamic> faqData = jsonResponse['faqs']['data'];
        // إعادة تعيين القوائم قبل الفرز
        faqs.value = [];
        termsFaq.value = null;
        privacyFaq.value = null;
        // فرز البيانات حسب نوع السؤال
        for (var faq in faqData) {
          String question = faq['question'] ?? '';
          if (question == 'الشروط والاحكام') {
            termsFaq.value = faq;
          } else if (question == 'سياسة الخصوصية') {
            privacyFaq.value = faq;
          } else {
            faqs.add(faq);
          }
        }
      } else {
        Get.snackbar("خطأ", "فشل تحميل الأسئلة");
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
