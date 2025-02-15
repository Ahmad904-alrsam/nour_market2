
import 'dart:math';

import 'package:flutter/material.dart';

class CustomAppBarNew extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBarNew({Key? key, required this.title}) : super(key: key);

  // قائمة الأيقونات الخاصة بالسوبر ماركت (صور من الأصول)
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

  // قائمة زوايا التدوير (بالراديان) لتنوع الميلان
  final List<double> angles = [0.2, -0.2, 0.1, -0.1, 0.15, -0.15];

  // تخزين أيقونات عشوائية ثابتة عند إنشاء الـ AppBar لأول مرة
  static final List<Widget> randomIcons = [];
  static final List<double> randomAngles = [];

  static bool initialized = false; // للتحكم في التهيئة لمرة واحدة فقط

  // دالة لتوليد أيقونات عشوائية فقط مرة واحدة
  void initRandomIcons() {
    if (!initialized) {
      final Random random = Random();
      for (int i = 0; i < 50; i++) {
        randomIcons.add(
            supermarketIcons[random.nextInt(supermarketIcons.length)]);
        randomAngles.add(angles[random.nextInt(angles.length)]);
      }
      initialized = true; // منع التهيئة مرة أخرى
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
              // خلفية الأيقونات العشوائية (ثابتة لا تتغير)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: randomIcons.length,
                    itemBuilder: (context, index) {
                      return Transform.rotate(
                        angle: randomAngles[index],
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: randomIcons[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // النص الرئيسي "الأقسام" في المنتصف
              Positioned.fill(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
  Size get preferredSize => const Size.fromHeight(100);
}