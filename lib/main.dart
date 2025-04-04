import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_market2/services/firebase_messaging_background.dart';
import 'package:nour_market2/services/storageservice.dart';
import 'bindings/home_binding.dart';
import 'controllers/fav_product_controller.dart';
import 'routes/app_pages.dart';

// تهيئة الإشعارات المحلية
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// إنشاء قناة الإشعارات
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // يجب أن يتطابق مع الـ channel_id في الـ Manifest
  'إشعارات مهمة',
  importance: Importance.high,
  playSound: true,
);

// دالة لمعالجة الرسائل عند وصولها في الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // يمكنك هنا معالجة الرسالة مثل عرض إشعار محلي باستخدام flutterLocalNotificationsPlugin
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // تهيئة معالج الرسائل في الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // طلب إذن الإشعارات (مهم لـ Android 13+)
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  // الاشتراك في إشعارات "users" للجميع
  FirebaseMessaging.instance.subscribeToTopic("users");

  // الاشتراك في إشعارات المستخدم إذا كان معرف المستخدم موجودًا
  final userId = await StorageService.getUserId();
  if (userId != null) {
    FirebaseMessaging.instance.subscribeToTopic(userId);
  }

  // تهيئة الإشعارات المحلية
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: initializationSettingsAndroid,
    ),
    // يمكن إضافة onSelectNotification لمعالجة النقر على الإشعار
  );

  // إنشاء قناة الإشعارات
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // معالجة الرسائل في الواجهة الأمامية
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    // عرض الإشعار محلياً عند وصول رسالة إذا كان لها إعدادات مناسبة
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: '@mipmap/ic_launcher',
            // يمكنك إضافة إعدادات أخرى هنا
          ),
        ),
      );
    }
  });

  // لمعالجة الرسائل عند النقر على الإشعار (عند فتح التطبيق)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // يمكنك التوجيه إلى صفحة معينة أو معالجة الرسالة كما تشاء
    print('Message clicked!: ${message.messageId}');
  });

  runApp(SupermarketApp());
}

class SupermarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supermarket App',
      initialRoute: AppPages.INITIAL,
      initialBinding: HomeBinding(),
      getPages: AppPages.routes,
      theme: ThemeData.light(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900], // خلفية أخف
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // لون أب بار أخف
          iconTheme: IconThemeData(color: Colors.white),
        ),
        // يمكنك تخصيص باقي الألوان حسب الحاجة
      ),
      // اختر الثيم بناءً على Get.isDarkMode
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, widget) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: widget!,
        );
      },
    );
  }
}
