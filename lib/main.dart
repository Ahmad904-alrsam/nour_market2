import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/home_binding.dart';
import 'controllers/banner_controller.dart';
import 'routes/app_pages.dart';

void main() {
  runApp(SupermarketApp());
}

class SupermarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supermarket App',
      initialRoute: AppPages.INITIAL,
      initialBinding:  HomeBinding(),

      getPages: AppPages.routes,
      // استخدام builder لتغليف التطبيق بـ Directionality وتعيين اتجاه RTL
      builder: (context, widget) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: widget!,
        );
      },
    );
  }
}
