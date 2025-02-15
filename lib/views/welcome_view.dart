import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // لون الخلفية الأساسية
        body: Stack(
          children: [
            // الخلفية المنحنية المعدلة لتكون منخفضة قليلاً
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),

            // محتوى الصفحة
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // يبدأ المحتوى من الأعلى
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // نص الترحيب في الأعلى مع ضبط مسافة من الأعلى
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "مرحبًا بك في\nتطبيق نور ماركت",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),

                  // الصورة
                  Image.asset(
                    "assets/images/charectar_1.png", // ضع الصورة في مجلد assets
                    height: 160,
                  ),
                  SizedBox(height: 40),

                  // النص التوضيحي
                  Text(
                    "تسوق وانت مريح راسك\nواختار الي بيناسبك لك ولعيلتك",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 120,),

                  // زر إنشاء حساب
                  ElevatedButton(
                    onPressed: () async {
                      Get.dialog(
                        Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      await Future.delayed(Duration(milliseconds: 300));
                      await Get.offNamed(Routes.REGISTER);
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // لون الزر
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "إنشاء حساب",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),

                  // زر تسجيل دخول
                  OutlinedButton(
                    onPressed: () async {
                      Get.dialog(
                        Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      await Future.delayed(Duration(milliseconds: 300));
                      await Get.offNamed(Routes.LOGIN);
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal, // لون النص
                      minimumSize: Size(double.infinity, 50),
                      side: BorderSide(color: Colors.teal), // لون الحدود
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "تسجيل دخول",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// رسم الخلفية المنحنية بعد تعديل الإحداثيات
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // تعديل إحداثيات الرسم لجعل الخلفية تنزل إلى الأسفل
    Paint paint = Paint()..color = Colors.teal.withOpacity(0.3);
    Path path = Path()
      ..moveTo(0, size.height * 0.53) // بدء المنحنى من 40% من ارتفاع الشاشة
      ..quadraticBezierTo(
          size.width / 2, size.height * 0.33, // نقطة التحكم لتعديل شكل المنحنى
          size.width, size.height * 0.53) // نهاية المنحنى على نفس الارتفاع
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
