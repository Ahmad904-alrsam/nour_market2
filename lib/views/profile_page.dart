import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/register_controller.dart';
import '../controllers/faq_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/buildBannerNew.dart';
import '../widgets/faq_section.dart';
import '../widgets/menu_list.dart';
import '../widgets/profile_header.dart';
import '../widgets/user_info_card.dart';

class ProfilePage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final RegisterController registerController = Get.put(RegisterController());
  final FaqController faqController = Get.put(FaqController());

  ProfilePage({Key? key}) : super(key: key) {
    userController.getUserData();
    faqController.fetchFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBarNew(title: 'الملف الشخصي',showDarkModeToggle: true,),
      body: Obx(() => _buildBodyContent()),
    );
  }

  Widget _buildBodyContent() {
    if (userController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentUser = userController.user.value;
    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!currentUser.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.WELCOME);
        Get.snackbar('تنبيه', 'حسابك غير مفعل');
      });
      return Container();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHeader(user: currentUser),
          _buildEditButton(),
          UserInfoCard(user: currentUser),
          const MenuList(),
          FaqSection(faqController: faqController),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => Get.toNamed(Routes.EditProfilePage),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 10,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_note, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            const Text(
              'تعديل الملف الشخصي',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
