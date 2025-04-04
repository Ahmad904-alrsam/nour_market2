import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/login_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/backgroundPainter.dart';

class LoginView extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: BackgroundPainter(),
              ),
              Center(
                child: SingleChildScrollView(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Form(
                    key: _controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: Colors.teal,
                          child: Image.asset(
                            'assets/images/photo_2025-02-04_16-43-45-removebg-preview.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(height: 40.h),
                        buildTextField("الاسم", _controller.nameController,
                            icon: Icons.person),
                        SizedBox(height: 15.h),
                        buildTextField("رقم الهاتف", _controller.phoneController,
                            keyboardType: TextInputType.phone,
                            icon: Icons.phone),
                        SizedBox(height: 30.h),
                        ElevatedButton(
                          onPressed: () async {
                            if (_controller.formKey.currentState!.validate()) {
                              await _controller.login();
                            }
                            Get.dialog(
                              Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );
                            await Future.delayed(Duration(milliseconds: 300));
                            await Get.offNamed(Routes.HOME);
                            if (Get.isDialogOpen ?? false) {
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "دخول",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextButton(

                          onPressed: () => Get.toNamed('/register'),
                          child: Text(
                            "ليس لديك حساب؟ سجل الآن",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14.sp, fontFamily: 'Cairo'),
        validator: (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'رجاءً أدخل $hint';
          }
          if (hint.contains("رقم الهاتف")) {
            if (!RegExp(r'^\d+$').hasMatch(value!)) {
              return 'الرجاء إدخال رقم هاتف صحيح';
            }
            if (value.length < 10) {
              return 'رقم الهاتف يجب أن يكون على الأقل 10 أرقام';
            }
            if (!value.startsWith("09")) {
              return 'يجب أن يبدأ رقم الهاتف بـ 09';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, size: 24.sp) : null,
          labelText: hint,
          labelStyle: TextStyle(
              color: Colors.grey[700],
              fontSize: 12.sp,
              fontFamily: 'Cairo'),
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'Cairo',
              fontSize: 12.sp),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(
              color: Colors.red, fontSize: 10.sp, fontFamily: 'Cairo'),
        ),
      ),
    );
  }
}
