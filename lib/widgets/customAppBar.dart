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

  // قائمة زوايا التدوير (بالراديان) لتنوع الميلان
  final List<double> angles = [0.2, -0.2, 0.1, -0.1, 0.15, -0.15];

  @override
  Widget build(BuildContext context) {
    // إنشاء كائن Random واحد للاستخدام في كل العناصر
    final Random random = Random();

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
              // خلفية الأيقونات المائلة بشكل عشوائي
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: 50,
                    itemBuilder: (context, index) {
                      final Widget iconWidget = supermarketIcons[
                      random.nextInt(supermarketIcons.length)];
                      final double angle =
                      angles[random.nextInt(angles.length)];
                      return Transform.rotate(
                        angle: angle,
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: iconWidget,
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
                        // صف البيانات الشخصية والأيقونات (يمكنك إضافة المزيد من العناصر هنا إذا رغبت)
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
                        // حقل البحث المصغر مع تبديل مواقع الأيقونات
                        Container(
                          width: 280, // تحديد عرض مربع البحث ليكون أقل عرضًا
                          height: 36, // تحديد ارتفاع مربع البحث
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
                              // الآن نضع أيقونة البحث كبادئة (prefix) وأيقونة التصفية كلاحقة (suffix)
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
