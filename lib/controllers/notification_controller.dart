import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final ApiService _apiService = ApiService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // متغيرات للباجينيشن
  int currentPage = 1;
  String? nextPageUrl;
  final RxBool isLoadingMore = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isInitialLoading = true.obs;


  @override
  void onInit() {
    super.onInit();
    _setupFirebase();
    fetchNotifications(); // جلب الصفحة الأولى
  }

  Future<void> _setupFirebase() async {
    // طلب الإذن للإشعارات
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _setupFirebaseListeners();
    }

    // الحصول على التوكن الأولي وإرساله للسيرفر
    _firebaseMessaging.getToken().then((token) {
      if (token != null) _sendTokenToServer(token);
    });

    // تحديث التوكن عند التغيير
    _firebaseMessaging.onTokenRefresh.listen(_sendTokenToServer);
  }

  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notifications.insert(0, NotificationModel.fromRemoteMessage(message));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });
  }

  Future<void> _sendTokenToServer(String token) async {
    await _apiService.post(
      'https://nour-market.site/api/device-token',
      {'token': token},
    );
  }

  /// دالة جلب الإشعارات مع دعم الباجينيشن
  Future<void> fetchNotifications({bool loadMore = false}) async {
    try {
      // إذا كنا نحاول تحميل المزيد ولكن لا يوجد رابط للصفحة التالية، نخرج من الدالة
      if (loadMore && (nextPageUrl == null || nextPageUrl!.isEmpty)) return;

      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isInitialLoading.value = true;
      }

      // تحديد الرابط المطلوب تحميله (الصفحة الأولى أو الصفحة التالية)
      final String url = loadMore
          ? nextPageUrl!
          : 'https://nour-market.site/api/notifications';

      // استخدم GET أو POST حسب ما يتطلبه الـ API
      final response = await http.get(Uri.parse(url));
      // final response = await http.post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: json.encode({}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['message'] == 'successful' &&
            responseData.containsKey('notifications')) {
          final notificationsData =
          responseData['notifications'] as Map<String, dynamic>;

          // تحديث معلومات الباجينيشن
          currentPage = notificationsData['current_page'] ?? 1;
          nextPageUrl = notificationsData['next_page_url'];

          // استخراج قائمة الإشعارات
          final List<dynamic> notificationsJson =
              notificationsData['data'] ?? [];
          final List<NotificationModel> notificationList = notificationsJson
              .map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>))
              .toList();

          // في حالة تحميل المزيد، نقوم بإلحاق النتائج الجديدة، وإلا نستبدل القائمة بأكملها
          if (loadMore) {
            notifications.addAll(notificationList);
          } else {
            notifications.assignAll(notificationList);
          }
        } else {
          Get.snackbar(
            'خطأ',
            'رسالة غير متوقعة: ${responseData['message'] ?? 'لا توجد رسالة'}',
          );
        }
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب الإشعارات: $e');
    } finally {
      if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isInitialLoading.value = false;
      }
      isLoading.value = false;
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final response = await _apiService.post(
        'https://nour-market.site/api/notifications/$id',
        {'_method': 'delete'}, // إرسال بيانات الحذف
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        notifications.removeWhere((n) => n.id.toString() == id);
        Get.snackbar('نجاح', 'تم الحذف بنجاح');
      } else {
        Get.snackbar('خطأ', 'فشل في الحذف، رمز الحالة: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في الحذف: $e');
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (data['route'] != null) {
      Get.toNamed(data['route']);
    }
  }

  void markAsRead(int id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(
        status: NotificationStatus.read,
      );
      notifications.refresh();
    }
  }
}
