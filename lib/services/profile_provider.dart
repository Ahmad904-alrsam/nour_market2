import 'package:get/get.dart';
import '../models/Profile.dart';

class ProfileService extends GetConnect {
  Future<Profile> getProfile() async {
    // بيانات وهمية لمحاكاة استجابة الـ API
    final Map<String, dynamic> fakeResponse = {
      "name": "محمد أحمد",
      "phone": "0123456789",
      "address": "شارع النيل",
      "region": "القاهرة",
      "profileImage": "https://i.pravatar.cc/150?img=3" // صورة وهمية
    };

    // محاكاة تأخير الشبكة لمدة ثانيتين
    await Future.delayed(Duration(seconds: 2));

    // إعادة البيانات باستخدام الدالة fromJson في الموديل
    return Profile.fromJson(fakeResponse);
  }
}
