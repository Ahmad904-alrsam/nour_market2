import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes/app_pages.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),
            // محتوى الصفحة
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      "مرحبًا بك في\nتطبيق نور ماركت",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Cairo",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // الصورة
                  Image.asset(
                    "assets/images/charectar_1.png", // ضع الصورة في مجلد assets
                    height: 145.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 40.h),
                  // النص التوضيحي
                  Text(
                    "تسوق وانت مريح راسك\nواختار الي بيناسبك لك ولعيلتك",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.grey[700],
                      fontFamily: "Cairo",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 120.h),
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
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "إنشاء حساب",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontFamily: "Cairo",
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
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
                      minimumSize: Size(double.infinity, 50.h),
                      side: BorderSide(color: Colors.teal), // لون الحدود
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      "تسجيل دخول",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: "Cairo",
                      ),
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

// رسم الخلفية المنحنية
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.teal.withOpacity(0.3);
    Path path = Path()
      ..moveTo(0, size.height * 0.53)
      ..quadraticBezierTo(
        size.width / 2, size.height * 0.33,
        size.width, size.height * 0.53,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
