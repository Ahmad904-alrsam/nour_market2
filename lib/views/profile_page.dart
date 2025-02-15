import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../widgets/buildBannerNew.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        CustomAppBarNew(title: 'الملف الشخصي',),

      body: Obx(() {
        if (profileController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (profileController.profile.value == null) {
          return Center(child: Text("لا يوجد بيانات"));
        } else {
          final profile = profileController.profile.value!;
          return SingleChildScrollView(
            child: Column(
              children: [
                // قسم بيانات المستخدم
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile.profileImage),
                      ),
                      SizedBox(height: 10),
                      Text(
                        profile.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(profile.phone),
                      SizedBox(height: 5),
                      Text("${profile.address}, ${profile.region}"),
                    ],
                  ),
                ),
                Divider(),
                // قائمة الخيارات
                ListTile(
                  leading: Icon(Icons.list_alt),
                  title: Text("حالة الطلب"),
                  onTap: () {
                    // الانتقال إلى صفحة حالة الطلب
                    Get.toNamed('/orderStatus');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text("الإشعارات"),
                  onTap: () {
                    // الانتقال إلى صفحة الإشعارات
                    Get.toNamed('/notifications');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_phone),
                  title: Text("تواصل معنا"),
                  onTap: () {
                    // الانتقال إلى صفحة تواصل معنا أو فتح نموذج الاتصال
                    Get.toNamed('/contactUs');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("تسجيل الخروج"),
                  onTap: () {
                    profileController.logout();
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
