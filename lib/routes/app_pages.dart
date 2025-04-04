import 'package:get/get.dart';
import 'package:nour_market2/views/OrdersPage.dart';
import 'package:nour_market2/views/favorite_view.dart';
import 'package:nour_market2/views/product_detailPage.dart';

import '../views/ProductsPage.dart';
import '../views/categories_page.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/notificationdetailsScreen.dart';
import '../views/register_view.dart';
import '../views/search_page.dart';
import '../views/splash_view.dart';
import '../views/subcategories_page.dart';
import '../views/welcome_view.dart';
import '../widgets/editprofilepage.dart';

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
    GetPage(
      name: _Paths.MY_ORDERS,
      page: () => OrdersPage(),
    ),


    GetPage(
      name: _Paths.Favorit,
      page: () => FavoritesPage()
    ),
    GetPage(
      name: _Paths.PRODUCT_DEATILS,

      page: () {
        final productId = Get.arguments as int; // نتأكد من أن المعرّف من النوع int
        return ProductDetailPage(productId: productId);
      },
    ),
    GetPage(name:_Paths.NOTIFICATION, page: () => NotificationDetailsScreen()),
    GetPage(name:_Paths.EditProfilePage, page: () => EditProfilePage()),
    GetPage(name:_Paths.SEARCH, page: () => SearchPage()),


  ];
}
