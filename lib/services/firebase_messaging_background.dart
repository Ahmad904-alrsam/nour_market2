import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// دالة يجب أن تكون من مستوى أعلى (Top-level) لمعالجة الرسائل في الخلفية
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // تأكد من تهيئة Firebase أولاً
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // يمكنك هنا استخدام NotificationService لعرض إشعار مثلاً
}
