import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nour_market2/views/register_view.dart';
import '../controllers/login_controller.dart';
import '../routes/app_pages.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  // حقول إدخال الاسم ورقم الهاتف
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية مخصصة (إذا كنت تستخدمها)
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: BackgroundPainter(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // أيقونة التطبيق
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: Image.asset(
                        'assets/images/photo_2025-02-04_16-43-45-removebg-preview.png',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // عنوان الصفحة
                    Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(

                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'الاسم',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        filled:true,
                        fillColor: Colors.grey[300],

                      ),
                    ),
                    const SizedBox(height: 20),
                    // حقل إدخال رقم الهاتف
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),

                        ),

                        filled: true,
                        fillColor: Colors.grey[300],

                      ),
                    ),
                    const SizedBox(height: 20),
                    // عرض رسالة الخطأ إن وجدت
                    Obx(() => controller.errorMessage.value.isNotEmpty
                        ? Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 20),
                    // زر تسجيل الدخول
                    Obx(() => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.login(
                            nameController.text,
                            phoneController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'دخول',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 10),
                    // زر الانتقال إلى صفحة التسجيل
                    TextButton(
                      onPressed: () {
                        Get.offNamed(Routes.REGISTER);
                      },
                      child: const Text(
                        'ليس لديك حساب؟ سجل الآن',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
