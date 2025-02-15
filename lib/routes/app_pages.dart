import 'package:get/get.dart';

import '../views/ProductsPage.dart';
import '../views/categories_page.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/splash_view.dart';
import '../views/subcategories_page.dart';
import '../views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
    ),
    // إضافة صفحة الأقسام
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => CategoriesPage(),
    ),
    // إضافة صفحة التصنيفات الفرعية
    GetPage(
      name: _Paths.SUBCATEGORIES,
      page: () => SubCategoriesPage(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => ProductsPage(),
    ),
  ];
}
