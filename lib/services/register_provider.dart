import 'package:get/get.dart';

class RegisterProvider extends GetConnect {
  final String baseUrl = "https://api.example.com"; // هذا الرابط مجرد مثال

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
  }

  // محاكاة جلب العناوين من السيرفر باستخدام بيانات وهمية
  Future<Response> fetchAddresses() async {
    // تأخير بسيط لمحاكاة وقت الاستجابة من السيرفر
    await Future.delayed(Duration(seconds: 1));
    // إرجاع استجابة وهمية مع قائمة عناوين
    return Response(
      statusCode: 200,
      body: [
        {"name": "عنوان 1"},
        {"name": "عنوان 2"},
        {"name": "عنوان 3"},
      ],
    );
  }

  // محاكاة إرسال بيانات التسجيل إلى السيرفر
  Future<Response> registerUser(Map<String, dynamic> data) async {
    await Future.delayed(Duration(seconds: 1));
    // هنا يمكن إرجاع استجابة ناجحة، مثلاً:
    return Response(
      statusCode: 201,
      body: {"message": "تم إنشاء الحساب بنجاح"},
    );
  }
}
