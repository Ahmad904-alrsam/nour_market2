part of 'app_pages.dart';

abstract class Routes {
  static const SPLASH = _Paths.SPLASH;
  static const WELCOME = _Paths.WELCOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const HOME = _Paths.HOME;
  static const CATEGORIES = _Paths.CATEGORIES;
  static const SUBCATEGORIES = _Paths.SUBCATEGORIES;
  static const PRODUCT = _Paths.PRODUCT;


}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const CATEGORIES = '/categories';
  static const SUBCATEGORIES = '/subcategories';
  static const PRODUCT = '/products';


}
