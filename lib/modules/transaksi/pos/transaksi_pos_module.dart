import 'package:get/get.dart';
import 'views/transaksi_pos_view.dart';
import 'views/transaksi_pos_detail_view.dart'; // Import detail view
import 'views/transaksi_pos_list_view.dart'; // Import detail view
import 'controllers/transaksi_pos_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class TransaksiPosModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.pos,
      page: () => TransaksiPosView(),
      binding: BindingsBuilder(() {
        Get.put(TransaksiPosController());
      }),
    ),
    GetPage(
      name: "${AppRoutesConstants.pos}/list", // Route untuk detail transaksi
      page: () => TransaksiPosListView(),
    ),
    GetPage(
      name: "${AppRoutesConstants.pos}/:id", // Route untuk detail transaksi
      page: () => TransaksiPosDetailView(),
    ),
  ];
}
