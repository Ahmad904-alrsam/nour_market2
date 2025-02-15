import 'dart:async';
import 'package:get/get.dart';
import '../models/Product.dart';

class ProductService extends GetConnect {
  Future<Response> fetchProductDetail(int productId) async {
    // تأخير لمحاكاة استجابة الشبكة
    await Future.delayed(const Duration(seconds: 2));

    // بيانات وهمية مؤقتاً
    final productData = {
      "id": productId,
      "title": "منتج تجريبي", // تأكد من أن الأسماء تتطابق مع نموذجك
      "description": "هذا وصف المنتج التجريبي المستخدم حتى يصبح الباكيند جاهزاً.",
      "price": 99.99,
      "imageUrl": "https://via.placeholder.com/150",
      "subcategoryId": 1,
      "unit": "فرط"
    };

    // إنشاء Response وهمي مع كود حالة 200
    return Response(body: productData, statusCode: 200);
  }
}
