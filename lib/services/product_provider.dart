// lib/services/category_provider.dart
import 'package:get/get.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    // في حالة البيانات المزيفة، يمكنك ترك baseUrl كما هو أو تغييره لاحقاً عند الانتقال للـ API الحقيقي
    httpClient.baseUrl = 'https://yourapi.com/api';
    super.onInit();
  }

  Future<Response> fetchProducts(int subcategoryId) async {
    // محاكاة تأخير الشبكة لتقليد زمن الاستجابة
    await Future.delayed(const Duration(seconds: 2));

    // بيانات المنتجات المزيفة لتجربة التطبيق
    final List<Map<String, dynamic>> fakeProducts = [
      {
        "id": 1,
        "title": "منتج تجريبي 1",
        "price": 100.0,
        "imageUrl": "https://via.placeholder.com/150",
        "subcategoryId": subcategoryId,
        "unit":"فرط",
      },
      {
        "id": 2,
        "title": "منتج تجريبي 2",
        "price": 200.0,
        "imageUrl": "https://via.placeholder.com/150",
        "subcategoryId": subcategoryId,
        "unit":"فرط",


      },
    ];

    // طباعة للتاكد من جلب البيانات المزيفة (اختياري)
    print("Fetched fake products for subcategoryId: $subcategoryId");

    // إعادة Response ببيانات مزيفة مع حالة نجاح 200
    return Response(
      body: fakeProducts,
      statusCode: 200,
    );
  }
}
