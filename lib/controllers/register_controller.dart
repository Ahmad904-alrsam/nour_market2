import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/registermodel.dart';
import '../routes/app_pages.dart';
import '../services/storageservice.dart';
import '../controllers/location_controller.dart';
import 'home_controller.dart';

class RegisterController extends GetxController {
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onReady() {
    super.onReady();
    checkInternet().then((hasInternet) {
      if (!hasInternet) {
        Get.snackbar('تنبيه', 'لا يوجد اتصال بالإنترنت');
      }
    });
  }


  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  // يمكن حذف هذين المتحكمين إذا لم تعد تُستخدم
  final TextEditingController governorateController = TextEditingController();

  Future<bool> register() async {
    if (!formKey.currentState!.validate()) return false;

    if (!await checkInternet()) {
      Get.snackbar('تنبيه', 'لا يوجد اتصال بالإنترنت');
      return false;
    }

    isLoading.value = true;

    try {
      // الحصول على instance من LocationController
      final locationController = Get.find<LocationController>();

      final body = json.encode(RegisterModel(
        name: nameController.text,
        phone: phoneController.text,
        city: locationController.selectedRegion.value,
        detailsLocation: detailsController.text,
        governorate: locationController.selectedGovernorate.value,
        district: locationController.selectedDistrict.value,
      ).toJson());

      final response = await http.post(
        Uri.parse('https://nour-market.site/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['token'] != null) {
          final token = responseData['token'];
          await StorageService.setToken(token);
          Get.snackbar('نجاح', 'تم التسجيل بنجاح');
          return true;
        } else {
          Get.snackbar('خطأ', 'لم يتم استلام التوكن');
          return false;
        }
      } else {
        final errorMsg =
            json.decode(response.body)['message'] ?? 'فشل في التسجيل';
        Get.snackbar('خطأ', errorMsg);
        return false;
      }
    } catch (e) {
      Get.snackbar('خطأ تقني', 'حدث خطأ أثناء التسجيل: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        Get.offAllNamed(Routes.WELCOME);
        return;
      }

      // استرجاع معرف المستخدم من الـ Storage


      final response = await http.get(
        Uri.parse('https://nour-market.site/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await StorageService.deleteToken();
        Get.offAllNamed(Routes.WELCOME);
        Get.snackbar('نجاح', 'تم تسجيل الخروج');
      } else if (response.statusCode == 401) {
        await StorageService.deleteToken();
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('خطأ', 'فشل تسجيل الخروج');
      }
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    detailsController.dispose();
    governorateController.dispose();
    super.onClose();
  }
}
