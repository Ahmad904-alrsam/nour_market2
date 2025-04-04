import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nour_market2/controllers/notification_controller.dart';
import '../controllers/search_controller.dart';
import '../controllers/user_controller.dart';
import '../models/notification_model.dart';
import '../routes/app_pages.dart';
import 'favoriteBadge.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> supermarketIcons = [
    Image.asset('assets/icons/img.png'),
    Image.asset('assets/icons/img_1.png'),
    Image.asset('assets/icons/img_2.png'),
    Image.asset('assets/icons/img_3.png'),
    Image.asset('assets/icons/img_4.png'),
    Image.asset('assets/icons/img_5.png'),
    Image.asset('assets/icons/img_6.png'),
    Image.asset('assets/icons/img_7.png'),
    Image.asset('assets/icons/img_8.png'),
    Image.asset('assets/icons/img_9.png'),
    Image.asset('assets/icons/img_10.png'),
  ];

  final List<double> angles = [0.3, -0.3, 0.25, -0.25, 0.35, -0.35];

  // تخزين الأيقونات العشوائية وزوايا الدوران لمرة واحدة فقط
  static final List<Widget> randomIcons = [];
  static final List<double> randomAngles = [];
  static bool initialized = false;

  final UserController userController = Get.put(UserController());
  final NotificationController notificationController = Get.find<NotificationController>();

  final SearchControllerApi searchController = Get.put(SearchControllerApi());
  final TextEditingController searchTextController = TextEditingController();

  CustomAppBar({Key? key}) : super(key: key);

  void initRandomIcons() {
    if (!initialized) {
      final Random random = Random();
      for (int i = 0; i < 50; i++) {
        randomIcons.add(supermarketIcons[random.nextInt(supermarketIcons.length)]);
        randomAngles.add(angles[random.nextInt(angles.length)]);
      }
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // تشغيل التهيئة لمرة واحدة
    initRandomIcons();

    return PreferredSize(
      preferredSize: preferredSize,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // الخلفية العشوائية
              Positioned.fill(
                child: Opacity(
                  opacity: 0.12,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: randomIcons.length,
                    itemBuilder: (context, index) {
                      return Transform.rotate(
                        angle: randomAngles[index],
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: randomIcons[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // المحتوى العلوي مع SafeArea
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                    child: Column(
                      children: [
                        // الصف العلوي: صورة المستخدم + نص الترحيب + الشعار + أيقونة التنبيهات
                        Row(
                          children: [
                            // معلومات المستخدم
                            Obx(() {
                              final user = userController.user.value;

                              return Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: user.image != null && user.image!.isNotEmpty
                                        ? (user.image!.startsWith('http')
                                        ? user.image!
                                        : 'https://nour-market.site${user.image}')
                                        : 'https://nour-market.site/assets/images/default_avatar.png',
                                    imageBuilder: (context, imageProvider) => CircleAvatar(
                                      backgroundImage: imageProvider,
                                      radius: 20,
                                    ),
                                    placeholder: (context, url) => const CircleAvatar(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                      radius: 20,
                                    ),
                                    errorWidget: (context, url, error) => const CircleAvatar(
                                      backgroundImage: AssetImage('assets/images/default_avatar.png'),
                                      radius: 20,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "أهلاً 👋",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            user.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          if (user.isFavorite) const FavoriteBadge(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                            SizedBox(width: 50.w),
                            // الشعار المركزي
                            Image.asset(
                              'assets/images/photo_2025-02-04_16-43-45-removebg-preview.png',
                              width: 50.w,
                            ),
                            const Spacer(),
                            Obx(() {
                              // نفترض أن الحالة التي تعبر عن الإشعار غير المقروء هي NotificationStatus.unread
                              bool hasUnread = notificationController.notifications.any(
                                    (notification) => notification.status == NotificationStatus.unread,
                              );
                              return Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white.withOpacity(0.4),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.NOTIFICATION);
                                      },
                                      icon: const Icon(
                                        Icons.notifications,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                  if (hasUnread)
                                    const Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Icon(
                                        Icons.brightness_1, // أيقونة دائرية
                                        color: Colors.red,
                                        size: 12,
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // شريط البحث المخصص مع وصل مباشر بين حقل البحث وزر الفلتر
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Stack(
                            children: [
                              // الخلفية المرسومة باستخدام CustomPainter
                              CustomPaint(
                                size: const Size(double.infinity, 40),
                                painter: ReversedSearchBarPainter(),
                              ),
                              // المحتوى: أيقونة البحث، حقل البحث وزر الفلتر متصلين
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    // أيقونة البحث
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.grey.shade600,
                                        size: 24,
                                      ),
                                    ),
                                    // حقل البحث (يتوسع لملئ المساحة المتبقية)
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        alignment: Alignment.centerRight,
                                        child: TextField(
                                          onSubmitted: (query) {
                                            // عند الضغط على زر الإدخال يتم الانتقال لصفحة البحث مع تمرير قيمة البحث
                                            Get.toNamed(Routes.SEARCH, arguments: {'query': query});
                                          },
                                          controller: searchTextController,
                                          textAlign: TextAlign.right,
                                          decoration: const InputDecoration(
                                            hintText: 'هل تبحث عن شي...',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // زر الفلتر (بدون Padding إضافي ليكون متصلاً)
                GestureDetector(
                  onTap: () {
                    // عند الضغط على زر الفلتر، يتم الانتقال إلى صفحة البحث
                    // يمكنك تمرير معطيات إضافية إذا احتجت
                    Get.toNamed('/search');
                  },
                                      child: Container(

                                        width: 60,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFC107),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.filter_list,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 6),
                                              const Text(
                                                'فلتر',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class ReversedSearchBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double filterWidth = 60; // مطابق لعرض زر الفلتر
    double radius = 10;

    Paint whitePaint = Paint()..color = Colors.white;
    Path path = Path();

    // بداية الرسم من الطرف العلوي الأيسر (أي بعد زر الفلتر)
    path.moveTo(filterWidth + radius, 20);
    // الخط العلوي
    path.lineTo(size.width - radius, 0);
    // الزاوية العلوية اليمنى
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    // الخط اليميني
    path.lineTo(size.width, size.height - radius);
    // الزاوية السفلية اليمنى
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    // الخط السفلي حتى نقطة قبل المنطقة اليسرى
    path.lineTo(filterWidth + radius, size.height);
    // الزاوية السفلية اليسرى بشكل ناعم
    path.arcToPoint(
      Offset(filterWidth, size.height - radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    // الخط العمودي الصاعد للجانب الأيسر
    path.lineTo(filterWidth, radius);
    // الزاوية العلوية اليسرى بشكل ناعم
    path.arcToPoint(
      Offset(filterWidth + radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.close();

    canvas.drawPath(path, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
