import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import '../models/storeSettings.dart';
import '../controllers/settings_controller.dart';
import 'home_view.dart';
import 'storeClosedView.dart';
import 'welcome_view.dart';

class SplashScreen extends StatelessWidget {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  SplashScreen({Key? key}) : super(key: key);

  Future<Widget> decideScreen() async {
    String? token = await secureStorage.read(key: 'jwt');

    if (token != null && token.isNotEmpty) {
      StoreSettings? settings = await fetchStoreSettings();
      if (settings != null) {
        bool open = isStoreOpen(settings);
        return open ? HomeView() : StoreClosedView(storeSettings: settings);
      }
      // إذا فشل جلب الإعدادات، انتقل إلى WelcomeView
      return WelcomeView();
    } else {
      return WelcomeView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;
        return AnimatedSplashScreen.withScreenFunction(
          backgroundColor: Colors.white,
          splashTransition: SplashTransition.fadeTransition,
          duration: 4000,
          splash: Center(
            child: Container(
              width: screenSize.width * 0.9, // 90% من عرض الشاشة
              height: screenSize.height * 0.7, // 70% من ارتفاع الشاشة
              child: Lottie.asset(
                'assets/Animation - 1741425156208.json',
                fit: BoxFit.contain,
              ),
            ),
          ),
          screenFunction: () async => await decideScreen(),
          curve: Curves.easeInOutCubic,
          splashIconSize: 280,
        );
      },
    );
  }
}
