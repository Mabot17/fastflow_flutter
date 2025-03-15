import 'package:get/get.dart';
import 'views/auth_splash_view.dart';
import 'controllers/auth_splash_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class AuthSplashModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.splash, // Gunakan konstanta global
      page: () => SplashView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => SplashController())),
    ),
  ];
}
