import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarNew extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showDarkModeToggle;

  CustomAppBarNew({
    Key? key,
    required this.title,
    this.showDarkModeToggle = false,
  }) : super(key: key);

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

  final List<double> angles = [0.2, -0.2, 0.1, -0.1, 0.15, -0.15];

  static final List<Widget> randomIcons = [];
  static final List<double> randomAngles = [];

  static bool initialized = false;

  void initRandomIcons() {
    if (!initialized) {
      final Random random = Random();
      for (int i = 0; i < 50; i++) {
        randomIcons.add(
          supermarketIcons[random.nextInt(supermarketIcons.length)],
        );
        randomAngles.add(angles[random.nextInt(angles.length)]);
      }
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // الخلفية مع أيقونات السوبر ماركت
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
              // النص الرئيسي في المنتصف
              Positioned.fill(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              // عرض أيقونة تبديل الوضع فقط إذا كانت showDarkModeToggle true
              if (showDarkModeToggle)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                    child: IconButton(
                      icon: Icon(
                        Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.changeThemeMode(
                          Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
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
  Size get preferredSize => const Size.fromHeight(75);
}
