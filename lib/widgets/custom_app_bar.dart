import 'dart:math';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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

  // قائمة زوايا التدوير (بالراديان) لتنوع الميلان مع زيادة الميلان
  final List<double> angles = [0.3, -0.3, 0.25, -0.25, 0.35, -0.35];

  // تخزين الأيقونات العشوائية وزوايا الدوران لمرة واحدة فقط
  static final List<Widget> randomIcons = [];
  static final List<double> randomAngles = [];
  static bool initialized = false;

  // دالة لتوليد الأيقونات العشوائية لمرة واحدة فقط
  void initRandomIcons() {
    if (!initialized) {
      final Random random = Random();
      for (int i = 0; i < 50; i++) {
        randomIcons.add(supermarketIcons[random.nextInt(supermarketIcons.length)]);
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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
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
                  opacity: 0.12,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8), // زيادة الحواف الخارجية
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 10,  // زيادة المسافة الأفقية
                      mainAxisSpacing: 10,   // زيادة المسافة العمودية
                    ),
                    itemCount: randomIcons.length,
                    itemBuilder: (context, index) {
                      return Transform.rotate(
                        angle: randomAngles[index],
                        child: SizedBox(
                          width: 40,  // زيادة حجم الأيقونات
                          height: 40, // زيادة حجم الأيقونات
                          child: randomIcons[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // المحتوى الأساسي للـ AppBar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // صف البيانات الشخصية والأيقونات
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: CircleAvatar(
                                radius: 20, // تقليل حجم الصورة الشخصية
                                backgroundColor: Colors.yellow,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "أهلاً 👋",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  "Ahmad",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        // حقل البحث المصغر
                        Container(
                          width: 280,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "هل تبحث عن شيء...",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Icon(
                                  Icons.filter_list,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
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
  Size get preferredSize => Size.fromHeight(100);
}
