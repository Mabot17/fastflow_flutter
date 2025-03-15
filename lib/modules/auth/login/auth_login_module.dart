import 'package:get/get.dart';
import 'views/auth_login_view.dart';
import 'controllers/auth_login_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class AuthLoginModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.login,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
  ];
}

