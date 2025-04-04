import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../routes/app_pages.dart';
import '../services/register_provider.dart';
import '../services/storageservice.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final AuthService _auth = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login() async {
    try {
      isLoading(true);
      errorMessage('');

      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        errorMessage('الرجاء ملء جميع الحقول');
        return;
      }

      final response = await post(
        Uri.parse('https://nour-market.site/api/login'),
        body: {
          'name': nameController.text,
          'phone': phoneController.text,
        },
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        await _auth.saveToken(token);
        await StorageService.getToken();
        Get.offAllNamed(Routes.HOME);
      } else {
        errorMessage('فشل تسجيل الدخول: ${response.body}');
      }
    } catch (e) {
      errorMessage('حدث خطأ: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}