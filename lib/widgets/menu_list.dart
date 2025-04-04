import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../controllers/faq_controller.dart';
import '../controllers/register_controller.dart';
import '../controllers/user_controller.dart';
import '../routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/FaqDetailPage.dart'; // تأكد من وجود هذا الملف واستيراده

class MenuList extends StatelessWidget {
  const MenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color:Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildMenuTile(
                icon: Icons.notifications_active,
                title: "الإشعارات",
                color: Colors.purple,
                onTap: () => Get.toNamed(Routes.NOTIFICATION),
              ),
              _buildDivider(),
              _buildMenuTile(
                icon: Icons.support_agent,
                title: "تواصل معنا",
                color: Colors.green,
                onTap: _showContactOptions,
              ),
              _buildDivider(),
              _buildMenuTile(
                icon: Icons.shopping_bag,
                title: "طلباتي",
                color: Colors.orange,
                onTap: () => Get.toNamed(Routes.MY_ORDERS),
              ),
              _buildDivider(),
              _buildMenuTile(
                icon: Icons.delete_outline,
                title: "حذف الحساب",
                color: Colors.red,
                onTap: Get.find<UserController>().deleteAccount,
              ),
              _buildDivider(),
              _buildMenuTile(
                icon: Icons.logout,
                title: "تسجيل الخروج",
                color: Colors.redAccent,
                onTap: Get.find<RegisterController>().logout,
              ),
              _buildDivider(),
              _buildMenuTile(
                icon: Icons.question_mark,
                title: "الشروط والاحكام",
                color: Colors.blueGrey,
                onTap: () {
                  final faqController = Get.find<FaqController>();
                  if (faqController.termsFaq.value != null) {
                    Get.to(() => FaqDetailPage(faq: faqController.termsFaq.value));
                  } else {
                    Get.snackbar("خطأ", "لا توجد بيانات للشروط والاحكام");
                  }
                },
              ),
              _buildDivider(),
              _buildMenuTile(
                icon: Icons.question_answer_sharp,
                title: "سياسة الخصوصية",
                color: Colors.blueAccent,
                onTap: () {
                  final faqController = Get.find<FaqController>();
                  if (faqController.privacyFaq.value != null) {
                    Get.to(() => FaqDetailPage(faq: faqController.privacyFaq.value));
                  } else {
                    Get.snackbar("خطأ", "لا توجد بيانات لسياسة الخصوصية");
                  }
                },
              ),
              _buildDivider(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required Color color,
    required Function() onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 26),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey[800],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 24,
      color: Colors.grey[300],
      thickness: 0.8,
    );
  }

  void _showContactOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green[700]),
              title: const Text("واتساب"),
              onTap: () {
                _launchURL("https://wa.me/+963981541996");
              },
            ),
            ListTile(
              leading: Icon(Icons.telegram, color: Colors.blue[700]),
              title: const Text("تلغرام"),
              onTap: () {
                _launchURL("https://t.me/username"); // عدل الرابط حسب المستخدم
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.purple[700]),
              title: const Text("انستجرام"),
              onTap: () {
                _launchURL("https://instagram.com/username"); // عدل الرابط حسب المستخدم
              },
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.lightBlue[700]),
              title: const Text("تويتر"),
              onTap: () {
                _launchURL("https://twitter.com/username"); // عدل الرابط حسب المستخدم
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('خطأ', 'تعذر فتح الرابط');
    }
  }
}
