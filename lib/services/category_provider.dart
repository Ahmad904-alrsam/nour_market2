import 'package:get/get.dart';

class ApiService extends GetConnect {
  // قم بتعديل الـ baseUrl بما يتناسب مع الـ backend الخاص بك
  final String baseUrl = "https://example.com/api";

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 10);
    // يمكن إضافة Headers أو إعدادات أخرى هنا إذا لزم الأمر
  }

  // دالة لجلب الأقسام الوهمية
  Future<Response> fetchCategories() async {
    // محاكاة تأخير الشبكة لمدة ثانيتين
    await Future.delayed(const Duration(seconds: 2));

    // بيانات الأقسام الوهمية
    final List<Map<String, dynamic>> fakeCategories = [
      {
        "id": 1,
        "name": "إلكترونيات",
        "image": "https://via.placeholder.com/150"
      },
      {
        "id": 2,
        "name": "ملابس",
        "image": "https://via.placeholder.com/150"
      },
      {
        "id": 3,
        "name": "أدوات منزلية",
        "image": "https://via.placeholder.com/150"
      },
      {
        "id": 4,
        "name": "ألعاب",
        "image": "https://via.placeholder.com/150"
      },
    ];

    // إعادة البيانات الوهمية مع رمز حالة 200
    return Response(body: fakeCategories, statusCode: 200);
  }

  // مثال لدالة جلب الموصى بها باستخدام بيانات وهمية
  Future<Response> fetchRecommended() async {
    // محاكاة تأخير الشبكة لمدة ثانيتين
    await Future.delayed(const Duration(seconds: 2));

    // بيانات المنتجات الموصى بها الوهمية
    final List<Map<String, dynamic>> fakeRecommended = [
      {
        "id": 101,
        "title": "منتج مميز 1",
        "description": "وصف المنتج 1",
        "price": 99.99,
        "image": "https://via.placeholder.com/150"
      },
      {
        "id": 102,
        "title": "منتج مميز 2",
        "description": "وصف المنتج 2",
        "price": 149.99,
        "image": "https://via.placeholder.com/150"
      },
    ];
body:
    // إعادة اstatusCode: لبيانات الوهمية مع رمز حالة 200
    return Response(body: fakeRecommended, statusCode: 200);
  }
}
