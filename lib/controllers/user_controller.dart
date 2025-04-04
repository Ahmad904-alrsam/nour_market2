import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../models/Order.dart';
import '../models/user.dart';
import '../routes/app_pages.dart';
import '../services/storageservice.dart';

class UserController extends GetxController {
  final Rx<User> user = User
      .empty()
      .obs;
  final isLoading = false.obs;
  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  final RxList<Order> orders = <Order>[].obs;


  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      print('تم اختيار الصورة: ${profileImage.value!.path}');
    } else {
      print('لم يتم اختيار أي صورة');
    }
  }

  Future<void> getUserData() async {
    try {
      isLoading(true);
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        _handleUnauthenticated();
        return;
      }

      final response = await GetConnect().get(
        'https://nour-market.site/api/users',
        headers: _authHeaders(token),
      );

      print('User Data Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        _handleSuccessResponse(response);
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      _handleException(e);
    } finally {
      isLoading(false);
    }
  }

  Map<String, String> _authHeaders(String token) =>
      {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  void _handleUnauthenticated() {
    Get.snackbar('Error', 'No authentication token found');
    Get.offAllNamed(Routes.LOGIN);
  }

  void _handleSuccessResponse(Response response) {
    try {
      final responseData = response.body;
      final userData = responseData['user'] ?? responseData['data'] ??
          responseData;
      user.value = User.fromJson(userData);
      print('User Data: ${user.value.toString()}');

      // تخزين معرف المستخدم باستخدام StorageService
      // تأكد من أن لديك دالة setUserId في StorageService تقوم بتخزين القيمة بالشكل المناسب
      StorageService.setUserId(user.value.id.toString());
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse user data: ${e.toString()}');
    }
  }


  void _handleErrorResponse(Response response) {
    final errorMessage = response.body['message'] ?? 'Failed to load user data';
    Get.snackbar('Error', errorMessage);
  }

  void _handleException(dynamic e) {
    Get.snackbar('Error', 'Exception occurred: ${e.toString()}');
  }

  // دالة تحديث بيانات المستخدم مع رفع الصورة (إن وُجدت)
  Future<void> updateUserWithImage({
    required String name,
    required String phone,
    required String city,
    required String detailsLocation,
    required String governorate,
    required String district,
  }) async {
    try {
      isLoading(true);
      print('بدء عملية تحديث بيانات المستخدم ورفع الصورة');
      final token = await StorageService.getToken();

      if (token == null) {
        print('لم يتم العثور على التوكن');
        Get.snackbar('Error', 'No authentication token found');
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final uri = Uri.parse('https://nour-market.site/api/users/update');
      print('رابط الباكيند: $uri');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['city'] = city;
      request.fields['detailsLocation'] = detailsLocation;
      request.fields['governorate'] = governorate;
      request.fields['district'] = district;

      print('بيانات الحقول المرسلة: name: $name, phone: $phone, city: $city, detailsLocation: $detailsLocation, governorate: $governorate, district: $district');

      if (profileImage.value != null) {
        print('تم اختيار الصورة: ${profileImage.value!.path}');
        var stream = http.ByteStream(profileImage.value!.openRead());
        var length = await profileImage.value!.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(profileImage.value!.path),
        );
        request.files.add(multipartFile);
        print('تم إضافة ملف الصورة مع الاسم: ${basename(profileImage.value!.path)}');
      } else {
        print('لم يتم اختيار صورة لإرفاقها');
      }

      final response = await request.send();
      print('تم إرسال الطلب. كود الاستجابة: ${response.statusCode}');

      final responseString = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseString);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Get.snackbar('Success', 'تم التحديث بنجاح');
        await getUserData();

        String? newImageUrl;

        // تحقق من البنية الفعلية للاستجابة هنا
        if (responseJson['user']?['image'] != null) {
          newImageUrl = responseJson['user']['image'];
        } else if (responseJson['image'] != null) {
          newImageUrl = responseJson['image'];
        } else if (responseJson['data']?['image'] != null) {
          newImageUrl = responseJson['data']['image'];
        }

        if (newImageUrl != null) {
          // إضافة النطاق إذا لزم الأمر
          if (!newImageUrl.startsWith('http')) {
            newImageUrl = 'https://nour-market.site$newImageUrl';
          }

          user.value = user.value.copyWith(image: newImageUrl);
          user.refresh(); // إشعار واجهة المستخدم بالتحديث
        }

      } else {
        // عرض رسالة الخطأ من الخادم
        final errorMessage = responseJson['message'] ?? 'فشل في التحديث';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      print('Exception occurred: ${e.toString()}');
      Get.snackbar('Error', 'حدث خطأ أثناء التحديث: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  ImageProvider getProfileImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // إذا كان الرابط محليًا يبدأ بـ file://، استخدم FileImage
      if (imageUrl.startsWith('file://')) {
        // إزالة "file://" للحصول على مسار الملف الصحيح
        final filePath = imageUrl.replaceFirst('file://', '');
        return FileImage(File(filePath));
      }
      // إذا لم يبدأ الرابط بـ http، فافترض أنه مسار نسبي وأضف عنوان الدومين
      if (!imageUrl.startsWith('http')) {
        imageUrl = 'https://nour-market.site$imageUrl';
      }
      return NetworkImage(imageUrl);
    }
    // إذا لم يكن هناك رابط صالح، استخدم صورة افتراضية من الأصول
    return const AssetImage('assets/images/default_avatar.png');
  }




  Future<void> deleteAccount() async {
    try {
      isLoading(true);
      final token = await StorageService.getToken();

      if (token == null) {
        Get.snackbar('Error', 'No authentication token found');
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final response = await GetConnect().post(
        'https://nour-market.site/api/users',
        {'_method': 'delete'},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await StorageService.deleteToken();
        Get.offAllNamed(Routes.LOGIN);
        Get.snackbar('Success', 'تم حذف الحساب بنجاح');
      } else {
        Get.snackbar('Error', 'فشل الحذف: ${response.body}');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> myOrder() async {
    try {
      isLoading(true);
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        _handleUnauthenticated();
        return;
      }

      final response = await GetConnect().get(
        'https://nour-market.site/api/orders',
        headers: _authHeaders(token),
      );

      print('Orders Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // تحويل الاستجابة إلى Map للتعامل معها
        final Map<String, dynamic> responseData = response.body;

        // التحقق من نجاح العملية عبر حقل "message" أو "body"
        final message = responseData['message'] ?? responseData['body'] ?? 'تم تحميل الطلبات بنجاح';

        // استخراج بيانات الطلبات من مفتاح orders ثم data
        if (responseData.containsKey('orders')) {
          final ordersResponse = responseData['orders'];
          if (ordersResponse is Map && ordersResponse.containsKey('data')) {
            final data = ordersResponse['data'];
            if (data is List) {
              orders.value = data.map<Order>((orderJson) => Order.fromJson(orderJson)).toList();
            } else {
              orders.clear();
            }
          } else {
            orders.clear();
          }
        } else {
          orders.clear();
        }

        Get.snackbar('Success', message);
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      _handleException(e);
    } finally {
      isLoading(false);
    }
  }

}