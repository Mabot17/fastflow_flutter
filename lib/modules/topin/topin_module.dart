import 'package:get/get.dart';
import 'views/topin_view.dart';
import 'controllers/topin_controller.dart';
import 'package:fastflow_flutter/routes/app_routes_constant.dart';

class TopinModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.topin,
      page: () => TopinView(),
      binding: BindingsBuilder(() {
        Get.put(TopinController());
      }),
    ),
  ];
}
