import 'package:get/get.dart';
import 'views/home_view.dart';
import 'controllers/home_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class HomeModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
      }),
    ),
  ];
}
