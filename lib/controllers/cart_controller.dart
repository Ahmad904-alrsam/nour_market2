import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../models/Cart.dart';
import '../models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'bottom_nav_conttroller.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  final total = 0.0.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void addProduct(
      Product product, {
        int initialQuantity = 1,
        String note = "",
        String alternativeOption = "",
        double weight = 0, // الوزن المُدخل من المستخدم
        double userQuantityPrice = 0, // سعر الكمية المُدخل من المستخدم
      }) {
    final double finalQuantityPrice = (product.type?.toLowerCase() == 'piece')
        ? product.price
        : userQuantityPrice;

    final existingItem = cartItems.firstWhereOrNull(
          (item) => item.product.id == product.id,
    );

    if (existingItem != null) {
      existingItem.quantity.value += initialQuantity;
      existingItem.note.value = note;
      existingItem.alternativeOption.value = alternativeOption;
      if (product.type?.toLowerCase() != 'piece') {
        existingItem.weight.value = weight;
      }
      existingItem.quantityPrice.value = finalQuantityPrice;
    } else {
      cartItems.add(
        CartItem(
          product: product,
          initialQuantity: initialQuantity,
          note: note,
          alternativeOption: alternativeOption,
          weight: weight,
          quantityPrice: finalQuantityPrice,
        ),
      );
    }
    _updateTotal();
  }

  void increaseQuantity(Product product) {
    final item = cartItems.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => throw Exception('العنصر غير موجود'),
    );
    item.quantity.value++;
    _updateTotal();
  }

  void decreaseQuantity(Product product) {
    final item = cartItems.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => throw Exception('العنصر غير موجود'),
    );
    if (item.quantity.value > 1) {
      item.quantity.value--;
    }
    _updateTotal();
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
    _updateTotal();
  }

  void _updateTotal() {
    total.value = cartItems.fold(
      0.0,
          (sum, item) => sum + (item.quantityPrice.value * item.quantity.value),
    );
  }

  Future<void> submitOrder({
    required String deliveryArea,
    required double deliveryCost,
    required double totalPrice,
    // رقم الهاتف لإرسال الرسالة عبر واتس آب (بصيغة دولية بدون صفر أولاً)
    required String whatsappPhoneNumber,
  }) async {
    final orderData = {
      'deliveryArea': deliveryArea,
      'deliveryCost': deliveryCost,
      'totalPrice': totalPrice,
      'products': cartItems.map((item) {
        return {
          'productId': item.product.id,
          'productNotFound': item.alternativeOption.value,
          'price': item.quantityPrice.value,
          'quantity': item.quantity.value,
          'quantityPrice': item.quantityPrice.value * item.quantity.value,
          'quantityWieght': item.weight.value,
          'note': item.note.value,
        };
      }).toList(),
    };

    print('Request Body: ${json.encode(orderData)}');

    final url = Uri.parse('https://nour-market.site/api/orders');

    try {
      final token = await secureStorage.read(key: 'jwt');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        print('تم إرسال الطلب بنجاح');

        // بعد نجاح إرسال الطلب، نقوم بإرسال رسالة واتس آب بكل التفاصيل
        final String message = '''
مرحباً،
لقد تم تقديم طلب جديد.
إجمالي السعر: ${totalPrice.toStringAsFixed(2)} ليرة
تكلفة التوصيل: ${deliveryCost.toStringAsFixed(2)} ليرة
المنطقة: $deliveryArea

تفاصيل المنتجات:
${cartItems.map((item) => '${item.product.name} - الكمية: ${item.quantity.value} - السعر: ${item.quantityPrice.value} ليرة - الملاحظات: ${item.note.value}').join('\n')}
''';

        final String whatsappUrl =
            "https://wa.me/$whatsappPhoneNumber?text=${Uri.encodeComponent(message)}";

        if (await canLaunch(whatsappUrl)) {
          await launch(whatsappUrl);
        } else {
          Get.snackbar("خطأ", "لا يمكن فتح واتس آب.");
        }

        clearCart();
      } else {
        print('فشل الإرسال: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('خطأ: $e');
    }
  }

  void clearCart() {
    cartItems.clear();
    _updateTotal();
    Get.find<BottomNavController>().resetCartCount();

  }
}
