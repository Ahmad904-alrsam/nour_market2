import 'package:get/get.dart';

class LoginProvider extends GetConnect {
  final String baseUrl = "https://api.example.com"; // مثال على رابط السيرفر

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
  }

  /// دالة تسجيل الدخول لمستخدم موجود
  Future<Response> loginUser(Map<String, dynamic> data) async {
    // تأخير بسيط لمحاكاة وقت الاستجابة من السيرفر
    await Future.delayed(Duration(seconds: 1));

    // في حال الاستخدام الواقعي، يمكنك استدعاء نقطة النهاية الخاصة بتسجيل الدخول:
    // return await post('/login', data);

    // هنا نقوم بمحاكاة حالة تسجيل الدخول:
    if (data['name'] == 'existingUser' && data['phone'] == '123456789') {
      return Response(
        statusCode: 200,
        body: {
          "message": "تم تسجيل الدخول بنجاح",
          "user": {
            "id": 1,
            "name": "existingUser",
            "phone": "123456789"
          }
        },
      );
    } else {
      return Response(
        statusCode: 401,
        body: {"message": "بيانات الاعتماد غير صحيحة"},
      );
    }
  }
}
